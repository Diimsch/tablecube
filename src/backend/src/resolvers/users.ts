import {
  AuthenticationError,
  ForbiddenError,
  UserInputError,
} from "apollo-server-errors";
import argon2 from "argon2";
import jwt from "jsonwebtoken";
import { Resolvers } from "../generated/graphql";

export const usersResolver: Resolvers = {
  User: {
    bookings: async(parent, args, ctx) => {
      const bookings = await ctx.prisma.booking.findMany({
        where: {
          users: {
            some: {
              userId: parent.id,
            }
          }
        }
      });
      return bookings;
    }
  },
  Query: {
    me: async (parent, args, ctx) => {
      if (ctx.token.userId === null) {
        throw new AuthenticationError("login required");
      }
      const user = await ctx.prisma.user.findUnique({
        where: {
          id: ctx.token.userId,
        },
      });

      if (!user) {
        throw new AuthenticationError("user doesn't exist");
      }

      return user;
    },
    login: async (parent, args, ctx) => {
      if (ctx.token.userId !== null) {
        throw new ForbiddenError("already logged in");
      }

      const user = await ctx.prisma.user.findUnique({
        where: {
          email: args.email,
        },
      });

      if (
        !user ||
        !await argon2.verify(user.password, args.password, { type: argon2.argon2id })
      ) {
        throw new UserInputError("Invalid email or password");
      }

      const accessToken = jwt.sign({}, process.env.JWT_SECRET ?? "", {
        subject: user.id,
        expiresIn: "30d",
      });

      return {
        token: accessToken,
      };
    },
  },
  Mutation: {
    createUser: async (parent, args, ctx) => {
      const hashedPassword = await argon2.hash(args.password, {
        type: argon2.argon2id,
      });

      try {
        const user = await ctx.prisma.user.create({
          data: {
            email: args.email,
            firstName: args.firstName,
            lastName: args.lastName,
            password: hashedPassword,
          },
        });

        return user;
      } catch (e) {
        throw new UserInputError("email already in use");
      }
    },
  },
};
