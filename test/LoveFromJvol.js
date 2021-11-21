const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");
describe("Token contract", function () {
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const [owner] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("FromJvol");

    const hardhatToken = await Token.deploy();

    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
    hardhatToken.safeMintRandom(owner.address);
  });
});
