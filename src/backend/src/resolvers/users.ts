import { prisma } from "@prisma/client";
import { IResolvers } from "@graphql-tools/utils";
import { IServerContext } from "../types/context";
import argon2 from "argon2";
import {
  AuthenticationError,
  ForbiddenError,
  UserInputError,
} from "apollo-server-errors";
import jwt from "jsonwebtoken";
import { JWT_SECRET } from "../utils";

export const usersResolver: IResolvers<any, IServerContext> = {
  Query: {
    me: async (_: any, args: void, { token, prisma }: IServerContext) => {
      if (token.userId === null) {
        throw new AuthenticationError("login required");
      }
      const user = await prisma.user.findUnique({
        where: {
          id: token.userId,
        },
      });

      return user;
    },
    login: async (
      _: any,
      { email, password }: { email: string; password: string },
      { token, prisma }: IServerContext
    ) => {
      if (token.userId !== null) {
        console.log(`${token.userId}`);
        throw new ForbiddenError("already logged in");
      }

      const user = await prisma.user.findUnique({
        where: {
          email,
        },
      });

      if (
        !user ||
        !argon2.verify(user.password, password, { type: argon2.argon2id })
      ) {
        throw new UserInputError("Invalid email or password");
      }

      const accessToken = jwt.sign({}, JWT_SECRET, {
        subject: user.id,
        expiresIn: "30d",
      });

      return {
        token: accessToken,
      };
    },
  },
  Mutation: {
    createUser: async (
      _: any,
      {
        email,
        firstName,
        lastName,
        password,
      }: {
        email: string;
        firstName: string;
        lastName: string;
        password: string;
      },
      { prisma }: IServerContext
    ) => {
      const hashedPassword = await argon2.hash(password, {
        type: argon2.argon2id,
      });

      try {
        const user = await prisma.user.create({
          data: {
            email,
            firstName,
            lastName,
            password: hashedPassword,
          },
        });
      } catch (e) {
        throw new UserInputError("email already in use");
      }
    },
  },
};
