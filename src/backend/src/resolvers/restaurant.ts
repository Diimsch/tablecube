import { Resolvers } from "../generated/graphql";

export const restaurantResolver: Resolvers = {
  Query: {
    restaurant: async (parent: any, args: any, ctx: any) => {
        const restaurants = await ctx.prisma.restaurant.findMany();
        return restaurants;
        }
  }
};
