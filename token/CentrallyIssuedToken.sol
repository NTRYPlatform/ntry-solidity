/**
 *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
 *
 *  Code is based on multiple sources:
 *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
 *  https://github.com/TokenMarketNet/ico/blob/master/contracts
 *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
 */
pragma solidity ^0.4.11;

import "./BurnableToken.sol";
import "./UpgradeableToken.sol";


/**
 * Centrally issued Ethereum token.
 *
 * We mix in burnable and upgradeable traits.
 *
 * Token supply is created in the token contract creation and allocated to owner.
 * The owner can then transfer from its supply to crowdsale participants.
 * The owner, or anybody, can burn any excessive tokens they are holding.
 *
 */
contract CentrallyIssuedToken is BurnableToken, UpgradeableToken {

  string public name;
  string public symbol;
  uint public decimals;

  function CentrallyIssuedToken(address _owner) UpgradeableToken(owner) {
    name = "Notary Platform Token";
    symbol = "NTRY";
    decimals = 18;
    owner = _owner;

    totalSupply = 150000000 * 1 ether;
    
    // Allocate initial balance to the owner //
    balances[owner] = 150000000 * 1 ether;

    // Freeze notary team funds for one year (One month with pre ico already passed)//
    unlockedAt =  now + 330 * 1 days;
  }

  uint256 public constant teamAllocations = 15000000 * 1 ether;
  uint256 public unlockedAt;
  mapping (address => uint256) allocations;
  function allocate() public {
      allocations[0xab1cb1740344A9280dC502F3B8545248Dc3045eA] = 2500000 * 1 ether;
      allocations[0x330709A59Ab2D1E1105683F92c1EE8143955a357] = 2500000 * 1 ether;
      allocations[0xAa0887fc6e8896C4A80Ca3368CFd56D203dB39db] = 2500000 * 1 ether;
      allocations[0x1fbA1d22435DD3E7Fa5ba4b449CC550a933E72b3] = 2500000 * 1 ether;
      allocations[0xC9d5E2c7e40373ae576a38cD7e62E223C95aBFD4] = 500000 * 1 ether;
      allocations[0xabc0B64a38DE4b767313268F0db54F4cf8816D9C] = 500000 * 1 ether;
      allocations[0x5d85bCDe5060C5Bd00DBeDF5E07F43CE3Ccade6f] = 250000 * 1 ether;
      allocations[0xecb1b0231CBC0B04015F9e5132C62465C128B578] = 250000 * 1 ether;
      allocations[0xF9b1Cfc7fe3B63bEDc594AD20132CB06c18FD5F2] = 250000 * 1 ether;
      allocations[0xDbb89a87d9f91EA3f0Ab035a67E3A951A05d0130] = 250000 * 1 ether;
      allocations[0xC1530645E21D27AB4b567Bac348721eE3E244Cbd] = 200000 * 1 ether;
      allocations[0xcfb44162030e6CBca88e65DffA21911e97ce8533] = 200000 * 1 ether;
      allocations[0x64f748a5C5e504DbDf61d49282d6202Bc1311c3E] = 200000 * 1 ether;
      allocations[0xFF22FA2B3e5E21817b02a45Ba693B7aC01485a9C] = 200000 * 1 ether;
      allocations[0xC9856112DCb8eE449B83604438611EdCf61408AF] = 200000 * 1 ether;
      allocations[0x689CCfEABD99081D061aE070b1DA5E1f6e4B9fB2] = 2000000 * 1 ether;
  }

  function withDraw() public {
      if(now < unlockedAt){ 
          doThrow("Allocations are freezed!");
      }
      if (allocations[msg.sender] == 0){
          doThrow("No allocation found!");
      }
      balances[owner] -= allocations[msg.sender];
      balances[msg.sender] += allocations[msg.sender];
      Transfer(owner, msg.sender, allocations[msg.sender]);
      allocations[msg.sender] = 0;
      
  }

   function () {
        //if ether is sent to this address, send it back.
        throw;
    }

}
