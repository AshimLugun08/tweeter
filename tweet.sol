// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;


contract TweetContract{
 struct Tweet{
    uint id;
    address author;
    string content;
    uint createdAt;
 }

 struct Message{
    uint id;
    address from;
    address to;
    string content;
    uint createdAt;
 }

 mapping(uint=>Tweet) public tweets;
 mapping(address=> uint[]) public tweetsOf;
 mapping(address=>Message[]) public conversation;
 mapping(address=>mapping(address=>bool)) public operators;
 mapping(address=>address[]) public following;

 uint nextId;
 uint nextMessageId;


 function _tweet(address _from,string memory _content)  internal {
    require (_from == msg.sender || operators[_from][msg.sender],"you don't have access");
    tweets[nextId]=Tweet(nextId,_from,_content,block.timestamp);
    tweetsOf[_from].push(nextId);
    nextId++;
 }

function _sendMessage(address _from ,address _to, string memory _content) internal {
 require (_from == msg.sender || operators[_from][msg.sender],"you don't have access");
conversation[_from].push(Message(nextId,_from,_to,_content,block.timestamp));
nextMessageId++;
}

function tweet(string memory _content) public {
    _tweet(msg.sender,_content);
}

function tweet(string memory _content,address _from) public {
    _tweet(_from,_content);
}

function sendMessage(string memory _content,address _to) public{
    _sendMessage(msg.sender, _to, _content);
}

function sendMessage(address _from,string memory _content,address _to) public{
    _sendMessage(_from, _to, _content);
}

function follow(address _to) public{
    following[msg.sender].push(_to);
}

function allow(address _to ) public {
    operators[msg.sender][_to]=true;
}

function disallow(address _to ) public {
    operators[msg.sender][_to]=false;
}

function getLatestTweets(uint count) public view returns (Tweet[] memory)
{ require(count > 0 && count <= nextId, "Count is not proper");
       Tweet[] memory _tweets= new Tweet[](count);
      uint j;

      for (uint i=nextId-count;i<nextId;i++){
Tweet storage _stucture=tweets[i];
_tweets[j]=Tweet(_stucture.id,_stucture.author,_stucture.content,_stucture.createdAt);
j++;
      }

}
}