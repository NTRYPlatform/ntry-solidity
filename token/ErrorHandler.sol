/**
 *  NTRY Cointract contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
 *
 *  Code is based on multiple sources:
 *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts
 *  https://github.com/TokenMarketNet/ico/blob/master/contracts
 *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts
 */
pragma solidity ^0.4.11;

contract ErrorHandler {
    bool public isInTestMode = false;
    event evRecord(address msg_sender, uint msg_value, string message);

    function doThrow(string message) internal {
        evRecord(msg.sender, msg.value, message);
        if (!isInTestMode) {
        	throw;
		}
    }
}