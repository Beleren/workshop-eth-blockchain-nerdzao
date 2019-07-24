Workshop Ethereum e Smart Contracts 
Nerdzao 20/jul/2019
Solange Gueiros

www.atlasquantum.com
www.blockchainacademy.com.br
https://www.fiap.com.br/mba/mba-em-blockchain-development-e-technologies/

https://www.linkedin.com/in/solangegueiros
https://twitter.com/solangegueiros
https://medium.com/@solangegueiros
https://www.facebook.com/solangegueiros
https://instagram.com/solangegueiros
#womeninblockchainbr (whatsapp / telegram)

. Antes eu rodei sem ter certeza se precisava:
```
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum
```

.   Primeiro instalei o geth em: https://geth.ethereum.org/downloads/

.   Depois criamos o arquivo genesis:
```
genesis.json

{
    "difficulty" : "0x20000", #auto-ajuste de dificuldade de blockchain
    "gasLimit" : "0x800000", #taxa de mineração(fee)
    "alloc" : {},
    "config": {
        "chainId": 100, #Endereço do blockchain
        "homesteadBlock": 0,
        "eip155Block": 0,
        "eip158Block": 0
    }
}
```

.   Depois iniciei o blockchain com `geth --datadir "data-private" init "genesis.json"` (só precisa ser feito uma vez)

.   Depois executei o nó `geth --datadir "data-private"`

.   Existem dois protocolos de comunicação: IPC(inter process communicator) e RPC, no workshop usamos o IPC para 'se comunicar com o terminal geth', que estava rodando o blockchain: `geth attach /home/leandro/Projects/ETH/data-private/geth.ipc`. (o PATH do IPC foi encontrado no log `IPC endpoint opened`)

.   Na janela anexada, usei o `personal` para listagem de contas

.   Criei uma conta com `personal.newAccount("GoHorse")` -> "0x7cb7c97dfa603b0969dd4bcafb1fe7058b436075"
O objetivo de criar a conta é a mineração de ether

.   Iniciei a mineração com `miner.start(1)`, para parar é `miner.stop()`

.   Para ver saldo em conta `eth.getBalance(eth.accounts[0])`

.   Para ver saldo em Ether `web3.fromWei(eth.getBalance(eth.accounts[0]),"ether")`

. Exercício: Realizar transação entre contas
    - Criei segunda conta `personal.newAccount("Estado")` -> "0xb2eceb2a7a5268b39cea06f4ebf2c83b0459946a"
    - Verifiquei saldo em conta nova `eth.getBalance(eth.accounts[1])`
    - Desbloqueei conta que quero retirar o dinheiro `personal.unlockAccount(eth.accounts[0], "GoHorse", 0)` -> o segundo parametro é o password
    - Transferi dinheiros `eth.sendTransaction({from:eth.accounts[0], to:eth.accounts[1], value: web3.toWei(100, "ether")})` -> "0xbfef4f52d66fd4326b74fc00b558e1d27c6f7abc6827c07d8e1640e5c227f9fa"
        ~ Agora a transação está na espera de ser minerada
        ~ Uma transação tem um lifespan para ser minerada

. Exercício 2(visualização de fee de mineração): Transferir 50 eth de 1 para 2
    - Criei terceira conta `personal.newAccount("USA")`
    - Verifiquei saldo em conta 1 `eth.getBalance(eth.accounts[1])`
    - Desbloqueei conta que quero retirar o dinheiro `personal.unlockAccount(eth.accounts[1], "Estado", 0)`
    - Transferi dinheiros `eth.sendTransaction({from:eth.accounts[1], to:eth.accounts[2], value: web3.toWei(50, "ether")})`
    - Verifiquei saldo em conta 1 `eth.getBalance(eth.accounts[1])`, ela está com um valor fracionado(fee)

.   Smart Contracts
    - Usamos o solidity `register.sol`
```
pragma solidity >=0.5.1;

contract Register {
    address public owner;
    string private info;

    constructor() public {
        owner = msg.sender;
    }

    function setInfo(string memory _info) public {
        info = _info;
    }

    function getInfo() public view returns (string memory) {
        return info;
    }
       
}

```

    - Usamos o remix para compilação https://remix.ethereum.org/
    - Criei no remix o `register.sol` e compilei com `auto compile`
    - Em detalhes, copiei o `web3deploy` e coloquei em um arquivo novo `register.js`
    - A register.js tem uma `ABI` que é o esqueleto do contrato
    - Publiquei o contrato no blockchain com `loadScript("./register.js");`
    - Um smart contract pode receber ether
    - Com o contrato registrado, podemos usar `register.owner()`, assim podemos ver que o hash é igual a da conta 0
    - Functionhashes são hashes que representam funções
    - getInfo() poderá ser executado pois a não é necessário usar nada, ele lê do node local
    - setInfo("Lelelele") é preciso utilizar saldo de alguma conta para poder ser realizado, dessa forma é necessário, dessa forma: `register.setInfo("Lelele", {from:eth.accounts[0]})`
    - Para as pessoas se comunicarem com seu contrato é preciso o endereço e a ABI
    - Token Ethereum requerst comment (ERC20): 
      ~ ABI padrão

.   Criação de token
    - Open zeppelin
    - Truffle

    - Abri um terceiro terminal e instalei o Truffle
        ~ Truffle
            ```
            https://truffleframework.com/
            https://truffleframework.com/truffle
            https://www.trufflesuite.com/docs/truffle/overview

            node 8.9.4^
            Install
            npm install -g truffle

            truffle version
            ```
    - Criei um diretório ETH/token e iniciei npm `npm  init -y` e instalei o open zeppelin `npm install -E openzeppelin-solidity`
    - DESCOMENTAR os trechos abaixo e Alterar a versao do compilador
        ```
        module.exports = {
        networks: {
                development: {
                host: "127.0.0.1",
                port: 8545,
                network_id: "*"
                }
        },
        compilers: {
                solc: {
                version: "0.5.2",        // Fetch exact version from solc-bin (default: truffle's version)
                }
        }
        };
        ```

    - Criei o arquivo `Token.sol` em `contracts`
  
  ```
  pragma solidity 0.5.2;  

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol';

contract Token is ERC20Mintable{
        string public name = "Go Horse";
        string public symbol = "XGH";
        uint8 public decimals = 2;
}
  ```

- Token ERC20
https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol

- Mint
https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Mintable.sol

- Criei arquivo `2_deploy_contracts.js` dentro de migrations
```var Token = artifacts.require("Token");

module.exports = function(deployer) {
  deployer.deploy(Token);
};
```

- No terminal 3 `truffle compile`

- Reiniciar geth e iniciar com `geth --datadir "data-private" --rpc --rpccorsdomain "*" --allow-insecure-unlock`
- Reiniciar mineração com `exit` e `geth attach /home/leandro/Projects/ETH/data-private/geth.ipc` e `miner.start(1)`
- Desbloquear novamento a conta 0 `personal.unlockAccount(eth.accounts[0], "GoHorse", 0)`
- Realizar migrate de truffle `truffle migrate`
- Copiar contract address de token para o terminal attach `var address = "0xAeEB831e9a77917518D7547d1CbB80a094A49992"
- também em attach `var abi = >abi sem quebra de linha em build token.json https://www.textfixer.com/tools/remove-line-breaks.php<`
- Transferência de token
```

baseContract = web3.eth.contract(abi);
token = baseContract.at(address);

token. TAB TAB

token.name()
token.symbol()

token.balanceOf(eth.accounts[0])

token.mint(eth.accounts[0], 200000, {from:eth.accounts[0]})

token.transfer(eth.accounts[1], 30000, {from:eth.accounts[0]})

```

Referências de front:
Projeto: petshop
https://truffleframework.com/tutorials/pet-shop
https://github.com/truffle-box/pet-shop-box

