pragma solidity ^0.4.11;

contract NTRYToken{
   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
}   

contract BountiesDisPhase1{
    
    address public  owner;
    NTRYToken private notaryToken;
    
  
    function BountiesDistribution(){
        owner = 0x86d6e0307825DeA879bc9D605C0BB359B11715A7;
        notaryToken = NTRYToken(0x3ad8d6b50DDfc98487AC191b16CAaC0a275E1681);
    }
        
    struct Record{
        address investor;
        uint ntry;
    }
    
    Record[] public Ledger;
    
    function InitRecords() onlyOwner {
              Ledger.push(
            Record({
              investor : 0xC38Ff609038812Ce676627FC8B4E2C8C8DBFD813,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xc286212f207037479c070F1626eAE3aF3CEd2126,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x1eE06F228451C2d882b7afe6fD737989665BEc52,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xFFB9a31520965eE021D634Af67ea2ac6A1606BF3,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xbF022480bdA3f6c839CD443397761D5E83f3c02b,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x672DBb9AAaE9F80F3FdB39C1ae64695e473E0C0C,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x672DBb9AAaE9F80F3FdB39C1ae64695e473E0C0C,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x9A79bC75E27E7c2e227FADAe5B5636C5B9A12469,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x9A79bC75E27E7c2e227FADAe5B5636C5B9A12469,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xE93f762d2E38e129cDa9c43869e42c0738954fe2,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xDF41f62241289FFd28Af083d7fB671d796E04893,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xD1ccEE2b4c8Af8bB69A1D47B8de22a2C73c04F7A,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xcb33b5b3365e5A39d51d473D43A5dA783Dc23355,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x5ca93D0E9D26EEF06Fcfc36244e4017DF3CFb478,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x1eE06F228451C2d882b7afe6fD737989665BEc52,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x1eE06F228451C2d882b7afe6fD737989665BEc52,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xb0E701787A769B4a241fC5A1fA3Ca2B62605c0a4,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x0E1943E9A07E222eF6BbF5C0c54B403F7D807ef6,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x1eE06F228451C2d882b7afe6fD737989665BEc52,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xc317eD437bA777937A83252BB53C39e533138C84,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x56e009E583bA17576E7e09f2a1Ac31f55fC406a3,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x1eE06F228451C2d882b7afe6fD737989665BEc52,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x75f8d0C29E98d8636Ee66aff9656AC0523553fBD,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x75f8d0C29E98d8636Ee66aff9656AC0523553fBD,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x48CD0aA19eD8443151DC1B0baB50D6D3715475C9,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x2Da4508F12cF70c92beB4D517aDa86d24461EdAc,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x8bB0dCc74BCC82FA41478cFF326BaE173B329E6E,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xFcC2abAeF6B50593f14ED0F63bf9fD14818a671e,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x7A2932B79Adfffe6C76caCb49e58D0C4bAa27351,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x7457fDe09b9f50C416618274c787b75f402439B3,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x0fC93F2B5D4fad0874e9B2d90dDb60d664B06bEe,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xE7A51375277328981e054EEDedf71b8BAb93948B,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x7C285652d6282d09EEf66c8ACF762991e3f317a8,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x5eAE8B8eD0F1404Eb730F2FB228782b50bC1721c,
              ntry : 300000000000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xC83aaEae8ECF9884BfB305F69E1c006AbcF0696e,
              ntry : 4431314623000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x49225fE668E02C1a65C1075d8DbA32838e1548eD,
              ntry : 8641063516000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x56e009E583bA17576E7e09f2a1Ac31f55fC406a3,
              ntry : 8862629247000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x29DCb5a8F7067055dD0171CABDc4Edc47D4106a3,
              ntry : 7090103397000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xFE1E0980044F1cCebfC36ec6A5123CbCD69b15C4,
              ntry : 4431314623000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x34C53D6301C6e81c5a9CDD8333dfCD6625fc5C35,
              ntry : 8862629247000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xAe085F56bFfcc4b3CC36de49519f3185E09e64e7,
              ntry : 8862629247000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x1Ea8Fb629c19394064f345BAa85eCb0688EBFF4D,
              ntry : 4431314623000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xbD27Cbd592050D40BB531DAde8DF9D1E59F108F9 ,
              ntry : 8862629247000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x10A7ec8640956Eea0B539399b8536BA9cB4bBaEF ,
              ntry : 3877400295000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xFcD991Ba83bb0C10132Ed03989e616916591A399 ,
              ntry : 4431314623000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x21F1dF7bC554220D5997e433E3287A12A6Ed5eB7 ,
              ntry : 7754800591000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x9C0fDE6EDAe28Ed41E113C703f8623A5F438894f ,
              ntry : 3877400295000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x25f3EAeb9BecC442e20d3EDba11830304A435801 ,
              ntry : 3877400295000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xb8733A16dCbb8E808250dd1114a29Ce9Df7331B8 ,
              ntry : 7311669129000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x2BBEEA86F155668d78FB108da0Ff5725B06f6994 ,
              ntry : 3323485968000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x45246424b715806Fe3e0A219961DF6bd390D1E69 ,
              ntry : 5317577548000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x27b7F9E66119BdAB6E7EB49d34805d5041b0b77d ,
              ntry : 5317577548000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x95496cb0cd370AB255e0EAa9B919E2a246871af8 ,
              ntry : 5317577548000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xadD8b8B693d214F03fF1394816922a1F10ED516A ,
              ntry : 5317577548000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xA924bFf170DF8567276fDc9758B4e46Dc8e968dB ,
              ntry : 5317577548000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xf46EC11f19C50216623c2b045FDb020e1dD556e5 ,
              ntry : 4431314623000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x18fe033006fFABF2D72ae31045E815Ce920134d0 ,
              ntry : 5539143279000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xb896522287CE02d183CB586Aa04e498F551C0be2  ,
              ntry : 2769571640000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x4689f49Aa045dc52ee6B853B3bBC6a143783f420  ,
              ntry : 2769571640000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xdeE9821084139F7f77380AeBEE7b6aC46E8ed823  ,
              ntry : 2769571640000000000000
        }));
      Ledger.push(
            Record({
              investor : 0xFf342491cC946B8Cd9d7B48484306a0C18B814Dd ,
              ntry : 4431314623000000000000
        }));
      Ledger.push(
            Record({
              investor : 0x042427cc1B80Fe5af4D0973554a940BAa67B0801,
              ntry : 886262924700000000000
        }));
      Ledger.push(
            Record({
              investor : 0xfFF78f0db7995c7f2299D127d332AEF95bc3E7B7,
              ntry : 393849581268000000000
        }));
      Ledger.push(
            Record({
              investor : 0x00Dae27B350BaE20C5652124af5d8B5cBA001eC1 ,
              ntry : 116364649011000000000
        }));
      Ledger.push(
            Record({
              investor : 0x394c426b70C82aC8eA6e61b6bb1c341d7B1B3fe9,
              ntry : 393849581268000000000
        }));
      Ledger.push(
            Record({
              investor : 0xD14a86C1D73c2B583b540838Ad2C541182138484,
              ntry : 393849581268000000000
        }));
      Ledger.push(
            Record({
              investor : 0x95FB5AFb14C1EF9AB7d179C5c300503fD66a5eE2,
              ntry : 393849581268000000000
        }));
      Ledger.push(
            Record({
              investor : 0x840f24b9d1A584Aa61d3b3DaBf264Da4E3dA48C1,
              ntry : 393849581268000000000
        }));
      Ledger.push(
            Record({
              investor : 0xf177015d46b43543B68fE39A0eBA974944460F6a,
              ntry : 393849581268000000000
        }));
      Ledger.push(
            Record({
              investor : 0x5043Bf2276abcC19da847FDdce7c6645cc41A997,
              ntry : 208859626430000000000
        }));
      Ledger.push(
            Record({
              investor : 0xe3D8a8B4a4aA87d11AF9307c95DB5DCD3C5F2841,
              ntry : 393849581268000000000
        }));
      Ledger.push(
            Record({
              investor : 0xCe20e0ce916Ba26e2BC7f91fe82ab5a95fA5c80d,
              ntry : 393849581268000000000
        }));
      Ledger.push(
            Record({
              investor : 0x0FEF4e3474010c863a2d3471DFEb5460F11307cA,
              ntry : 393849581268000000000
        }));
      Ledger.push(
            Record({
              investor : 0x611F881eB3499583c9cfD7c7C5E7Ec0905Cb2B69,
              ntry : 208859626430000000000
        }));
      Ledger.push(
            Record({
              investor : 0x22Fb3D81a7bFBe286C17FBF6165A395233690885,
              ntry : 208859626430000000000
        }));
      Ledger.push(
            Record({
              investor : 0xD3E61B8aC38EA38B2A557E878130CE2Dff69da75,
              ntry : 393849581268000000000
        }));
      Ledger.push(
            Record({
              investor : 0xB9cDe3B46a5F8C7eb633D6DAC0CF054D3Ce64D35,
              ntry : 393849581268000000000
        }));
      Ledger.push(
            Record({
              investor : 0x1FB3356Af7311A70f821B30b4fdbb7EF2f054043,
              ntry : 146201738501000000000
        }));
      Ledger.push(
            Record({
              investor : 0x8E90cD73A8F793F74d4117019231dceD33626384 ,
              ntry : 116364649011000000000
        }));
      Ledger.push(
            Record({
              investor : 0x0190a8cB265bdba59f4758C26e17ebAA56b0DDf4,
              ntry : 393849581268000000000
        }));
    }
    
    event Message(string msg, uint value);
    
    function distribute(uint startFrom) onlyOwner returns (bool distributed){
        
        for(uint i = startFrom; i < Ledger.length; i++){
            
            if (!notaryToken.transferFrom(owner, Ledger[i].investor, Ledger[i].ntry)){
                throw;
            }
        }
        Message("successfully transferred",0);
        return true;
    }
    
    function mortal() onlyOwner{
        selfdestruct(owner);
    }
    
    function () payable {
        throw;
    }
    
    /**
     * @dev Throws if called by any account other than the owner. 
     **/
    modifier onlyOwner() {
       if (msg.sender != owner) {
          throw;
        }
        _;
    }
}



