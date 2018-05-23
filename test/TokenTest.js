const ArawToken = artifacts.require('./ArawToken.sol')
const founderAddress = '0xC47830DE1DEe63f8fCAa562bc5A78457A5DAe819';
contract('ArawToken', function (accounts) {
    let arawToken
  
    it('Check Basic Toke Information', async function () {
        let instance = await ArawToken.deployed();
        let name = await instance.name.call();
        let symbol = await instance.symbol.call();
        let decimals = await instance.decimals.call();
        assert.equal('ARAW TOKEN', name);
        assert.equal(18, decimals);
        assert.equal('ARAW', symbol);
    })


    it('Founder have right token value', async function () {
        let instance = await ArawToken.deployed();
        let balance = await instance.balanceOf.call(founderAddress);
        assert.equal(450000000 * (10 ** 18), balance.toNumber());
    })

    it("Owner should send coin correctly in private sale", async () => {

        let account_one = accounts[0];
        let account_two = accounts[1];
        let instance = await ArawToken.deployed();
        let meta = instance;
        let amount = 10;
        let balance = await meta.balanceOf.call(account_one);
        let account_one_starting_balance = balance.toNumber();
        balance = await meta.balanceOf.call(account_two);
        let account_two_starting_balance = balance.toNumber();
        await meta.transfer(account_two, amount, {from: account_one});
        balance = await meta.balanceOf.call(account_one);
        let account_one_ending_balance = balance.toNumber();
    
        balance = await meta.balanceOf.call(account_two);
        let account_two_ending_balance = balance.toNumber();
    
        assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
        assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
      
    });

   
    

})