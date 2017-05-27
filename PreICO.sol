pragma solidity ^0.4.2;

contract NTRYToken{
   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
   function balanceOf(address _owner) constant returns (uint256 balance);
   function takeBackNTRY(address _from,address _to, uint256 _value) returns (bool);
}

contract PreICO {
    
    event Notification(string msg);
    event Notification(string msg,uint256 value);
    
    address owner;
    modifier onlyOwner {if (msg.sender != owner) throw; _;}

    struct Contribution {
        uint256 amount;
        uint currentPrice;
        uint256 NTRY;
        address contributor;
    }
    
    // public variables
    Contribution[] public contributions;
    mapping (address => Contribution) rewardLedger;
    
    address beneficiary;
    
    uint256 constant tokensAsReward =  3500000 * 1 ether;
    uint PRICE = 1000;                 // 1 ether = 1000 NTRY tokens
    uint256 fundingGoal = 3480 * 1 ether;
    
    uint256 remainingTokens = tokensAsReward;
    uint256 amountRaised = 0;                          // Funds raised in ethers
   
    bool preICOClosed = false;
    bool returnFunds = false;

    // Time limit for PRE-ICO, Replace this dummy value with real one
    uint deadline = now + (3 * 1 minutes);    
    NTRYToken private notaryToken;
    address private tokenOwner;       // address of account owns total supply
    address private recoveryAccount;
    
    event GoalReached(address owner, uint amountRaised);
    event LogFundingReceived(address contributor, uint amount, uint currentTotal);
    event FundTransfer(address backer, uint amount, bool isContribution);

    // Initialize the contract
    function PreICO(address _contractOwner,address _tokenOwner,
        address _addressOfNTRYToken, address ifSuccessfulSendTo,address ifFailRecoverTo){
        owner = _contractOwner;
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
    function updatePrice(uint _price) onlyOwner {
        PRICE = _price;  
    }

    // Recieve funds and rewards tokens
    function () payable {
        if(preICOClosed || msg.value <= 0){ throw; }       // return if pre-ico is closed or received funds are zero
        uint256 amount = msg.value * PRICE;                // calculates the amount of NTRY
        if (remainingTokens >= amount){
            amount = addBonuses(amount);
            if (notaryToken.transferFrom(tokenOwner, msg.sender, amount)){
                amountRaised += msg.value;
                updateRewardLedger(msg.sender,msg.value,amount);
                LogFundingReceived(msg.sender, msg.value, amountRaised);
            }else{ throw; }
        }else{
            throw;
        }  
    }
    
    function updateRewardLedger(address _contributor,uint256 eth,uint256 ntry) {
        if (rewardLedger[_contributor].contributor == 0){
            Notification("Contributions exist already");
            rewardLedger[_contributor] = Contribution({
                amount: eth,
                currentPrice: PRICE,
                NTRY: ntry,
                contributor: _contributor
            });
            contributions.push(rewardLedger[_contributor]);
        }else{
            rewardLedger[_contributor].amount += eth;
            rewardLedger[_contributor].currentPrice = 0;
            rewardLedger[_contributor].NTRY += ntry;
            contributions.push(Contribution({
                    amount: eth,
                    currentPrice: PRICE,
                    NTRY: ntry,
                    contributor: _contributor
                    })
            );
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
            while (rewardLedger[msg.sender].NTRY > 0) {
                Notification("Amount to be returned: ", rewardLedger[msg.sender].amount);
                Notification("NOtary to be returned: ", rewardLedger[msg.sender].NTRY);
            
                notaryToken.takeBackNTRY(msg.sender, recoveryAccount , rewardLedger[msg.sender].NTRY);
                if (msg.sender.send(rewardLedger[msg.sender].amount)) {
                    FundTransfer(msg.sender, rewardLedger[msg.sender].amount, false);
                    delete rewardLedger[msg.sender];
                } else {
                    notaryToken.takeBackNTRY(recoveryAccount, msg.sender , rewardLedger[msg.sender].NTRY);    
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

    function mortal() {
        uint256 expire = deadline + (40320 * 1 minutes); 
        if (now >= expire && beneficiary == msg.sender){
            beneficiary.send(amountRaised);
        }
    }
}