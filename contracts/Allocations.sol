/**
 *  Allocations.sol v1.0.0
 * 
 *  Bilal Arif - https://twitter.com/furusiyya_
 *  Notary Platform
 */
 
pragma solidity ^0.4.16;

contract Allocations{

	// timestamp when token release is enabled
  	uint256 private releaseTime;

	mapping (address => uint256) private allocations;

	function Allocations(){
		releaseTime = now + 245 * 1 days;
		allocate();
	}

	/**
	 * @notice NTRY Token distribution between team members.
	 */
    function allocate() private {
      allocations[0xab1cb1740344A9280dC502F3B8545248Dc3045eA] = 4000000 * 1 ether; // Iztok
      allocations[0x330709A59Ab2D1E1105683F92c1EE8143955a357] = 4000000 * 1 ether; // Saso
      allocations[0xAa0887fc6e8896C4A80Ca3368CFd56D203dB39db] = 3000000 * 1 ether; // Bilal
      allocations[0x1fbA1d22435DD3E7Fa5ba4b449CC550a933E72b3] = 200000 * 1 ether;  // Anita
      allocations[0xC9d5E2c7e40373ae576a38cD7e62E223C95aBFD4] = 200000 * 1 ether;  // Robi
      allocations[0xabc0B64a38DE4b767313268F0db54F4cf8816D9C] = 220000 * 1 ether;  // Yumna
      allocations[0x5d85bCDe5060C5Bd00DBeDF5E07F43CE3Ccade6f] = 20000 * 1 ether;   // Basit
      allocations[0xecb1b0231CBC0B04015F9e5132C62465C128B578] = 500000 * 1 ether;  // Miha
      allocations[0xF9b1Cfc7fe3B63bEDc594AD20132CB06c18FD5F2] = 250000 * 1 ether;  // Ziga
      allocations[0xDbb89a87d9f91EA3f0Ab035a67E3A951A05d0130] = 300000 * 1 ether;  // Luka 
      allocations[0xC1530645E21D27AB4b567Bac348721eE3E244Cbd] = 250000 * 1 ether;  // Sasa
      allocations[0xcfb44162030e6CBca88e65DffA21911e97ce8533] = 100000 * 1 ether;  // Matej
      allocations[0x64f748a5C5e504DbDf61d49282d6202Bc1311c3E] = 100000 * 1 ether;  // Gregor
      allocations[0xFF22FA2B3e5E21817b02a45Ba693B7aC01485a9C] = 2985000 * 1 ether; // Dev Reserve
      allocations[0xC9856112DCb8eE449B83604438611EdCf61408AF] = 2000000 * 1 ether; // Adv Reserve
      allocations[0x689CCfEABD99081D061aE070b1DA5E1f6e4B9fB2] = 1875000 * 1 ether; // Legal Matters
    }

	/**
	 * @notice Transfers tokens held by timelock to beneficiary.
	 */
	function release() internal returns (uint256 amount){
		amount = allocations[msg.sender];
		allocations[msg.sender] = 0;
		return amount;
	}

	/**
  	 * @dev returns releaseTime
  	 */
	function RealeaseTime() external constant returns(uint256){ return releaseTime; }

    modifier timeLock() { 
		require(now >= releaseTime);
		_; 
	}

	modifier isTeamMember() { 
		require(allocations[msg.sender] >= 10000 * 1 ether); 
		_; 
	}

}