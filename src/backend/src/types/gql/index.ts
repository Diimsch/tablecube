import { gql } from "apollo-server";

export const typeDefs = gql`
  type User {
    email: String!
    firstName: String!
    lastName: String!
  }

  type LoginResponse {
    token: String!
  }

  type Query {
    login(email: String!, password: String!): LoginResponse!
    me: User
  }

  type Mutation {
    createUser(
      email: String!
      firstName: String!
      lastName: String!
      password: String!
    ): User
  }
`;
