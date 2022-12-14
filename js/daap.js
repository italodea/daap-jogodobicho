// ENDEREÇO EHTEREUM DO CONTRATO
var contractAddress = "0x5098C1393f3c159ba911D0915AED832F56A7bC29";

// Inicializa o objeto DaapJogoDoBicho
document.addEventListener("DOMContentLoaded", onDocumentLoad);
function onDocumentLoad() {
  DaapJogoDoBicho.init();
}

// Nosso objeto DaapJogoDoBicho que irá armazenar a instância web3
const DaapJogoDoBicho = {
  web3: null,
  contracts: {},
  account: null,

  init: function () {
    return DaapJogoDoBicho.initWeb3();
  },

  // Inicializa o provedor web3
  initWeb3: async function () {
    if (typeof window.ethereum !== "undefined") {
      try {
        const accounts = await window.ethereum.request({ // Requisita primeiro acesso ao Metamask
          method: "eth_requestAccounts",
        });
        DaapJogoDoBicho.account = accounts[0];
        window.ethereum.on('accountsChanged', DaapJogoDoBicho.updateAccount); // Atualiza se o usuário trcar de conta no Metamaslk
      } catch (error) {
        console.error("Usuário negou acesso ao web3!");
        return;
      }
      // DaapJogoDoBicho.web3 = "new Web3(window.ethereum)";
      DaapJogoDoBicho.web3 = new Web3(window.ethereum);
    } else {
      console.error("Instalar MetaMask!");
      return;
    }
    return DaapJogoDoBicho.initContract();
  },

  // Atualiza 'DaapJogoDoBicho.account' para a conta ativa no Metamask
  updateAccount: async function () {
    DaapJogoDoBicho.account = (await DaapJogoDoBicho.web3.eth.getAccounts())[0];
    atualizaInterface();
  },

  // Associa ao endereço do seu contrato
  initContract: async function () {
    DaapJogoDoBicho.contracts.Bicho = new DaapJogoDoBicho.web3.eth.Contract(abi, contractAddress);
    return DaapJogoDoBicho.render();
  },

  // Inicializa a interface HTML com os dados obtidos
  render: async function () {
    console.log("conectado");
  },
};

var teste;


async function addBichoToJogo() {

  document.getElementsByClassName("page-two")[0].style = "display:none";

  var bichos = document.getElementsByClassName("input-bichos");
  var numeros = [];
  var valores = [];
  for (var i = 0; i < bichos.length; i++) {
    if (bichos[i].value > 0 && bichos.value != "") {
      numeros.push(i + 1);
      valores.push(bichos[i].value);
    }
  }


  document.getElementsByClassName("page-progress")[0].style = "display:block";
  document.getElementsByClassName("text-progress")[0].innerHTML = "Adicionando bicho 0 de " + numeros.length + "...";


  if (valores.length == 0) {
    alert("Escolha ao menos um bicho");
    return;
  }

  var erros = 0;

  for (var i = numeros.length - 1; i > 0; i--) {
    try {
      var resultado = await DaapJogoDoBicho.contracts.Bicho.methods.addBichoToJogo(numeros[i],valores[i]).send({ from: DaapJogoDoBicho.account });
      document.getElementsByClassName("text-progress")[0].innerHTML = "Adicionando "+numeros.length+" bichos...";
      console.log(resultado);
    } catch (error) {
      numeros.splice(i,1);
      valores.splice(i,1);
      console.log(error.code);
      if (error.code == 4001) {
        erros++;
      }
    }
  }

  if(erros == numeros.length){
    alert("Nenhum bicho foi adicionado pois a transação não foi aceita no metamask");
    document.getElementsByClassName("page-two")[0].style = "display:block";
    document.getElementsByClassName("page-progress")[0].style = "display:none";
    return;
  }else if(erros > 0){
    alert("Nem todos os bichos foram adicionados pois a transação não foi aceita no metamask");
    document.getElementsByClassName("page-two")[0].style = "display:block";
    document.getElementsByClassName("page-progress")[0].style = "display:none";
    return;
  }


  document.getElementsByClassName("page-progress")[0].style = "display:none";
  document.getElementsByClassName("page-three")[0].style = "display:none";
  

  

  document.getElementsByClassName("page-two")[0].style = "display:none";
  // return DaapJogoDoBicho.contracts.Bicho.methods.addBichoToJogo().call();
}

async function createNewJogo() {
  try {
    document.getElementsByClassName("page-one")[0].style = "display:none";
    document.getElementsByClassName("page-loading")[0].style = "display:block";
    var resultado = await DaapJogoDoBicho.contracts.Bicho.methods.createNewJogo("simples", "17/12/1999").send({ from: DaapJogoDoBicho.account });
    document.getElementsByClassName("page-loading")[0].style = "display:none";
    document.getElementsByClassName("page-two")[0].style = "display:block";
    return resultado;
  } catch (error) {
    console.log(error.code);
    if (error.code == 4001) {
      document.getElementsByClassName("page-loading")[0].style = "display:none";
      document.getElementsByClassName("page-one")[0].style = "display:block";
    }
  }
}

function delBichoFromJogo() {
  return DaapJogoDoBicho.contracts.Bicho.methods.delBichoFromJogo().call();
}

function finishJogo() {
  return DaapJogoDoBicho.contracts.Bicho.methods.finishJogo().call();
}

function toBicho() {
  return DaapJogoDoBicho.contracts.Bicho.methods.toBicho().call();
}

function calcularTotalJogo() {
  
  return DaapJogoDoBicho.contracts.Bicho.methods.calcularTotalJogo().call();
}

function returnJogo() {
  return DaapJogoDoBicho.contracts.Bicho.methods.returnJogo().call();
}

async function returnAllJogos() {
  var resultado = await DaapJogoDoBicho.contracts.Bicho.methods.returnAllJogos().send({ from: DaapJogoDoBicho.account });
  console.log(resultado);
  return resultado;
}