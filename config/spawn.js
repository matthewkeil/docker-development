const child = require("child_process");

module.exports = (command, args) => {
  console.log(`>>> Spawning child process for command >>>\n>>> ${command} >>>`);

  const _process = child.spawn(command, args);

  _process.stdout.on("data", data => {
    console.log(`${command} ${args ? args.join(" ") : ""} >>> ${data}`);
  });

  _process.stderr.on("data", data => {
    console.error(
      `ERROR: ${command} ${args ? args.join(" ") : ""} \n>>> ${data}`
    );
  });

  _process.on("close", code => {
    console.log(
      `EXIT: ${command} ${
        args ? args.join(" ") : ""
      } \n>>> exited with code ${code}`
    );
  });

  return _process;
};
