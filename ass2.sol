// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract RPSContract {
    address public owner;

    enum Move { None, Rock, Paper, Scissors }

    struct GameHistory {
        address player;
        Move playerMove;
        Move computerMove;
        address winner;
        bool computerWin; 
        bool playerWin; 
    }

    GameHistory public currentGame;
    GameHistory[] public gameHistory;

    mapping(string => Move) private moveMapping; // Маппинг для слов-выборов
    mapping(Move => string) private reverseMoveMapping; // Обратный маппинг для отображения слов

    event NewGame(address indexed player, uint8 playerMove);
    event GameResult(address indexed player, uint8 playerMove, uint8 computerMove, address winner);

    constructor() payable {
        owner = msg.sender;
        // Инициализация маппинга
        moveMapping["rock"] = Move.Rock;
        moveMapping["paper"] = Move.Paper;
        moveMapping["scissors"] = Move.Scissors;
        
        // Инициализация обратного маппинга
        reverseMoveMapping[Move.Rock] = "rock";
        reverseMoveMapping[Move.Paper] = "paper";
        reverseMoveMapping[Move.Scissors] = "scissors";
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.number))) % 3 + 1;
    }

    function computerPlay() private view returns (Move) {
        return Move(random());
    }

    function play(string memory _playerMove) public payable {
        Move playerMove = moveMapping[_playerMove]; 

        require(playerMove != Move.None, "Invalid player move"); 

        Move computerMove = computerPlay();

        bool computerWin = false;
        bool playerWin = false;

        if (playerMove == computerMove) {
            currentGame.winner = address(0); 
        } else if (
            (playerMove == Move.Rock && computerMove == Move.Scissors) ||
            (playerMove == Move.Paper && computerMove == Move.Rock) ||
            (playerMove == Move.Scissors && computerMove == Move.Paper)
        ) {
            currentGame.winner = msg.sender; 
            playerWin = true;
        } else {
            currentGame.winner = address(this); 
            computerWin = true;
        }

        currentGame = GameHistory({
            player: msg.sender,
            playerMove: playerMove,
            computerMove: computerMove,
            winner: currentGame.winner,
            computerWin: computerWin,
            playerWin: playerWin
        });

        gameHistory.push(currentGame); 

        emit GameResult(msg.sender, uint8(playerMove), uint8(computerMove), currentGame.winner);
        emit NewGame(msg.sender, uint8(playerMove));
    }


}
