const SigMock = artifacts.require('./mocks/SigMock.sol');
const ethutil = require('ethereumjs-util');

const data = "0xb9caf644225739cd2bda9073346357ae4a0c3d71809876978bd81cc702b7fdc7";

contract('SignatureValidator', function (accounts) {

    let mock;

    beforeEach(async () => {
       mock = await SigMock.new();
    });

    it('should validate geth signature', async () => {
        let sig = (await web3.eth.sign(accounts[0], data)).slice(2);

        let r = ethutil.toBuffer('0x' + sig.substring(0, 64));
        let s = ethutil.toBuffer('0x' + sig.substring(64, 128));
        let v = ethutil.toBuffer(parseInt(sig.substring(128, 130), 16) + 27);
        let mode = ethutil.toBuffer(1);

        let signature = '0x' + Buffer.concat([mode, v, r, s]).toString('hex');

        assert.equal(true, await mock.isValidSignature(data, accounts[0], signature));
    });

    it('should return correct signer', async () => {
        let sig = (await web3.eth.sign(accounts[0], data)).slice(2);

        let r = ethutil.toBuffer('0x' + sig.substring(0, 64));
        let s = ethutil.toBuffer('0x' + sig.substring(64, 128));
        let v = ethutil.toBuffer(parseInt(sig.substring(128, 130), 16) + 27);
        let mode = ethutil.toBuffer(1);

        let signature = '0x' + Buffer.concat([mode, v, r, s]).toString('hex');

        assert.equal(accounts[0], await mock.recover(data, signature));
    });

});