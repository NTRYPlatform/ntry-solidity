# Notary-Platform


NTRY token contract is upgraded for following features:
- Mitigation of short address attack  
  http://vessenes.com/the-erc20-short-address-attack-explained/
- Circuite Breaker  
  Circuit Breakers (Pause contract functionality), it stop execution if certain conditions are met and can be useful when new errors are discovered. For example, most actions may be suspended in a contract if a bug is discovered, so the most feasible option to stop and updated migration message about launching an updated version of contract.
- Freeze Account  
  Administrator can set any account into freeze state. It is helpful in case if account holder has lost his key and he want administrator to freeze account until account key is recovered.
- Burn Tokens  
  The amount of NTRY remains unsold in coin offering will be burnt
- Upgradeable  
  In future if token contract upgrade is required, this feature will be used to transfer tokens to upgraded one.

## PreICO Contract is oudated