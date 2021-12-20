import { BookingStatus, MenuItem, UserRole } from "@prisma/client";
import { AuthenticationError, UserInputError } from "apollo-server-errors";
import { Resolvers, UserRoleInRestaurant, UserRoles } from "../generated/graphql";
import { PubSub } from "graphql-subscriptions";
import { withFilter } from "graphql-subscriptions";

const pubsub = new PubSub();

export const restaurantsResolver: Resolvers = {
  Query: {
    roleInRestaurant: async (parent, args, ctx) => {
      if (ctx.token.userId === null) {
        throw new AuthenticationError("login required");
      }
      const user = await ctx.prisma.user.findUnique({
        where: {
          id: ctx.token.userId,
        },
      });

      if (!user) {
        throw new AuthenticationError("user doesn't exist");
      }

      const role = await ctx.prisma.userRoleInRestaurant.findUnique({
          where: {
              userId_restaurantId: {
                  userId: user.id,
                  restaurantId: args.restaurantId
              }
          }
      });

      return role ?? {
          restaurantId: args.restaurantId,
          userId: user.id,
          role: "NONE"
      };
    },
  },
  Mutation: {},
};
