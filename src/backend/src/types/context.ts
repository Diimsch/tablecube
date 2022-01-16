import { PrismaClient } from "@prisma/client";

export interface IServerContext {
    token: ITokenData;
    prisma: PrismaClient;
}

export interface ITokenData {
    userId: string | null;
    type: "HUMAN" | "ROBOT";
}