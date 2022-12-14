// SPDX-License-Identifier: UNLICENSED


pragma solidity ^0.7.0;

// pragma abicoder v2;
pragma experimental ABIEncoderV2;

import "./owner.sol";

contract JogoDoBicho is Mortal{
    uint256 public constant tokenPrice = 1000000000000000; // 1 value for 1000000000000000 wei


    struct Jogo{
        address ownerAddress;
        Bicho[] bichos;
        string jogoDate;
        string tipoDeJogo;
    }

    struct Bicho{
        uint256 id;
        uint numero;
        uint valor;
        address apostador;
        bool isValida;
    }

    struct JogosList{
        mapping(address => Jogo) jogos;
        bool _isDeleted;
    }

    mapping(address => JogosList) jogosArray;

    address[] jogosOwners;

    event JogosUpdated(address listOwner);

    modifier onlyJogoOwner(address addres){
        require(addres == jogosArray[addres].jogos[addres].ownerAddress, "Voce nao pode executar esta acao nesse jogo");
        _;
    }


    function createNewJogo(string memory tipoDeJogo, string memory jogoDate) public returns(bool){
        jogosArray[msg.sender].jogos[msg.sender].ownerAddress = msg.sender;
        jogosArray[msg.sender].jogos[msg.sender].tipoDeJogo = tipoDeJogo;
        jogosArray[msg.sender].jogos[msg.sender].jogoDate = jogoDate;
        jogosOwners.push(msg.sender);
        emit JogosUpdated(msg.sender);
        return true;
    }


    function addBichoToJogo(uint numero, uint valor) public onlyJogoOwner(msg.sender) returns (Bicho memory){
        require(numero > 0 && numero < 26,"Bicho invalido");
        require(valor > 0, "Valor invalido");
        uint256 id = hash(numero, valor, msg.sender);
        Bicho memory bicho = Bicho(id, numero,valor, msg.sender,false);
        jogosArray[msg.sender].jogos[msg.sender].bichos.push(bicho);
        emit JogosUpdated(msg.sender);

        return bicho;
    }

    function delBichoFromJogo(uint256 id) public onlyJogoOwner(msg.sender) returns(bool){
        Bicho[] storage bichos = jogosArray[msg.sender].jogos[msg.sender].bichos;
        for(uint i = 0; i < bichos.length; i++){
            if(bichos[i].id == id){
                bichos[i] = bichos[bichos.length - 1];
                bichos.pop();
                emit JogosUpdated(msg.sender);
                return true;
            }
        }
        return false;
    }


    function buy() external payable {
        uint _totalDoJogo = 0;
        Bicho[] storage bichos = jogosArray[msg.sender].jogos[msg.sender].bichos;
        require(bichos.length > 0, "Nao foi encontrado nenhum bicho nesse jogo");
        for(uint i = 0; i < bichos.length; i++){
            _totalDoJogo += bichos[i].valor;
            bichos[i].isValida = true;
            emit JogosUpdated(msg.sender);
        }

        require(msg.value == _totalDoJogo * tokenPrice, 'Need to send exact amount of wei');
        msg.sender.transfer(_totalDoJogo);

    }

    function finishJogo() public onlyJogoOwner(msg.sender) returns (bool){
        uint value = calcularTotalJogo(msg.sender);

        if(value == 0){
            return false;
        }
        msg.sender.transfer(value);

        jogosArray[msg.sender]._isDeleted = true;
        deleteObjectFromArray(msg.sender);


        emit JogosUpdated(msg.sender);
        return true;
    }




    function calcularTotalJogo(address addr) internal view returns(uint){
        uint total = 0;
        Bicho[] memory bichos = jogosArray[addr].jogos[addr].bichos;

        for(uint i = 0; i < bichos.length; i++){
            if(bichos[i].valor > 0){
                total += bichos[i].valor;
            }
        }


        return total;
    }


    function returnJogo(address addr) public view returns(Jogo memory){
        require(jogosArray[addr]._isDeleted == false, "Este jogo nao existe!");
        Jogo memory jogo;
        jogo.ownerAddress = jogosArray[addr].jogos[addr].ownerAddress;
        jogo.tipoDeJogo = jogosArray[addr].jogos[addr].tipoDeJogo;
        jogo.jogoDate = jogosArray[addr].jogos[addr].jogoDate;
        jogo.bichos = jogosArray[addr].jogos[addr].bichos;

        return jogo;
    }

    function returnAllJogos() public view returns(Jogo[] memory ) {
        Jogo[] memory jogosList = new Jogo[](jogosOwners.length);
        for(uint i = 0; i < jogosOwners.length; i++){
            
            if(jogosArray[jogosOwners[i]]._isDeleted){
                continue;
            }
            Jogo memory lista;
            Bicho[] memory bichos;
            lista.ownerAddress = jogosArray[jogosOwners[i]].jogos[jogosOwners[i]].ownerAddress;
            lista.tipoDeJogo = jogosArray[jogosOwners[i]].jogos[jogosOwners[i]].tipoDeJogo;
            lista.jogoDate = jogosArray[jogosOwners[i]].jogos[jogosOwners[i]].jogoDate;
            lista.bichos = bichos;
            jogosList[i] = lista;
        }
        return jogosList;
    }

    function deleteObjectFromArray(address addr) internal returns (bool){
        for(uint i = 0; i < jogosOwners.length; i++){
            if(jogosOwners[i] == addr){
                jogosOwners[i] = jogosOwners[jogosOwners.length - 1];
                jogosOwners.pop();
                return true;
            }
        }
        return false;
    }

    function hash(uint numero, uint valor, address addr) internal pure returns(uint256){
        return uint256(keccak256(abi.encodePacked(addr, valor, numero)));
    }
    
}
