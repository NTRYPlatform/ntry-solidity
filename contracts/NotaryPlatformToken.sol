/**
 *  NotaryPlatformToken.sol v1.0.0
 * 
 *  Bilal Arif - https://twitter.com/furusiyya_
 *  Notary Platform
 */

pragma solidity ^0.4.11;

import './Ownable.sol';
import './SafeMath.sol';
import './Pausable.sol';
import './Allocations.sol';
import './ReentrancyGuard.sol';

contract NotaryPlatformToken is Pausable, Allocations, ReentrancyGuard{

  using SafeMath for uint256;

  string constant name = "Notary Platform Token";
  string constant symbol = "NTRY";
  uint8 constant decimals = 18;
  uint256 totalSupply = 150000000 * 1 ether;

  mapping(address => uint256) private balances;
  mapping (address => mapping (address => uint256)) private allowed;

  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);

  function NotaryPlatformToken() Ownable(msg.sender){
    owner = msg.sender;
    // Allocate initial balance to the owner //
    balances[owner] = 130000000 * 1 ether;  
  }


  /** Externals **/

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) external whenNotPaused returns (bool) {
    require(_to != address(0));
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) external constant returns (uint256 balance) {
    return balances[_owner];
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) external whenNotPaused returns (bool) {
    require(_to != address(0));

    uint256 _allowance = allowed[_from][msg.sender];

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = _allowance.sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) external whenNotPaused returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  /**
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   */
  function increaseApproval (address _spender, uint _addedValue) external whenNotPaused returns (bool success) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval (address _spender, uint _subtractedValue) external whenNotPaused returns (bool success) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
  * @notice Transfers tokens held by timelock to beneficiary.
  */
  function claim() external whenNotPaused nonReentrant timeLock isTeamMember {
    balances[msg.sender] = balances[msg.sender].add(release());
  }

  /**
   *                  ========== Token migration support ========
   */
  uint256 public totalMigrated;
  bool private upgrading = false;
  MigrationAgent private agent;
  event Migrate(address indexed _from, address indexed _to, uint256 _value);
  event Upgrading(bool status);

  function migrationAgent() external constant returns(address){ return agent; }
  function upgradingEnabled()  external constant returns(bool){ return upgrading; }

  /**
   * @notice Migrate tokens to the new token contract.
   * @dev Required state: Operational Migration
   * @param _value The amount of token to be migrated
   */
  function migrate(uint256 _value) external nonReentrant isUpgrading {
    require(_value > 0);
    require(_value <= balances[msg.sender]);
    require(agent.isMigrationAgent());

    balances[msg.sender] = balances[msg.sender].sub(_value);
    totalSupply = totalSupply.sub(_value);
    totalMigrated = totalMigrated.add(_value);
    
    if(!agent.migrateFrom(msg.sender, _value)){
      revert();
    }
    Migrate(msg.sender, agent, _value);
  }

  /**
   * @notice Set address of migration target contract and enable migration
   * process.
   * @param _agent The address of the MigrationAgent contract
   */
  function setMigrationAgent(address _agent) external isUpgrading onlyOwner {
    require(_agent != 0x00);
    agent = MigrationAgent(_agent);
    if(!agent.isMigrationAgent()){
      revert();
    }
    
    if(agent.originalSupply() != totalSupply){
      revert();
    }
  }

  /**
   * @notice Enable upgrading to allow tokens migration to new contract
   * process.
   */
  function tweakUpgrading() external onlyOwner{
      upgrading = !upgrading;
      Upgrading(upgrading);
  }

  modifier isUpgrading() { 
    require(upgrading); 
    _; 
  }

  function () {
    //if ether is sent to this address, send it back.
    revert();
  }

}

/// @title Migration Agent interface
contract MigrationAgent {

  uint256 public originalSupply;
  
  function migrateFrom(address _from, uint256 _value) external returns(bool);
  
  /** Interface marker */
  function isMigrationAgent() external constant returns (bool) {
    return true;
  }
}