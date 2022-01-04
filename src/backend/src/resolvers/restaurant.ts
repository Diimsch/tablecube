import { AuthenticationError } from "apollo-server-errors";
import { Resolvers } from "../generated/graphql";

export const restaurantResolver: Resolvers = {
  Query: {
    restaurant: async (parent, args, ctx) => {
      const restaurants = await ctx.prisma.restaurant.findMany();
      return restaurants;
    },

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
            restaurantId: args.restaurantId,
          },
        },
      });

      return (
        role ?? {
          restaurantId: args.restaurantId,
          userId: user.id,
          role: "NONE",
        }
      );
    },
  },
  Mutation: {},
};
