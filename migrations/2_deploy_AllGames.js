const AllGames = artifacts.require("AllGames");
const States = artifacts.require("States");

module.exports = async function (deployer) {
  await deployer.deploy(States);
  await deployer.deploy(AllGames, States.address);
};
