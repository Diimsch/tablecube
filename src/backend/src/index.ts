import { GraphQLFileLoader } from "@graphql-tools/graphql-file-loader";
import { loadTypedefsSync } from "@graphql-tools/load";
import { PrismaClient } from "@prisma/client";
import { ApolloServer, UserInputError } from "apollo-server";
import { DocumentNode } from "graphql";
import jwt, { JwtPayload } from "jsonwebtoken";
import { join } from "path";
import resolvers from "./resolvers";
import { IServerContext } from "./types/context";

const prisma = new PrismaClient();

const sources = loadTypedefsSync(join(__dirname, "schema.graphql"), {
  loaders: [new GraphQLFileLoader()],
});
const typeDefs = sources
  .map((source) => source.document)
  .filter((d) => d !== undefined) as DocumentNode[];

const processAuthToken = async (token: string | undefined) => {
  if (!token) {
    return {
      userId: null,
    };
  }
  try {
    const tokenData = token.split("Bearer ");
    if (tokenData.length !== 2) {
      throw new UserInputError("invalid authentication token");
    }
    const parsedToken = tokenData[1];

    const decodedToken = jwt.verify(
      parsedToken,
      process.env.JWT_SECRET ?? ""
    ) as JwtPayload;

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
  typeDefs,
  resolvers,
  context: async ({ req }): Promise<IServerContext> => {
    const token = req.headers.authorization;
    return {
      token: await processAuthToken(token),
      prisma,
    };
  },
});
server.listen({ port: 4000 }, () => {
  console.log("🥳 Server is running on http://localhost:4000");
});
