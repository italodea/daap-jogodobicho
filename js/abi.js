var abi = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "listOwner",
				"type": "address"
			}
		],
		"name": "JogosUpdated",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "old",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "newAddress",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "numero",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "valor",
				"type": "uint256"
			}
		],
		"name": "addBichoToJogo",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "numero",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "valor",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "apostador",
						"type": "address"
					},
					{
						"internalType": "bool",
						"name": "isValida",
						"type": "bool"
					}
				],
				"internalType": "struct JogoDoBicho.Bicho",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "buy",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "tipoDeJogo",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "jogoDate",
				"type": "string"
			}
		],
		"name": "createNewJogo",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "delBichoFromJogo",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "destroy",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "finishJogo",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "returnAllJogos",
		"outputs": [
			{
				"components": [
					{
						"internalType": "address",
						"name": "ownerAddress",
						"type": "address"
					},
					{
						"components": [
							{
								"internalType": "uint256",
								"name": "id",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "numero",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "valor",
								"type": "uint256"
							},
							{
								"internalType": "address",
								"name": "apostador",
								"type": "address"
							},
							{
								"internalType": "bool",
								"name": "isValida",
								"type": "bool"
							}
						],
						"internalType": "struct JogoDoBicho.Bicho[]",
						"name": "bichos",
						"type": "tuple[]"
					},
					{
						"internalType": "string",
						"name": "jogoDate",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "tipoDeJogo",
						"type": "string"
					}
				],
				"internalType": "struct JogoDoBicho.Jogo[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "addr",
				"type": "address"
			}
		],
		"name": "returnJogo",
		"outputs": [
			{
				"components": [
					{
						"internalType": "address",
						"name": "ownerAddress",
						"type": "address"
					},
					{
						"components": [
							{
								"internalType": "uint256",
								"name": "id",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "numero",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "valor",
								"type": "uint256"
							},
							{
								"internalType": "address",
								"name": "apostador",
								"type": "address"
							},
							{
								"internalType": "bool",
								"name": "isValida",
								"type": "bool"
							}
						],
						"internalType": "struct JogoDoBicho.Bicho[]",
						"name": "bichos",
						"type": "tuple[]"
					},
					{
						"internalType": "string",
						"name": "jogoDate",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "tipoDeJogo",
						"type": "string"
					}
				],
				"internalType": "struct JogoDoBicho.Jogo",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "tokenPrice",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address payable",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]