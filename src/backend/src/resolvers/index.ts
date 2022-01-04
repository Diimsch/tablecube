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

export default mergeResolvers([usersResolver, bookingResolvers, menuResolvers, restaurantResolver, tablesResolvers, genericResolvers]);
