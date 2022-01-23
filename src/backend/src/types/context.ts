import { PrismaClient } from "@prisma/client";

/**
 * GraphQL context that is passed to resolver functions as third argument
 */
export interface IServerContext {
  token: ITokenData;
  prisma: PrismaClient;
}

/**
 * Custom JWT payload in authentication token
 */
export interface ITokenData {
  userId: string | null;
  type: "HUMAN" | "ROBOT";
}
