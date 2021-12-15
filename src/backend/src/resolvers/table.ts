import { BookingStatus, MenuItem, UserRole } from "@prisma/client";
import { AuthenticationError, UserInputError } from "apollo-server-errors";
import { Resolvers } from "../generated/graphql";
import { PubSub } from 'graphql-subscriptions';

const pubsub = new PubSub();

export const tablesResolvers: Resolvers = {
  Subscription: {
    validationPrompted: {
      async *subscribe() {
        yield pubsub.asyncIterator('VALIDATION_PROMPTED');
      },
      resolve: (msg: any) => {
        return msg;
      }
    }
  },
  Query: {
    promptValidation: async(parent, args, ctx) => {
      if(ctx.token.userId !== "TABLE") {
        throw new AuthenticationError("only accessible by table control");
      }
      
      const booking = await ctx.prisma.booking.findFirst({
        where: {
          tableId: args.tableId,
          NOT: {
            OR: [
              {
                status: BookingStatus.RESERVED
              },
              {status: BookingStatus.DONE}
            ]
          }
        }
      });

      if(!booking) {
        return false;
      }

      console.log(booking.joinValidationData);
      pubsub.publish("VALIDATION_PROMPTED", booking.joinValidationData);
      return true;
    }
  },
  Mutation: {},
};
