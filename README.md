# Notary-Platform

## NotaryPlatform Token Contract

Notary token is an ERC20 token. NTRY token contract have following features:
- Mitigation of short address attack  
  http://vessenes.com/the-erc20-short-address-attack-explained/
- Circuite Breaker  
  Circuit Breakers (Pause contract functionality), it stop execution if certain conditions are met and can be useful when new errors are discovered. For example, most actions may be suspended in a contract if a bug is discovered, so the most feasible option to stop and updated migration message about launching an updated version of contract.
- Reenterancy Attach Mitigation
- Upgradeable  
  In future if token contract upgrade is required, this feature will be used to transfer tokens to upgraded one.

## Crowdfunding Contract
## PreICO Contract is oudated