const { expect } = require("chai");
const { ethers } = require("hardhat");
const { Worker } = require("worker_threads");

describe("Karu contract", function () {
  let contract;
  let factory;
  let token;
  beforeEach(async function () {
    const Karu = await ethers.getContractFactory("Karu");
    contract = await Karu.deploy();
  });
  it("Deployment success", async function () {
    const address = contract.address;
    expect(address).not.to.equal("");
    expect(address).not.to.equal(null);
    expect(address).not.to.equal(undefined);
    expect(address).not.to.equal(0x0);
  });
  it("two people buy the same nft simultaneously", async function () {
    const [owner, addr1, addr2] = await ethers.getSigners();
    const price = 10;
    await contract.mint({ value: price });

    const buyPromises = [
      contract.connect(addr1).buy(0, { value: price }),
      contract.connect(addr2).buy(0, { value: price }),
    ];

    await Promise.all(buyPromises);
  });
});
