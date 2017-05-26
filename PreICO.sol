pragma solidity ^0.4.2;

contract NTRYToken{
   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
   function balanceOf(address _owner) constant returns (uint256 balance);
   function takeBackNTRY(address _from,address _to, uint256 _value) returns (bool);
}

contract PreICO {
    
    struct Contribution {
        uint256 amount;
        address contributor;
    }
    
    // public variables
    Contribution[] public contributions;
    
    address beneficiary;
    
    uint256 constant tokensAsReward =  3500000 * 1 ether;
    uint PRICE = 1000;                 // 1 ether = 1000 NTRY tokens
    uint256 fundingGoal = 3480;
    
    uint256 remainingTokens = tokensAsReward;
    uint256 amountRaised = 0;                          // Funds raised in ethers
   
    bool preICOClosed = false;
    bool returnFunds = false;

    // Time limit for PRE-ICO, Replace this dummy value with real one
    uint deadline = now + (30 * 1 minutes);    
    NTRYToken private notaryToken;
    address private tokenOwner;       // address of account owns total supply
    address private recoveryAccount;
    
    event GoalReached(address owner, uint amountRaised);
    event LogFundingReceived(address contributor, uint amount, uint currentTotal);
    event FundTransfer(address backer, uint amount, bool isContribution);

    // Initialize the contract
    function PreICO(address _tokenOwner,address _addressOfNTRYToken,
        address ifSuccessfulSendTo,address ifFailRecoverTo){
        tokenOwner = _tokenOwner; 
        notaryToken = NTRYToken(_addressOfNTRYToken);
        beneficiary = ifSuccessfulSendTo;
        recoveryAccount = ifFailRecoverTo;
    }

    /* Geter functions for variables */
    
    function preICOBeneficiaryAddress() constant returns(address){ return beneficiary; }
    function NTRYAvailableForSale() constant returns(uint256){ return tokensAsReward; }
    function NTRYPerEther() constant returns(uint){ return PRICE; }
    function minimumFundingGoal() constant returns(uint256){ return fundingGoal; }
    function remaingNTRY() constant returns(uint256){ return remainingTokens; }
    function RaisedFunds() constant returns(uint256){ return amountRaised; }
    function isPreICOClosed() constant returns(bool){ return preICOClosed; }

    /* Set price of NTRY corresponding to ether */
    // @param _price Number of NTRY per ether
    function updatePrice(uint _price) returns(bool){
        PRICE = _price;
        return true;    
    }

    // Recieve funds and rewards tokens
    function () payable {
        if(preICOClosed || msg.value <= 0){ throw; }       // return if pre-ico is closed or received funds are zero
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
            }else{ throw; }
        }else{
            throw;
        }  
    }

    /* For the first 1.500.000 NTRY tokens investors will get additional 125% of their investment.
    The second 1.000.000 NTRY tokens investors will get additional 100% of their investment.
    And for last 1.000.000 NTRY tokens investors will get additional 62.5% of their investment. */
    /// @param _amount NTRY tokens inverster get in return of fund
    function addBonuses(uint256 _amount) returns(uint256){
        uint256 reward;
        var (x, y) = (reward,reward);                // define type at compile at time
        if(remainingTokens > 2000000 * 1 ether){
            (x, y) = levelOneBonus(_amount);
             reward += x;
            if(y != 0){
                (x, y) = levelTwoBonus(y);
                reward += x;
                if(y != 0){
                    return reward+levelThreeBonus(y);
                }
            }
            return reward;
        }else if(remainingTokens > 1000000 * 1 ether){
            (x, y) = levelTwoBonus(_amount);
            if(y != 0){
                return x+levelThreeBonus(y);
            }
            return x;
        }else{
            return levelThreeBonus(_amount);
        }
    }

    /* Add 125% bonus */
    /// @param _amount NTRY tokens inverster have purchased
    function levelOneBonus(uint256 _amount)returns(uint256,uint256){
        uint256 available = remainingTokens - 2000000 * 1 ether;
        if(available >= _amount){
            remainingTokens -= _amount;
            return (_amount * 9/4, 0);
        }else{
            remainingTokens -= available;
            return(available * 9/4, _amount - available);
        }
    }

    /* Add 100% bonus */
    /// @param _amount NTRY tokens inverster have purchased
    function levelTwoBonus(uint256 _amount)returns(uint256,uint256){
        uint256 available = remainingTokens - 1000000 * 1 ether;
        if(available >= _amount){
            remainingTokens -= _amount;
            return (_amount * 2, 0);
        }else{
            remainingTokens -= available;
            return(available * 2, _amount - available);
        }
    }

    /* Add 62.5% bonus */
    /// @param _amount NTRY tokens inverster have purchased
    function levelThreeBonus(uint256 _amount)returns(uint256){
        remainingTokens -= _amount;
        return _amount * 13/8;
    } 

    modifier afterDeadline() { if (now >= deadline) _; }
    
    function checkGoalReached() afterDeadline {
        if(amountRaised >= fundingGoal){
            GoalReached(beneficiary, amountRaised);
            returnFunds = false;
            remainingTokens = 0;
        }else{
            // In case of failing funds are transferred to team members  account; 
            // they will try to find resources to finance further development
            remainingTokens = 7000000 * 1 ether; 
            returnFunds = true;
        }

        preICOClosed = true;
    }

     // In case of success funds will be transferred to beneficiary otherwise 
     // contributors can safely withdraw their funds
    function safeWithdrawal() afterDeadline {
        if (returnFunds) {
            uint amount = notaryToken.balanceOf(msg.sender) / PRICE;
            if (amount > 0) {
                notaryToken.takeBackNTRY(msg.sender, recoveryAccount , amount);    
                if (msg.sender.send(amount)) {
                    FundTransfer(msg.sender, amount, false);
                } else {
                    notaryToken.takeBackNTRY(recoveryAccount, msg.sender , amount);
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
