/**
 *  Crowdfunding.sol v1.0.0
 * 
 *  Bilal Arif - https://twitter.com/furusiyya_
 *  Notary Platform
 */

pragma solidity 0.4.16;

import './Pausable.sol';
import './SafeMath.sol';
import './ReentrancyGuard.sol';

contract Crowdfunding is Pausable, ReentrancyGuard {

      using SafeMath for uint256;
    
      /* the starting time of the crowdsale */
      uint256 private startsAt;
    
      /* the ending time of the crowdsale */
      uint256 private endsAt;
    
      /* how many token units a buyer gets per wei */
      uint256 public rate;
    
      /* How many wei of funding we have received so far */
      uint256 private weiRaised = 0;
    
      /* How many distinct addresses have invested */
      uint256 private investorCount = 0;
      
      /* How many total investments have been made */
      uint256 private totalInvestments = 0;
      
      /* Address of multiSig contract*/
      address private multiSig;
      
      /* Address of tokenStore*/
      address private tokenStore;
      
      /* Address of pre-ico contract*/
      NotaryPlatformToken private token;
     
    
      /** How much ETH each address has invested to this crowdsale */
      mapping (address => uint256) private investedAmountOf;
    
      
      /** State machine
       *
       * - Prefunding: We have not passed start time yet
       * - Funding: Active crowdsale
       * - Closed: Funding is closed.
       */
      enum State{PreFunding, Funding, Closed}
    
      /**
       * event for token purchase logging
       * @param purchaser who paid for the tokens
       * @param beneficiary who got the tokens
       * @param value weis paid for purchase
       * @param amount amount of tokens purchased
       */
      event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
      // Funds transfer to other address
      event Transfer(address indexed receiver, uint256 weiAmount);
    
      // Crowdsale end time has been changed
      event EndsAtChanged(uint256 endTimestamp);
    
      event TokenContractAddress(address indexed oldAddress,address indexed newAddress);
      event TokenStoreUpdated(address indexed oldAddress,address indexed newAddress);
      event WalletAddressUpdated(address indexed oldAddress,address indexed newAddress);
    
      function Crowdfunding(
          address frOwner,
          uint256 startTimestamp, 
          uint256 endTimestamp, 
          address multiSigAddr, 
          address tokenAddr,
          address _tokenStore,
          uint256 _rate) 
      {
        
        require(frOwner != 0x00);
        require(multiSigAddr != 0x00);
        require(_tokenStore != 0x00);
        require(tokenAddr != 0);
        require(startTimestamp >= now); 
        require(endTimestamp  >= startTimestamp); 
        require(_rate > 0);
        
        owner = frOwner;
        multiSig = multiSigAddr;
        tokenStore = _tokenStore;
        
        token = NotaryPlatformToken(tokenAddr);
        require(token.isTokenContract());
    
        startsAt = startTimestamp;
        endsAt = endTimestamp;
        rate = _rate;
      }
    
      /**
       * Allow investor to just send in money
       */
      function() nonZero payable{
        buy(msg.sender);
      }
    
      /**
       * Make an investment.
       *
       * Crowdsale must be running for one to invest.
       * We must have not pressed the emergency brake.
       *
       * @param receiver The Ethereum address who will receive tokens
       *
       */
      function buy(address receiver) public whenNotPaused nonReentrant inState(State.Funding) nonZero payable returns(bool){
        require(receiver != 0x00);
        
        if(investedAmountOf[msg.sender] == 0) {
          // A new investor
          investorCount++;
        }
    
        // count all investments
        totalInvestments++;
    
        // Update investor
        investedAmountOf[msg.sender] = investedAmountOf[msg.sender].add(msg.value);
        
        // Up total accumulated fudns
        weiRaised = weiRaised.add(msg.value);
        
        // calculate token amount to be transfered
        uint256 tokens = msg.value.mul(rate);
        
        // Transfer NTRY tokens to receiver address
        if(!token.transferFrom(tokenStore,receiver,tokens)){
            revert();
        }
        
        // Tell us purchase was success
        TokenPurchase(msg.sender, receiver, msg.value, tokens);
        
        // Pocket the money
        forwardFunds();
        
        return true;
      }
      
      
      // send ether to the fund collection wallet
      function forwardFunds() internal {
        multiSig.transfer(msg.value);
      }
    
    
     // getters, constant functions
    
      /**
       * @return address of multisignature wallet 
       */
      function multiSigAddress() external constant returns(address){
          return multiSig;
      }
      
      /**
       * @return address of Notary Platform token
       */
      function tokenContractAddress() external constant returns(address){
          return token;
      }
      
      /**
       * @return address of NTRY tokens owner
       */
      function tokenStoreAddress() external constant returns(address){
          return tokenStore;
      }
      
      /**
       * @return startDate Crowdsale opening date
       */
      function fundingStartAt() external constant returns(uint256 ){
          return startsAt;
      }
      
      /**
       * @return endDate Crowdsale closing date
       */
      function fundingEndsAt() external constant returns(uint256){
          return endsAt;
      }
      
      /**
       * @return investors Total of distinct investors
       */
      function distinctInvestors() external constant returns(uint256){
          return investorCount;
      }
      
      /**
       * @return investments Crowdsale closing date
       */
      function investments() external constant returns(uint256){
          return totalInvestments;
      }
      
      /**
       * @param _addr Address of investor
       * @return Number of ethers invested by investor 
       */
      function investedAmoun(address _addr) external constant returns(uint256){
          require(_addr != 0x00);
          return investedAmountOf[_addr];
      }
      
       /**
       * @return total of amount of wie collected by the contract 
       */
      function fundingRaised() external constant returns (uint256){
        return weiRaised;
      }
      
      /**
       * Crowdfund state machine management.
       *
       * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
       */
      function getState() public constant returns (State) {
        if (now < startsAt) return State.PreFunding;
        else if (now <= endsAt) return State.Funding;
        else if (now > endsAt) return State.Closed;
      }
      
      // Setters, onlyOwner functions
      
       /**
       * @param _newAddress is address of multisignature wallet
       * @return true for case of success
       */
      function updateMultiSig(address _newAddress) external onlyOwner returns(bool){
          require(_newAddress != 0x00);
          WalletAddressUpdated(multiSig,_newAddress);
          multiSig = _newAddress;
          return true;
      }
      
       /**
       * @param _newAddress is address of NTRY token contract
       * @return true for case of success
       */
      function updateTokenContractAddr(address _newAddress) external onlyOwner returns(bool){
          require(_newAddress != 0x00);
          TokenContractAddress(token,_newAddress);
          token = NotaryPlatformToken(_newAddress);
          return true;
      }
      
       /**
       * @param _newAddress is address of NTRY tokens owner
       * @return true for case of success
       */
      function updateTokenStore(address _newAddress) external onlyOwner returns(bool){
          require(_newAddress != 0x00);
          TokenStoreUpdated(tokenStore,_newAddress);
          tokenStore = _newAddress;
          return true;
      }
      
      /**
       * Allow crowdsale owner to close early or extend the crowdsale.
       *
       * This is useful e.g. for a manual soft cap implementation:
       * - after X amount is reached determine manual closing
       *
       * This may put the crowdsale to an invalid state,
       * but we trust owners know what they are doing.
       *
       */
      function updateEndsAt(uint256 _endsAt) onlyOwner {
        
        // Don't change past
        require(_endsAt > now);
    
        endsAt = _endsAt;
        EndsAtChanged(_endsAt);
      }
    
    
    
      /** Interface marker. */
      function isCrowdsale() external constant returns (bool) {
        return true;
      }
    
      //
      // Modifiers
      //
      /** Modifier allowing execution only if the crowdsale is currently running.  */
      modifier inState(State state) {
        require(getState() == state);
        _;
      }
    
      /** Modifier allowing execution only if received value is greater than zero */
      modifier nonZero(){
        require(msg.value > 0);
        _;
      }
    }

contract NotaryPlatformToken{
    function isTokenContract() returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool);
}
