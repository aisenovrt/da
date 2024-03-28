
let web3;

if (typeof window.ethereum !== 'undefined') {
    web3 = new Web3(window.ethereum);
} else {
    alert("Web3 provider not found. Please install MetaMask or use a compatible browser.");
}


const contractAddress = '0x99d24e519b75E403Fd816575624C503B0A9e78d9'; // Замените на адрес вашего контракта
const contractABI = [
    {
        "constant": false,
        "inputs": [
            {
                "name": "_playerMove",
                "type": "string"
            }
        ],
        "name": "play",
        "outputs": [],
        "payable": true,
        "stateMutability": "payable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "getGameHistory",
        "outputs": [
            {
                "name": "player",
                "type": "address"
            },
            {
                "name": "playerMove",
                "type": "uint8"
            },
            {
                "name": "computerMove",
                "type": "uint8"
            },
            {
                "name": "winner",
                "type": "address"
            },
            {
                "name": "computerWin",
                "type": "bool"
            },
            {
                "name": "playerWin",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    }
    
];


const contract = new web3.eth.Contract(contractABI, contractAddress);

// Функция для отправки выбранного хода на смарт-контракт
async function playMove() {
    const selectedMove = document.getElementById("move").value;
    const accounts = await web3.eth.getAccounts();

    try {
        await contract.methods.play(selectedMove).send({
            from: accounts[0],
            gas: 200000
        });

        console.log(`Player submitted move: ${selectedMove}`);
        // Обновите интерфейс с результатом игры
    } catch (error) {
        console.error(error);
    }
}


async function showGameHistory() {
    try {
        const history = await contract.methods.getGameHistory().call();
        // Обновите интерфейс с историей игр
    } catch (error) {
        console.error(error);
    }
}

// Вызов функции для отображения истории игр при загрузке страницы
showGameHistory();
