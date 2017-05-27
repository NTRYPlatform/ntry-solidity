/**
 *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
 *
 *  Code is based on multiple sources:
 *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20.sol
 *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/HumanStandardToken.sol
 */
 
import "./StandardToken.sol";

pragma solidity ^0.4.8;

contract NotaryToken is StandardToken{

    function () {
        //if ether is sent to this address, send it back.
        throw;
    }
    
    address owner;
    mapping (address => bool) associateContracts;

    modifier onlyOwner { if (msg.sender != owner) throw; _; }

    /* Public variables of the token */
    string public name = "Notary Platform Token";
    uint8 public decimals = 18;
    string public symbol = "NTRY";
    string public version = 'NTRY-1.0';

    function NotaryToken(address _owner) {
        owner = _owner;
        /* Total supply is One hundred and fifty million (150,000,000)*/
        balances[_owner] = 150000000 * 1 ether;
        totalSupply = 150000000 * 1 ether;

        balances[_owner] -= teamAllocations;
        unlockedAt =  now + 365 * 1 days;   // Freeze notary team funds for one year
    }

    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        
        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
            throw; 
        }
        return true;
    }

    /* In certain cases associated contracts can recover NTRY they have distributed */
    function takeBackNTRY(address _from,address _to, uint256 _value) returns (bool) {
        if (associateContracts[msg.sender]){
            balances[_from] -= _value;
            balances[_to] += _value;
            return true;
        }else{
            return false;
        }
        
    }

    function newAssociate(address _addressOfAssociate) onlyOwner {
        associateContracts[_addressOfAssociate] = true;
    }

    /* Expire association with NTRY Token*/
    function expireAssociate(address _addressOfAssociate) onlyOwner {
        delete associateContracts[_addressOfAssociate];
    }
    
    /* Verify contract association with NTRY Token*/
    function isAssociated(address _addressOfAssociate) returns(bool){
        return associateContracts[_addressOfAssociate]; 
    }

    function transferOwnership(address _newOwner) onlyOwner {
        balances[_newOwner] = balances[owner];
        balances[owner] = 0;
        owner = _newOwner;
    }


    uint256 constant teamAllocations = 15000000 * 1 ether;
    uint256 unlockedAt;
    mapping (address => uint256) allocations;
    function allocate() onlyOwner {
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
   
    function withDraw(){
        if(now < unlockedAt){ 
            return;
        }
        if(allocations[msg.sender] > 0){
            balances[msg.sender] += allocations[msg.sender];
            allocations[msg.sender] = 0;
        }
    }
}