/**
 *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
 *
 *  Code is based on multiple sources:
 *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
 *  https://github.com/TokenMarketNet/ico/blob/master/contracts
 *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
 */
pragma solidity ^0.4.16;

import './SafeMath.sol';


/**
 * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
 *
 * Based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract NTRY_ERC20Token {
  address public owner;
  
  uint256 public totalSupply;
  

  /* NTRY functional is paused if there is any emergency */
  bool public emergency = false;

  using SafeMath for uint;

  /* Actual balances of token holders */
  mapping(address => uint) balances;

  /* approve() allowances */
  mapping (address => mapping (address => uint)) allowed;
  
  /* freezeAccount() frozen() */
  mapping (address => bool) frozenAccount;


  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  /* Notify account frozen activity */
  event FrozenFunds(address target, bool frozen);

  /* Interface declaration */
  function isToken() public constant returns (bool weAre) {
    return true;
  }

  /**
   * @dev Throws if called by any account other than the owner. 
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * Fix for the ERC20 short address attack
   *
   * http://vessenes.com/the-erc20-short-address-attack-explained/
   */
  modifier onlyPayloadSize(uint size) {
     require(msg.data.length > size + 4);
     _;
  }

  modifier stopInEmergency {
    require(!emergency);
    _;
  }
  
  function transfer(address _to, uint _value) stopInEmergency onlyPayloadSize(2 * 32) returns (bool success) {
    // Check if frozen //
    require(!frozenAccount[msg.sender]);  
                  
    balances[msg.sender] = balances[msg.sender].sub( _value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint _value) stopInEmergency returns (bool success) {
    // Check if frozen //
    require(!frozenAccount[_from]);

    uint _allowance = allowed[_from][msg.sender];

    balances[_to] = balances[_to].add(_value);
    balances[_from] = balances[_from].sub(_value);
    allowed[_from][msg.sender] = _allowance.sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  function balanceOf(address _owner) constant returns (uint balance) {
    return balances[_owner];
  }

  function approve(address _spender, uint _value) stopInEmergency returns (bool success) {

    // To change the approve amount you first have to reduce the addresses`
    //  allowance to zero by calling `approve(_spender, 0)` if it is not
    //  already 0 to mitigate the race condition described here:
    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) doThrow("Allowance race condition!");

    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) constant returns (uint remaining) {
    return allowed[_owner][_spender];
  }


  /**
  * It is called Circuit Breakers (Pause contract functionality), it stop execution if certain conditions are met, 
  * and can be useful when new errors are discovered. For example, most actions may be suspended in a contract if a 
  * bug is discovered, so the most feasible option to stop and updated migration message about launching an updated version of contract. 
  * @param _stop Switch the circuite breaker on or off
  */
  function emergencyStop(bool _stop) onlyOwner {
      emergency = _stop;
  }

  /**
  * Owner can set any account into freeze state. It is helpful in case if account holder has 
  * lost his key and he want administrator to freeze account until account key is recovered
  * @param target The account address
  * @param freeze The state of account
  */
  function freezeAccount(address target, bool freeze) onlyOwner {
      frozenAccount[target] = freeze;
      FrozenFunds(target, freeze);
  }

  function frozen(address _target) constant returns (bool frozen) {
    return frozenAccount[_target];
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to. 
   */
  function transferOwnership(address newOwner) onlyOwner {
    if (newOwner != address(0)) {
      balances[newOwner] += balances[owner];
      balances[owner] = 0;
      Transfer(owner, newOwner,balances[newOwner]);
      owner = newOwner;
    }
  }

}
