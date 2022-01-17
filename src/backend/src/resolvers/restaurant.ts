import { UserRole } from "@prisma/client";
import { AuthenticationError, UserInputError } from "apollo-server-errors";
import { Resolvers } from "../generated/graphql";

export const restaurantResolver: Resolvers = {
  Restaurant: {
    tables: async (parent, args, ctx) => {
      return await ctx.prisma.table.findMany({
        where: { restaurantId: parent.id },
      });
    },
    occupyingBookings: async (parent, args, ctx) => {
      const current = new Date();
      const bookings = await ctx.prisma.booking.findMany({
        where: {
          restaurantId: parent.id,
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
      return bookings;
    },
    bookings: async (parent, args, ctx) => {
      return await ctx.prisma.booking.findMany({
        where: { restaurantId: parent.id },
      });
    },
  },
  Query: {
    restaurant: async (parent, args, ctx) => {
      const restaurant = await ctx.prisma.restaurant.findUnique({
        where: {
          id: args.restaurantId
        }
      });
      return restaurant;
    },

    restaurants: async (parent, args, ctx) => {
      const restaurants = await ctx.prisma.restaurant.findMany();
      return restaurants;
    },

    roleInRestaurant: async (parent, args, ctx) => {
      const user = await ctx.prisma.user.findUnique({
        where: {
          id: ctx.token.userId!,
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
  Mutation: {
    editRestaurantInfo: async (parent, args, ctx) => {
      const user = await ctx.prisma.user.findUnique({
        where: {
          id: ctx.token.userId!,
        },
        include: {
          rolesInRestaurants: true,
        },
      });

      if (!user) {
        throw new AuthenticationError("user doesn't exist");
      }

      if (
        !user.rolesInRestaurants.find(
          (roles) =>
            roles.restaurantId === args.data.restaurantId &&
            roles.role === UserRole.ADMIN
        )
      ) {
        throw new UserInputError("no permissions for specified restaurant.");
      }

      const updatedRestaurant = await ctx.prisma.restaurant.update({
        where: {
          id: args.data.restaurantId,
        },
        data: {
          name: args.data.name ?? undefined,
          description: args.data.description ?? undefined,
          address: args.data.address ?? undefined,
          city: args.data.city ?? undefined,
          zipCode: args.data.zipCode ?? undefined,
        },
      });

      return updatedRestaurant;
    },
  },
};
