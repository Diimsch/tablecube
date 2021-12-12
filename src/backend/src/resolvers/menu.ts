import { UserRole } from "@prisma/client";
import { AuthenticationError, UserInputError } from "apollo-server-errors";
import { Resolvers } from "../generated/graphql";

export const menuResolvers: Resolvers = {
  Query: {
    getMenu: async (parent, args, ctx) => {
        const menu = await ctx.prisma.menuItem.findMany({
            where: {
                restaurantId: args.restaurantId,
            }
        });
        return menu;
    },
  },
  Mutation: {
    addMenuItem: async (parent, args, ctx) => {
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

      if (
        !user.rolesInRestaurants.find(
          (roles) =>
            roles.restaurantId === args.restaurantId &&
            roles.role === UserRole.ADMIN
        )
      ) {
        throw new UserInputError("no permissions for specified restaurant.");
      }

      const menuItem = await ctx.prisma.menuItem.create({
        data: {
          name: args.menuItem.name,
          description: args.menuItem.description,
          type: args.menuItem.type,
          available: true,
          price: args.menuItem.price,
          restaurantId: args.restaurantId,
        },
      });

      return menuItem;
    },
  },
};
