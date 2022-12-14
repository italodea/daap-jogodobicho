// SPDX-License-Identifier: UNLICENSED


pragma solidity ^0.7.0;

// pragma abicoder v2;
pragma experimental ABIEncoderV2;

import "./owner.sol";

contract JogoDoBicho is Mortal{
    uint balance = 0;

    //Struct feita para diminuir uso de gás
    struct JogosList{
        mapping(address => Jogo) bichos;
        bool _isDeleted;
    }

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

    //mapping que armazena um mapping de listas e a informação de sua deleção ou não
    mapping(address => JogosList) jogosArray;

    address[] jogosOwners;

    event ListUpdated(address listOwner);

    modifier onlyJogoOwner(address end){
        require(_onlyJogoOwner(end), "Voce nao pode executar esta acao nesse jogo");
        _;
    }


    function _onlyJogoOwner(address _end) public view returns(bool){
        return _end == jogosArray[_end].bichos[_end].ownerAddress;
    }


    function createNewJogo(string memory tipoDeJogo, string memory jogoDate) public returns(bool){
        require(msg.sender == jogosArray[msg.sender].bichos[msg.sender].ownerAddress, "Este jogador ja apostou hoje!");
        jogosArray[msg.sender].bichos[msg.sender].ownerAddress = msg.sender;
        jogosArray[msg.sender].bichos[msg.sender].tipoDeJogo = tipoDeJogo;
        jogosArray[msg.sender].bichos[msg.sender].jogoDate = jogoDate;
        jogosOwners.push(msg.sender);
        emit ListUpdated(msg.sender);
        return true;
    }


    function addBichoToJogo(uint numero, uint valor) public onlyJogoOwner(msg.sender) returns (Bicho memory){
        uint256 id = hash(numero, valor, msg.sender);
        Bicho memory bicho = Bicho(id, numero,valor, address(0),false);
        jogosArray[msg.sender].bichos[msg.sender].bichos.push(bicho);
        emit ListUpdated(msg.sender);

        return bicho;
    }

    function delBichoFromJogo(uint256 id) public onlyJogoOwner(msg.sender) returns(bool){
        Bicho[] storage bichos = jogosArray[msg.sender].bichos[msg.sender].bichos;
        for(uint i = 0; i < bichos.length; i++){
            if(bichos[i].id == id){
                bichos[i] = bichos[bichos.length - 1];
                bichos.pop();
                emit ListUpdated(msg.sender);
                return true;
            }
        }
        return false;
    }


    function finishJogo() public onlyJogoOwner(msg.sender) returns (bool){
        uint value = calcularTotalJogo(msg.sender);


        if(value == 0){
            return false;
        }
        msg.sender.transfer(value);

        jogosArray[msg.sender]._isDeleted = true;
        deleteObjectFromArray(msg.sender);


        emit ListUpdated(msg.sender);
        return true;
    }


    function toBicho(uint256 id, address addr) external payable returns (bool) {
        require(jogosArray[addr].bichos[addr].bichos.length > 0, "Nao foi encontrado nenhum bicho nesse jogo!");
        Bicho[] storage bichos = jogosArray[addr].bichos[addr].bichos;
        for(uint i = 0; i < bichos.length; i++){
            if(id == bichos[i].id && bichos[i].valor <= msg.value){
                bichos[i].apostador = msg.sender;
                bichos[i].isValida = true;
                balance += msg.value - bichos[i].valor;
                emit ListUpdated(addr);
                return true;
            }
        }
        return false;
    }



    function calcularTotalJogo(address addr) internal view returns(uint){
        uint total = 0;
        Bicho[] memory bichos = jogosArray[addr].bichos[addr].bichos;

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
        jogo.ownerAddress = jogosArray[addr].bichos[addr].ownerAddress;
        jogo.tipoDeJogo = jogosArray[addr].bichos[addr].tipoDeJogo;
        jogo.jogoDate = jogosArray[addr].bichos[addr].jogoDate;
        jogo.bichos = jogosArray[addr].bichos[addr].bichos;

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
            lista.ownerAddress = jogosArray[jogosOwners[i]].bichos[jogosOwners[i]].ownerAddress;
            lista.tipoDeJogo = jogosArray[jogosOwners[i]].bichos[jogosOwners[i]].tipoDeJogo;
            lista.jogoDate = jogosArray[jogosOwners[i]].bichos[jogosOwners[i]].jogoDate;
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
