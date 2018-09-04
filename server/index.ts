#!/usr/bin/env node




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


//
// need this in docker container to properly exit since node doesn't handle SIGINT/SIGTERM
// this also won't work on using npm start since:
// https://github.com/npm/npm/issues/4603
// https://github.com/npm/npm/pull/10868
// https://github.com/RisingStack/kubernetes-graceful-shutdown-example/blob/master/src/index.js
// if you want to use npm then start with `docker run --init` to help, but I still don't think it's
// a graceful shutdown of node process
//
// shut down server
// function shutdown() {
//   server.close(err => {
//     server.close(() => console.log('closing server'));
//     if (err) {
//       console.error(err);
//       process.exitCode = 1;
//     }
//     process.exit();
//   })
// }
// // quit on ctrl-c when running docker in terminal
// process.on('SIGINT', () => {
// 	console.info('Got SIGINT (aka ctrl-c in docker). Graceful shutdown ', new Date().toISOString());
//   shutdown();
// });
// // quit properly on docker stop
// process.on('SIGTERM', () => {
//   console.info('Got SIGTERM (docker container stop). Graceful shutdown ', new Date().toISOString());
//   shutdown();
// })