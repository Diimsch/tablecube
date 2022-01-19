import { mergeResolvers } from "@graphql-tools/merge";
import { IResolvers } from "@graphql-tools/utils";
import { GraphQLScalarType, Kind } from "graphql";
import { Resolvers, Scalars } from "../generated/graphql";
import { bookingResolvers } from "./booking";
import { menuResolvers } from "./menu";
import { tablesResolvers } from "./table";
import { usersResolver } from "./users";
import { restaurantResolver } from "./restaurant";

const genericResolvers: Resolvers = {
  Date: new GraphQLScalarType({
    name: "Date",
    description: "Date custom scalar type",
    serialize(value) {
      return value.getTime(); // Convert outgoing Date to integer for JSON
    },
    parseValue(value) {
      return new Date(value); // Convert incoming integer to Date
    },
    parseLiteral(ast) {
      if (ast.kind === Kind.INT) {
        return new Date(parseInt(ast.value, 10)); // Convert hard-coded AST string to integer and then to Date
      }
      return null; // Invalid hard-coded value (not an integer)
    },
  }),
};

import { allow, and, rule, shield } from "graphql-shield";

const isAuthenticated = rule()(async (parent, args, ctx, info) => {
  return ctx.token.userId != null;
});

const isHuman = rule()(async (parent, args, ctx, info) => {
  return ctx.token.type === "HUMAN";
});

const isRobot = rule()(async (parent, args, ctx, info) => {
  return ctx.token.type === "ROBOT";
});

export const permissions = shield(
  {
    Query: {
      me: and(isAuthenticated, isHuman),
      booking: and(isAuthenticated, isHuman),
      table: isAuthenticated,
      menu: allow,
      promptValidation: isAuthenticated,
      restaurant: allow,
      roleInRestaurant: and(isAuthenticated, isHuman),
    },
    Mutation: {
      createUser: allow,
      checkIn: and(isAuthenticated, isHuman),
      addMenuItem: and(isAuthenticated, isHuman),
      updateMenuItem: and(isAuthenticated, isHuman),
      delMenuItem: and(isAuthenticated, isHuman),
      createBooking: and(isAuthenticated, isHuman),
      joinBooking: and(isAuthenticated, isHuman),
      addItemToBooking: and(isAuthenticated, isHuman),
      changeBookingStatus: isAuthenticated,
      payItems: and(isAuthenticated, isHuman),
      editRestaurantInfo: and(isAuthenticated, isHuman),
    },
  },
  {
    debug: true,
  }
);

export default mergeResolvers([
  usersResolver,
  bookingResolvers,
  menuResolvers,
  restaurantResolver,
  tablesResolvers,
  genericResolvers,
]);
