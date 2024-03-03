//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

contract lottery{
    
    address public owner;
    constructor(){
      owner = msg.sender;
    }

    uint256 lotteryID;
    mapping (uint => address) history;
    address[] public players;

    function getPlayers() external view returns(address[] memory){
      return players;
    }

    bool isPaid = false;
 
    receive() external payable{
        require(msg.value == 0.01 ether, "You should send exactly 0.01 ether.");
        isPaid = true;
    }

    function enterLottery() external payable{
       require(isPaid,"you should pay for the attendance.");
       players.push(msg.sender);
    }

    function check_history(uint256 id) public view returns(address){
       return history[id];
    }

    function getRandomNumber() public view returns(uint256){
       uint256 randomNumber = uint256(keccak256(abi.encode(block.timestamp, block.number,players.length)));
       return randomNumber;
    }

    function pickWinner () onlyOwner public{

      require(players.length > 0, "There are no players");
      uint256 winner_id = getRandomNumber() % players.length;

      address winner = players[winner_id];
      history[winner_id] = winner;
      lotteryID++;

      uint256 price = address(this).balance - .01 ether;
      payable(winner).transfer(price);
      
      delete players;    
    }

    function withdraw() onlyOwner public{
        payable(owner).transfer(address(this).balance);
    }

    modifier onlyOwner(){
        require(owner == msg.sender, "you are not authorized.");
        _;
    }

}