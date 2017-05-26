/**
 *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
 *
 *  Code is based on multiple sources:
 *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20.sol
 *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/HumanStandardToken.sol
 */
 
import "./StandardToken.sol";

pragma solidity ^0.4.8;

contract NotaryToken is StandardToken {

    function () {
        //if ether is sent to this address, send it back.
        throw;
    }


    /* Public variables of the token */

    string public name = "Notary Platform Token";
    uint8 public decimals = 18;
    string public symbol = "NTRY";
    string public version = 'NTRY-1.0';
    
    function NotaryToken() {
        /* Total supply is One hundred and fifty million (150,000,000)*/
        balances[msg.sender] = 150000000 * 1 ether;
        totalSupply = 150000000 * 1 ether;
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

}
