import { PrismaClient } from "@prisma/client";
import { ApolloServer, gql, UserInputError } from "apollo-server";
import jwt, { JwtPayload } from "jsonwebtoken";
import { JWT_SECRET } from "./utils";

import resolvers from './resolvers';
import { typeDefs } from "./types/gql";
import { IServerContext } from "./types/context";

const prisma = new PrismaClient();

const processAuthToken = async (token: string) => {
  try {
    const decodedToken = jwt.verify(token, JWT_SECRET) as JwtPayload;
    return {
      userId: decodedToken.sub ?? null,
    };
  } catch (e) {
    return {
      userId: null,
    };
  }
};

const server = new ApolloServer({
  resolvers,
  typeDefs,
  context: async ({ req }): Promise<IServerContext> => {
    const token = req.headers.authorization ?? "";
    const parsedToken = token.split("Bearer ");
    if(parsedToken.length !== 2) {
      throw new UserInputError("invalid authentication token");
    }

    return {
      token: await processAuthToken(parsedToken[1]),
      prisma,
    };
  },
});
server.listen({ port: 4000 }, () => {
  console.log("🥳 Server is running on http://localhost:4000");
});
