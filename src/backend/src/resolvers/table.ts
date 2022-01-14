import { BookingStatus, MenuItem, UserRole } from "@prisma/client";
import { AuthenticationError, UserInputError } from "apollo-server-errors";
import { Resolvers } from "../generated/graphql";
import { PubSub } from "graphql-subscriptions";
import { withFilter } from "graphql-subscriptions";

const pubsub = new PubSub();

export const tablesResolvers: Resolvers = {
  Subscription: {
    validationPrompted: {
      // @ts-ignore
      subscribe: () => pubsub.asyncIterator("VALIDATION_PROMPTED"),
      resolve: (msg: any) => {
        return msg;
      }
    },
  },
  Query: {
    promptValidation: async (parent, args, ctx) => {
      const booking = await ctx.prisma.booking.findFirst({
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
