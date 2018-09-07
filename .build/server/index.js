#!/usr/bin/env node
"use strict";
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const http = __importStar(require("http"));
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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiaW5kZXguanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi8uLi9zZXJ2ZXIvaW5kZXgudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7OztBQWtCQSwyQ0FBNkI7QUFFN0IsTUFBTSxNQUFNLEdBQUcsSUFBSSxDQUFDLFlBQVksQ0FBQyxDQUFDLEdBQUcsRUFBRSxHQUFHLEVBQUUsRUFBRTtJQUM1QyxlQUFlO0lBQ2YsR0FBRyxDQUFDLEdBQUcsQ0FBQyxtQkFBbUIsQ0FBQyxDQUFDO0FBQy9CLENBQUMsQ0FBQyxDQUFDO0FBRUgsTUFBTSxDQUFDLE1BQU0sQ0FBQyxJQUFJLEVBQUUsR0FBRyxFQUFFLENBQUMsT0FBTyxDQUFDLEdBQUcsQ0FBQyx3QkFBd0IsQ0FBQyxDQUFDLENBQUM7QUFHakUsRUFBRTtBQUNGLDBGQUEwRjtBQUMxRixpREFBaUQ7QUFDakQseUNBQXlDO0FBQ3pDLHdDQUF3QztBQUN4QywrRkFBK0Y7QUFDL0YsbUdBQW1HO0FBQ25HLHNDQUFzQztBQUN0QyxFQUFFO0FBQ0YsbUJBQW1CO0FBQ25CLHdCQUF3QjtBQUN4QiwwQkFBMEI7QUFDMUIseURBQXlEO0FBQ3pELGlCQUFpQjtBQUNqQiw0QkFBNEI7QUFDNUIsOEJBQThCO0FBQzlCLFFBQVE7QUFDUixzQkFBc0I7QUFDdEIsT0FBTztBQUNQLElBQUk7QUFDSixvREFBb0Q7QUFDcEQsK0JBQStCO0FBQy9CLG9HQUFvRztBQUNwRyxnQkFBZ0I7QUFDaEIsTUFBTTtBQUNOLGtDQUFrQztBQUNsQyxnQ0FBZ0M7QUFDaEMsdUdBQXVHO0FBQ3ZHLGdCQUFnQjtBQUNoQixLQUFLIiwic291cmNlc0NvbnRlbnQiOlsiIyEvdXNyL2Jpbi9lbnYgbm9kZVxuXG5cblxuXG4vLyBpbXBvcnQgeyBHcmFwaFFMU2VydmVyIH0gZnJvbSBcImdyYXBocWwteW9nYVwiO1xuXG4vLyBpbXBvcnQgeyByZXNvbHZlcnMgfSBmcm9tIFwiLi9ncmFwaHFsL3Jlc29sdmVyc1wiO1xuLy8gaW1wb3J0IGNvbnRleHQgZnJvbSBcIi4vY29udGV4dFwiO1xuXG5cbi8vIGNvbnN0IHNlcnZlciA9IG5ldyBHcmFwaFFMU2VydmVyKHtcbi8vICAgdHlwZURlZnM6IFwiLi9ncmFwaHFsL3NjaGVtYS5ncmFwaHFsXCIsXG4vLyAgIHJlc29sdmVycyxcbi8vICAgLy8gY29udGV4dFxuLy8gfSk7XG5cbi8vIHNlcnZlci5zdGFydCgoKSA9PiBjb25zb2xlLmxvZyhgU2VydmVyIGlzIHJ1bm5pbmcgb24gaHR0cDovL2xvY2FsaG9zdDo0MDAwYCkpO1xuaW1wb3J0ICogYXMgaHR0cCBmcm9tICdodHRwJztcblxuY29uc3Qgc2VydmVyID0gaHR0cC5jcmVhdGVTZXJ2ZXIoKHJlcSwgcmVzKSA9PiB7XG4gIC8vIHJlcy53cml0ZSgpO1xuICByZXMuZW5kKFwiPGgxPkl0IFdvcmtzPC9oMT5cIik7XG59KTtcblxuc2VydmVyLmxpc3Rlbig0MDAwLCAoKSA9PiBjb25zb2xlLmxvZygnTGlzdGVuaW5nIG9uIHBvcnQgNDAwMCcpKTtcblxuXG4vL1xuLy8gbmVlZCB0aGlzIGluIGRvY2tlciBjb250YWluZXIgdG8gcHJvcGVybHkgZXhpdCBzaW5jZSBub2RlIGRvZXNuJ3QgaGFuZGxlIFNJR0lOVC9TSUdURVJNXG4vLyB0aGlzIGFsc28gd29uJ3Qgd29yayBvbiB1c2luZyBucG0gc3RhcnQgc2luY2U6XG4vLyBodHRwczovL2dpdGh1Yi5jb20vbnBtL25wbS9pc3N1ZXMvNDYwM1xuLy8gaHR0cHM6Ly9naXRodWIuY29tL25wbS9ucG0vcHVsbC8xMDg2OFxuLy8gaHR0cHM6Ly9naXRodWIuY29tL1Jpc2luZ1N0YWNrL2t1YmVybmV0ZXMtZ3JhY2VmdWwtc2h1dGRvd24tZXhhbXBsZS9ibG9iL21hc3Rlci9zcmMvaW5kZXguanNcbi8vIGlmIHlvdSB3YW50IHRvIHVzZSBucG0gdGhlbiBzdGFydCB3aXRoIGBkb2NrZXIgcnVuIC0taW5pdGAgdG8gaGVscCwgYnV0IEkgc3RpbGwgZG9uJ3QgdGhpbmsgaXQnc1xuLy8gYSBncmFjZWZ1bCBzaHV0ZG93biBvZiBub2RlIHByb2Nlc3Ncbi8vXG4vLyBzaHV0IGRvd24gc2VydmVyXG4vLyBmdW5jdGlvbiBzaHV0ZG93bigpIHtcbi8vICAgc2VydmVyLmNsb3NlKGVyciA9PiB7XG4vLyAgICAgc2VydmVyLmNsb3NlKCgpID0+IGNvbnNvbGUubG9nKCdjbG9zaW5nIHNlcnZlcicpKTtcbi8vICAgICBpZiAoZXJyKSB7XG4vLyAgICAgICBjb25zb2xlLmVycm9yKGVycik7XG4vLyAgICAgICBwcm9jZXNzLmV4aXRDb2RlID0gMTtcbi8vICAgICB9XG4vLyAgICAgcHJvY2Vzcy5leGl0KCk7XG4vLyAgIH0pXG4vLyB9XG4vLyAvLyBxdWl0IG9uIGN0cmwtYyB3aGVuIHJ1bm5pbmcgZG9ja2VyIGluIHRlcm1pbmFsXG4vLyBwcm9jZXNzLm9uKCdTSUdJTlQnLCAoKSA9PiB7XG4vLyBcdGNvbnNvbGUuaW5mbygnR290IFNJR0lOVCAoYWthIGN0cmwtYyBpbiBkb2NrZXIpLiBHcmFjZWZ1bCBzaHV0ZG93biAnLCBuZXcgRGF0ZSgpLnRvSVNPU3RyaW5nKCkpO1xuLy8gICBzaHV0ZG93bigpO1xuLy8gfSk7XG4vLyAvLyBxdWl0IHByb3Blcmx5IG9uIGRvY2tlciBzdG9wXG4vLyBwcm9jZXNzLm9uKCdTSUdURVJNJywgKCkgPT4ge1xuLy8gICBjb25zb2xlLmluZm8oJ0dvdCBTSUdURVJNIChkb2NrZXIgY29udGFpbmVyIHN0b3ApLiBHcmFjZWZ1bCBzaHV0ZG93biAnLCBuZXcgRGF0ZSgpLnRvSVNPU3RyaW5nKCkpO1xuLy8gICBzaHV0ZG93bigpO1xuLy8gfSkiXX0=