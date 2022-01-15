import { BookingStatus, MenuItem, UserRole } from "@prisma/client";
import { AuthenticationError, UserInputError } from "apollo-server-errors";
import { Resolvers } from "../generated/graphql";
import { PubSub } from "graphql-subscriptions";
import { withFilter } from "graphql-subscriptions";

const pubsub = new PubSub();

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
  },
  Subscription: {
    validationPrompted: {
      // @ts-ignore
      subscribe: () => pubsub.asyncIterator("VALIDATION_PROMPTED"),
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
  Mutation: {},
};
