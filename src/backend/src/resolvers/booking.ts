import { Booking, BookingStatus, MenuItem, PrismaClient, UserRole } from "@prisma/client";
import { AuthenticationError, UserInputError } from "apollo-server-errors";
import ms from "ms";
import { Resolvers } from "../generated/graphql";
import { generateValidatorCode } from "../utils";

export const bookingResolvers: Resolvers = {
  BookingItem: {
    item: async (parent, args, ctx) => {
      const item = await ctx.prisma.menuItem.findUnique({
        where: {
          id: parent.itemId,
        },
      });
      // the exclamation mark tells typescript that this field is safe to interpret as never null.
      return item!;
    },
  },
  Booking: {
    table: async (parent, args, ctx) => {
      const table = await ctx.prisma.table.findUnique({
        where: {
          id: parent.tableId,
        },
      });
      return table!;
    },
    items: async (parent, args, ctx) => {
      const items = await ctx.prisma.itemsOnBooking.findMany({
        where: {
          bookingId: parent.id,
        },
        include: {
          item: true,
        },
      });
      return items;
    },
  },
  Query: {
    booking: async (parent, args, ctx): Promise<Booking> => {
      if (!ctx.token.userId) {
        throw new AuthenticationError("not signed in");
      }

      const user = await ctx.prisma.user.findUnique({
        where: {
          id: ctx.token.userId,
        },
        include: {
          rolesInRestaurants: true,
        },
      });

      if (!user) {
        throw new AuthenticationError("invalid user");
      }

      const booking = await ctx.prisma.booking.findUnique({
        where: {
          id: args.bookingId,
        },
        include: {
          users: true,
        },
      });

      if (
        booking?.users.find((u) => u.userId !== user.id) &&
        user.rolesInRestaurants.find(
          (r) => r.restaurantId !== booking?.restaurantId
        )
      ) {
        throw new UserInputError("not allowed to receive this booking");
      }
      return booking as Booking;
    },
  },
  Mutation: {
    createBooking: async (parent, args, ctx) => {
      if (!ctx.token.userId) {
        throw new AuthenticationError("not signed in");
      }

      const user = await ctx.prisma.user.findUnique({
        where: {
          id: ctx.token.userId,
        },
        include: {
          rolesInRestaurants: true,
        },
      });

      if (!user) {
        throw new AuthenticationError("invalid user");
      }

      const validatorColorCode = generateValidatorCode();

      const current = new Date();
      if (!args.booking.start) {
        args.booking.start = current;
      }

      if (!args.booking.end) {
        args.booking.end = new Date(current.getTime() + ms("1h"));
      }

      if (
        args.booking.start.getTime() < current.getTime() ||
        args.booking.end.getTime() < current.getTime()
      ) {
        throw new UserInputError("start or end date smaller than current date");
      }

      const bookings = await ctx.prisma.booking.findMany({
        where: {
          tableId: args.booking.tableId,
          status: {
            not: "DONE",
          },
          OR: [
            {
              start: {
                lt: args.booking.start,
              },
              end: {
                gte: args.booking.start,
              },
            },
            {
              AND: [
                {
                  start: {
                    gte: args.booking.start,
                  },
                },
                {
                  start: {
                    lte: args.booking.end,
                  },
                },
              ],
            },
          ],
        },
      });

      if (bookings.length > 0) {
        throw new UserInputError(
          "table currently still being served or already reserved"
        );
      }

      const booking = await ctx.prisma.booking.create({
        data: {
          tableId: args.booking.tableId,
          start: args.booking.start,
          end: args.booking.end,
          restaurantId: args.booking.restaurantId,
          joinValidationData: validatorColorCode,
          status: BookingStatus.RESERVED,
          users: {
            create: {
              userId: user.id,
              role: "HOST",
            },
          },
        },
      });
      console.log(`validation data for ${booking.id}: ${validatorColorCode}`);

      return booking;
    },
    joinBooking: async (parent, args, ctx) => {
      if (!ctx.token.userId) {
        throw new AuthenticationError("not signed in");
      }

      const user = await ctx.prisma.user.findUnique({
        where: {
          id: ctx.token.userId,
        },
        include: {
          rolesInRestaurants: true,
        },
      });

      if (!user) {
        throw new AuthenticationError("invalid user");
      }

      const booking = await ctx.prisma.booking.findFirst({
        where: {
          tableId: args.data.tableId,
          status: BookingStatus.CHECKED_IN,
        },
      });

      if (!booking) {
        throw new UserInputError("no ready booking at table");
      }

      if (
        args.data.colorCode.toString() !==
        booking.joinValidationData?.toString()
      ) {
        throw new UserInputError("invalid color validation code");
      }

      await ctx.prisma.usersAtBooking.create({
        data: {
          bookingId: booking.id,
          role: "GUEST",
          userId: user.id,
        },
      });

      return booking;
    },
    addItemToBooking: async (parent, args, ctx) => {
      if (!ctx.token.userId) {
        throw new AuthenticationError("not signed in");
      }

      const user = await ctx.prisma.user.findUnique({
        where: {
          id: ctx.token.userId,
        },
        include: {
          rolesInRestaurants: true,
        },
      });

      if (!user) {
        throw new AuthenticationError("invalid user");
      }

      const isAtBooking = await ctx.prisma.usersAtBooking.findUnique({
        where: {
          userId_bookingId: {
            bookingId: args.data.bookingId,
            userId: user.id,
          },
        },
      });

      if (!isAtBooking) {
        throw new UserInputError(
          "booking doesn't exist or user not part of booking"
        );
      }

      await ctx.prisma.itemsOnBooking.create({
        data: {
          bookingId: args.data.bookingId,
          itemId: args.data.itemId,
          comment: args.data.comment,
        },
      });

      return ctx.prisma.booking.findUnique({
        where: {
          id: args.data.bookingId,
        },
      });
    },
    payItems: async (parent, args, ctx) => {
      if (!ctx.token.userId) {
        throw new AuthenticationError("not signed in");
      }

      const user = await ctx.prisma.user.findUnique({
        where: {
          id: ctx.token.userId,
        },
        include: {
          rolesInRestaurants: true,
        },
      });

      if (!user) {
        throw new AuthenticationError("invalid user");
      }

      await ctx.prisma.itemsOnBooking.updateMany({
        where: {
          id: {
            in: args.bookingItemId,
          },
          booking: {
            users: {
              every: {
                userId: user.id
              }
            }
          },
          paid: false
        },
        data: {
          paid: true,
        }
      });

      const bookings = await ctx.prisma.itemsOnBooking.findMany({
        where: {
          id: {
            in: args.bookingItemId,
          },
          booking: {
            users: {
              every: {
                userId: user.id
              }
            }
          },
        },
      });
      return bookings;
    },
    checkIn: async (parent, args, ctx) => {
      if (!ctx.token.userId) {
        throw new AuthenticationError("not signed in");
      }

      const user = await ctx.prisma.user.findUnique({
        where: {
          id: ctx.token.userId,
        },
        include: {
          rolesInRestaurants: true,
        },
      });

      if (!user) {
        throw new AuthenticationError("invalid user");
      }

      const current = new Date();
      const nextBooking = await ctx.prisma.booking.findFirst({
        where: {
          tableId: args.tableId,
          status: "RESERVED",
          start: {
            lte: current,
          },
          end: {
            gte: current,
          },
        },
        orderBy: {
          start: "asc",
        },
      });

      if (!nextBooking) {
        throw new UserInputError("no open booking found");
      }

      if (nextBooking.joinValidationData?.toString() !== args.code.toString()) {
        throw new UserInputError("invalid color validation code");
      }

      const booking = await ctx.prisma.booking.update({
        where: {
          id: nextBooking.id,
        },
        data: {
          status: "CHECKED_IN",
        },
      });

      return booking;
    },
    changeBookingStatus: async (parent, args, ctx) => {
      if (!ctx.token.userId) {
        throw new AuthenticationError("not signed in");
      }

      const user = await ctx.prisma.user.findUnique({
        where: {
          id: ctx.token.userId,
        },
        include: {
          rolesInRestaurants: true,
        },
      });

      if (!user) {
        throw new AuthenticationError("invalid user");
      }

      if(args.data.status === BookingStatus.RESERVED || args.data.status === BookingStatus.CHECKED_IN) {
        throw new UserInputError("cant use reserved or checked_in state in this method");
      }

      let bookings = await ctx.prisma.booking.findMany({
        where: {
          tableId: args.data.tableId,
          status: {
            notIn: ["DONE", "RESERVED"],
          },
        },
      });

      if(bookings.length < 1) {
        throw new UserInputError("couldn't find active booking for specified table");
      }

      const booking = await ctx.prisma.booking.update({
        where: {
          id: bookings[0].id,
        },
        data: {
          status: args.data.status,
        },
      });

      return booking;
    },
  },
};
