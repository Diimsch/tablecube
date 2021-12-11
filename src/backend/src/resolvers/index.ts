import { mergeResolvers } from "@graphql-tools/merge";
import { IResolvers } from "@graphql-tools/utils";
import { usersResolver } from "./users";

export default mergeResolvers([usersResolver]);