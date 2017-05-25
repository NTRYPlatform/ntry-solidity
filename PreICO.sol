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
    uint256 public constant tokensAsBonuses =  3500000 * 1 ether;
    uint public constant PRICE = 1000;                 // 1 ether = 1000 NTRY tokens
    uint256 constant minimumFundingGoal = 3000;
    
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
        if (remainingTokens > amount){
            if (notaryToken.transferFrom(tokenOwner, msg.sender, amount)){
                amountRaised += msg.value;
                remainingTokens -= amount;
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

    function calcBonus(uint256 amount){
        
    }


    modifier afterDeadline() { if (now >= deadline) _; }
    
    function checkGoalReached() afterDeadline {
        if(amountRaised >= minimumFundingGoal){
            GoalReached(owner, amountRaised);
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
                    notaryToken.balanceOf[msg.sender] = amount;
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