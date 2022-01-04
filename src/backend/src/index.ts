import { GraphQLFileLoader } from "@graphql-tools/graphql-file-loader";
import { loadTypedefsSync } from "@graphql-tools/load";
import { PrismaClient } from "@prisma/client";
import { ApolloServer } from "apollo-server-express";
import {
  ApolloServerPluginDrainHttpServer,
  AuthenticationError,
  UserInputError,
} from "apollo-server-core";
import express from "express";
import http, { IncomingMessage } from "http";
import { DocumentNode, GraphQLScalarType, Kind } from "graphql";
import jwt, { JwtPayload } from "jsonwebtoken";
import { join } from "path";
import resolvers from "./resolvers";
import { IServerContext } from "./types/context";

import { createServer } from "http";
import { execute, subscribe } from "graphql";
import { SubscriptionServer } from "subscriptions-transport-ws";
import { makeExecutableSchema } from "@graphql-tools/schema";
import { WebSocket } from "ws";
import qs from "querystring";
import { URL, URLSearchParams } from "url";
import cors from 'cors';

const prisma = new PrismaClient({
  log: ['query'],
});


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

async function startApolloServer() {
  // Required logic for integrating with Express
  const app = express();
  app.use(cors());
  const httpServer = http.createServer(app);

  // Same ApolloServer initialization as before, plus the drain plugin.
  const schema = makeExecutableSchema({ typeDefs, resolvers });

  const subscriptionServer = SubscriptionServer.create(
    {
      // This is the `schema` we just created.
      schema,
      // These are imported from `graphql`.
      execute,
      onConnect: async (
        connectionParams: any,
        webSocket: any,
        connectionContext: any
      ) => {
        console.log(connectionParams);
        console.log(connectionContext);
        const token = connectionParams.Authorization;
        if(!token) {
          throw new AuthenticationError('missing jwt');
        }
        return {
          token: await processAuthToken(token),
          prisma,
        };
      },
      subscribe,
    },
    {
      // This is the `httpServer` we created in a previous step.
      server: httpServer,
      // Pass a different path here if your ApolloServer serves at
      // a different path.
      path: "/graphql",
    }
  );

  const server = new ApolloServer({
    schema,
    context: async ({ req }): Promise<IServerContext> => {
      const token = req.headers.authorization;
      return {
        token: await processAuthToken(token),
        prisma,
      };
    },
    plugins: [
      ApolloServerPluginDrainHttpServer({ httpServer }),
      {
        async serverWillStart() {
          return {
            async drainServer() {
              subscriptionServer.close();
            },
          };
        },
      },
    ],
    
  });

  // More required logic for integrating with Express
  await server.start();
  server.applyMiddleware({
    app,
    // By default, apollo-server hosts its GraphQL endpoint at the
    // server root. However, *other* Apollo Server packages host it at
    // /graphql. Optionally provide this to match apollo-server.
    path: "/graphql",
  });

  // Modified server startup
  await new Promise<void>((resolve) =>
    httpServer.listen({ port: 4000 }, resolve)
  );
  console.log(`🚀 Server ready at http://localhost:4000${server.graphqlPath}`);
}

startApolloServer();
