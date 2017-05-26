pragma solidity ^0.4.2;

contract NTRYToken{
   function transfer(address _to, uint256 _value) returns (bool success);
   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
   function balanceOf(address _owner) constant returns (uint256 balance);
   function approve(address _spender, uint256 _value) returns (bool success);
   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
}

contract PreICO {
    
    struct Contribution {
        uint256 amount;
        address contributor;
    }
    Contribution[] public contributions;
    
    address public beneficiary;
    uint256 public constant tokensAsReward =  3500000 * 1 ether;

    uint public constant PRICE = 1000;                 // 1 ether = 1000 NTRY tokens
    uint256 constant minimumFundingGoal = 3400;
    
    uint constant deadline = now + (30 * 1 minutes);   // Time limit for PRE-ICO
    uint256 remainingTokens = tokensAsReward;
    uint256 amountRaised = 0;                          // Funds raised in ethers
    
    bool preICOClosed = false;

    address private tokenOwner;                         // address of account owns total supply
    bool private returnFunds = false;
    NTRYToken private notaryToken;
    
    event GoalReached(address owner, uint amountRaised);
    event LogFundingReceived(address contributor, uint amount, uint currentTotal);
    event FundTransfer(address backer, uint amount, bool isContribution);

    // Initialize the contract
    function PreICO(address _tokenOwner,address _addressOfNTRYToken,address ifSuccessfulSendTo ){
        tokenOwner = _tokenOwner; 
        notaryToken = NTRYToken(_addressOfNTRYToken);
        beneficiary = ifSuccessfulSendTo;
    }

    event Test(string msg);

    // Recieve funds and rewards tokens
    function () payable {
        if(preICOClosed || msg.value == 0){ 
            // throw;
            Test("failed at 1");
            return;
        }       // return if pre-ico is closed or received funds are zero
        uint256 amount = msg.value * PRICE;                // calculates the amount of NTRY
        if (remainingTokens >= amount){
            amount = addBonuses(amount);
            if (notaryToken.transferFrom(tokenOwner, msg.sender, amount)){
                amountRaised += msg.value;
                contributions.push(Contribution({
                    amount: msg.value,
                    contributor: msg.sender
                    })
                );
                LogFundingReceived(msg.sender, msg.value, amountRaised);
            }else{ 
                Test("failed to transfer");
                // throw; 
            }
        }else{
            // throw;
            Test("Remaining less");
            return;
        }  
    }

    /* For the first 1.500.000 NTRY tokens investors will get additional 125% of their investment.
    The second 1.000.000 NTRY tokens investors will get additional 100% of their investment.
    And for last 1.000.000 NTRY tokens investors will get additional 62.5% of their investment. */
    /// @param amount NTRY tokens inverster get in return of fund
    function addBonuses(uint256 amount) returns(uint256){
        uint256 reward;
        var (x, y) = (reward,reward);                // define type at compile at time
        if(remainingTokens > 200000000 * 1 ether){
            (x, y) = levelOneBonus(amount);
             reward += x;
            if(y != 0){
                (x, y) = levelTwoBonus(y);
                reward += x;
                if(y != 0){
                    return reward+levelThreeBonus(y);
                }
            }
            return reward;
        }else if(remainingTokens > 100000000 * 1 ether){
            (x, y) = levelTwoBonus(amount);
            if(y != 0){
                return x+levelThreeBonus(y);
            }
            return x;
        }else{
            return levelThreeBonus(amount);
        }
    }

    /* Add 125% bonus */
    /// @param amount NTRY tokens inverster have purchased
    function levelOneBonus(uint256 amount)returns(uint256,uint256){
        uint256 available = remainingTokens - 200000000 * 1 ether;
        if(available >= amount){
            remainingTokens -= amount;
            return (amount * 9/4, 0);
        }else{
            remainingTokens -= available;
            return(available * 9/4, amount - available);
        }
    }

    /* Add 100% bonus */
    /// @param amount NTRY tokens inverster have purchased
    function levelTwoBonus(uint256 amount)returns(uint256,uint256){
        uint256 available = remainingTokens - 100000000 * 1 ether;
        if(available >= amount){
            remainingTokens -= amount;
            return (amount * 2, 0);
        }else{
            remainingTokens -= available;
            return(available * 2, amount - available);
        }
    }

    /* Add 62.5% bonus */
    /// @param amount NTRY tokens inverster have purchased
    function levelThreeBonus(uint256 amount)returns(uint256){
        return amount * 13/8;
    } 

    modifier afterDeadline() { if (now >= deadline) _; }
    
    function checkGoalReached() afterDeadline {
        if(amountRaised >= minimumFundingGoal){
            GoalReached(beneficiary, amountRaised);
            returnFunds = false;
            remainingTokens = 0;
        }else{
            remainingTokens = 7000000 * 1 ether; // In case of failing return funds and save all tokens for adding up into ICO
            returnFunds = true;
        }
        Test("ICO Closed");
        preICOClosed = true;
    }

    // In case success funds will be transfered to beneficiary otherwise contibutors can safely withdraw their funds
    function safeWithdrawal() afterDeadline {
        if (returnFunds) {
            uint amount = notaryToken.balanceOf(msg.sender) / PRICE;
            // notaryToken.balanceOf[msg.sender] = 0;
            if (amount > 0) {
                if (msg.sender.send(amount)) {
                    FundTransfer(msg.sender, amount, false);
                } else {
                    // notaryToken.balanceOf[msg.sender] = amount;
                }
            }
        }
        if (!returnFunds && beneficiary == msg.sender) {
            if (beneficiary.send(amountRaised)) {
                FundTransfer(beneficiary, amountRaised, false);
            } else {
                //If we fail to send the funds to beneficiary, unlock funders balance
                returnFunds = true;
            }
        }
    }

}