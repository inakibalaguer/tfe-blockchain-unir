const plotToken = artifacts.require("PlotToken");
const fumigationToken = artifacts.require("FumigationToken");
module.exports = function (deployer) {
    deployer.then(async () => {
        await deployer.deploy(plotToken, "Plot", "PLOT");
        await deployer.deploy(fumigationToken);
    });
};