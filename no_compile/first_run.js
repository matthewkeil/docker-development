const path = require("path");
const fs = require("fs");
const util = require("util");
const exec = util.promisify(require("child_process").exec);
const spawn = require("../spawn");

const dbpath = path.join(__dirname, "/../../.db/mongo");

const checkDb = () =>
  fs.readdir(dbpath, (error, files) => {
    if (error)
      throw new Error(`${dbpath} does not exist or permissions are incorrect`);

    if (!(Array.isArray(files) && files.length)) {
      const mongod = spawn("mongod", `--dbpath=${dbpath}`);

      setTimeout(async () => {
        let command = "mongo";
        let args = ["<", "/Users/matthewkeil/dev/uc/config/mongo/create-root.mongo"];
        const cmdStr = command + ' ' + args.join(" ");

        console.log(`>>> Executing init command >>>\n>>> ${cmdStr} >>>\n`);

        const build = spawn(command, args);

        build.on('close', async () => {
          let { stdout: out, stderr: err } = await exec("pgrep", "mongod");
          if (err) throw new Error(`ERROR: pgrep mongod \n>>> ${err}`);
          if (out) {
            mongod.kill();
          }
        });

      }, 1000);
    } else console.log(">>> mongoDb initContainer - db is setup >>>");

    return;
  });

module.exports = checkDb();

// ROOT_USER=${MONGO_ROOT_USERNAME}
// ROOT_PASSWORD=${MONGO_ROOT_PASSWORD}
// # ROOT_PASSWORD=${MONGO_ROOT_PASSWORD:-$(pwgen -s -1 16)}
// ROOT_DB="admin"
// ROOT_ROLE=${MONGO_ROOT_ROLE}

// USER=${MONGO_USERNAME}
// PASSWORD=${MONGO_PASSWORD}
// DB=${MONGO_DB}
// ROLE=${MONGO_ROLE}

// const MongoClient = require("mongodb").MongoClient;

// MongoClient.connect(
//   "mongo://localhost:27017",
//   async (err, client) => {
//     if (err) throw err;

//     console.log(client);
// const admin = db.getSiblingDB("admin");
// admin.createUser({
//   user: "admin",
//   pwd: "pass",
//   roles: [{ role: "root", db: "admin" }]
// });
// const uc = db.getSiblingDB("uc");
// uc.createUser({
//   user: "ucApi",
//   pwd: "ucApi",
//   roles: [{ role: "dbOwner", db: "uc" }]
// });
//   }
// );
