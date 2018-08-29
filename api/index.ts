// import { GraphQLServer } from "graphql-yoga";

// import { resolvers } from "./graphql";

// const server = new GraphQLServer({
//   typeDefs: "./graphql/schema.graphql",
//   resolvers
// });

// server.start(() => console.log(`Server is running on http://localhost:4000`));

const http = require("http");

const server = http.createServer((req: any, res: any) => {
  res.write("<h1>It Works</h1>");
  res.end();
});

server.listen(3000);
