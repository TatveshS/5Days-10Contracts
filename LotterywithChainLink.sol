// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Lottery is VRFConsumerBase{
    address public owner;
    address payable[] public players;
    uint public LotteryId;

    mapping(uint => address payable) public LotteryHistory;

    bytes32 internal keyHash;
    uint256 internal fee;
    
    uint256 public randomResult;


    constructor() 
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK Token
        )
    {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18; // 0.1 LINK (Varies by network)

        owner = msg.sender;
        LotteryId =1;
    }
   

    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }


    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
        payWinner();
    }

    function getWinnerbyLottery(uint _LotteryId) public view returns(address payable){
        return LotteryHistory[_LotteryId];
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function getPlayers() public view returns(address payable[] memory){
        return players;
    }

    function enter() public payable{
        require(msg.value > 0.01 ether);
        players.push(payable(msg.sender));
         
    }

    

    function payWinner() public {
        uint index = randomResult % players.length;
        players[index].transfer(address(this).balance);

        LotteryHistory[LotteryId] =players[index];
        LotteryId++;

        //reset
        players = new address payable[](0);

    }

    function pickWinner() public onlyOwner{
        getRandomNumber();
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
}
