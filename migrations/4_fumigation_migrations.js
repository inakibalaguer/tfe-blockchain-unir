const fumigation = artifacts.require("Fumigation");

module.exports = function (deployer) {
    deployer.then(async () => {
        //first address = address contract drone
        //second address = address contract plot
        await deployer.deploy(
            fumigation,
            "0xC80E5D9340e9A301601C41928026A9D2762cb8f7",
            "0xC9bde3ECFF87cb9858532A66BEd40Ad531E74c5A");
    });
};