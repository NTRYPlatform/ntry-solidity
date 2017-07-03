/**
 *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
 *
 *  Code is based on multiple sources:
 *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
 *  https://github.com/TokenMarketNet/ico/blob/master/contracts
 *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
 */
pragma solidity ^0.4.11;


import './ERC20Basic.sol';


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) returns (bool success);
  function approve(address spender, uint256 value) returns (bool success);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}