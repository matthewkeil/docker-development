import http from "http";
import { GraphQLServer } from "graphql-yoga";
import { Prisma } from "./generated/prisma";
import { resolvers, fragmentReplacements } from "./resolvers";

const db = new Prisma({
  fragmentReplacements,
  endpoint: process.env.PRISMA_ENDPOINT,
  secret: process.env.PRISMA_SECRET,
  debug: true
});

if (db.hasOwnProperty("AUTH")) {
  throw new Error("Prisma context object has an existing AUTH property");
}
export type Context = typeof db & { AUTH?: any };

const context = async (req: http.IncomingMessage): Promise<Context> => {
  const ctx = { ...db } as Context;

  return ctx;
};

const server = new GraphQLServer({
  typeDefs: "./src/schema.graphql",
  resolvers,
  context
});

server.start(({ port }) =>
  console.log(`Server is running on http://localhost:${port}`)
);
