// import { GraphQLServer } from "graphql-yoga";

// import { resolvers } from "./graphql/resolvers";
// import context from "./context";

// const server = new GraphQLServer({
//   typeDefs: "./graphql/schema.graphql",
//   resolvers,
//   // context
// });

// server.start(() => console.log(`Server is running on http://localhost:4000`));
import * as http from 'http';

const server = http.createServer((req, res) => {
  // res.write();
  res.end("<h1>It Works</h1>");
});

server.listen(4000, () => console.log('Listening on port 4000'));
