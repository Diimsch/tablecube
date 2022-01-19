import { BookingStatus, MenuItem, UserRole } from "@prisma/client";
import { AuthenticationError, UserInputError } from "apollo-server-errors";
import { Resolvers } from "../generated/graphql";
import { PubSub } from "graphql-subscriptions";
import { withFilter } from "graphql-subscriptions";

export const pubsub = new PubSub();

export const tablesResolvers: Resolvers = {
  Table: {
    bookings: async (parent, args, ctx) => {
      if (ctx.token.type === "ROBOT" && ctx.token.userId === parent.id) {
        const bookings = await ctx.prisma.booking.findMany({
          where: {
            tableId: parent.id,
          },
        });
        return bookings;
      }
      const bookings = await ctx.prisma.booking.findMany({
        where: {
          tableId: parent.id,
          users: {
            every: {
              userId: ctx.token.userId!,
            },
          },
        },
      });
      return bookings;
    },
    occupyingBooking: async (parent, args, ctx) => {
      const current = new Date();
      const booking = await ctx.prisma.booking.findFirst({
        where: {
          tableId: parent.id,
          OR: [
            {
              status: {
                notIn: ["DONE", "RESERVED"],
              },
            },
            {
              status: {
                not: "DONE",
              },
              start: {
                lt: current,
              },
              end: {
                gte: current,
              },
            },
          ],
        },
      });
      return booking;
    },
  },
  Subscription: {
    validationPrompted: {
      // @ts-ignore
      subscribe: () => pubsub.asyncIterator("VALIDATION_PROMPTED"),
      resolve: (msg: any) => {
        return msg;
      },
    },
    tableUpdated: {
      // @ts-ignore
      subscribe: () => pubsub.asyncIterator("TABLE_UPDATED"),
      resolve: (msg: any) => {
        return msg;
      },
    },
  },
  Query: {
    table: async (parent, args, ctx) => {
      const table = await ctx.prisma.table.findUnique({
        where: {
          id: args.tableId,
        },
      });
      return table;
    },
    promptValidation: async (parent, args, ctx) => {
      let booking = await ctx.prisma.booking.findFirst({
        where: {
          tableId: args.tableId,
          NOT: {
            OR: [
              {
                status: BookingStatus.RESERVED,
              },
              { status: BookingStatus.DONE },
            ],
          },
        },
      });

      if (!booking) {
        const current = new Date();
        booking = await ctx.prisma.booking.findFirst({
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
      }

      if (!booking) {
        return false;
      }

      console.log(booking.joinValidationData);
      pubsub.publish("VALIDATION_PROMPTED", {
        tableId: args.tableId,
        code: booking.joinValidationData,
      });
      return true;
    },
  },
  Mutation: {
    addItemToTable: async (parent, args, ctx) => {
      const user = await ctx.prisma.user.findUnique({
        where: {
          id: ctx.token.userId!,
        },
        include: {
          rolesInRestaurants: true,
        },
      });

      if (!user) {
        throw new AuthenticationError("invalid user");
      }

      const current = new Date();
      const booking = await ctx.prisma.booking.findFirst({
        where: {
          tableId: args.data.tableId,
          OR: [
            {
              status: {
                notIn: ["DONE", "RESERVED"],
              },
            },
            {
              status: {
                not: "DONE",
              },
              start: {
                lt: current,
              },
              end: {
                gte: current,
              },
            },
          ],
        },
      });

      if (!booking) {
        throw new UserInputError(
          "booking doesn't exist or user not part of booking"
        );
      }

      const role = user.rolesInRestaurants.find(
        (userRole) => userRole.restaurantId === booking.restaurantId
      );
      if (!role || role.role === "NONE") {
        const isAtBooking = await ctx.prisma.usersAtBooking.findUnique({
          where: {
            userId_bookingId: {
              bookingId: booking.id,
              userId: user.id,
            },
          },
        });

        if (!isAtBooking) {
          throw new UserInputError(
            "booking doesn't exist or user not part of booking"
          );
        }
      }

      await ctx.prisma.itemsOnBooking.create({
        data: {
          bookingId: booking.id,
          itemId: args.data.itemId,
          comment: args.data.comment,
        },
      });

      return ctx.prisma.booking.findUnique({
        where: {
          id: booking.id,
        },
      });
    },
  },
};
