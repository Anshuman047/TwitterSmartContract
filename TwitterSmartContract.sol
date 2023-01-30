// SPDX-License-Identifier:MIT
pragma solidity >=0.5.0<0.9.0;

contract TweetContract{

    struct Tweet{//Important infos about the tweet
        uint id;//its ID
        address author;
        string content;
        uint createdAt;//time at which it was created
    }

    struct Message{
        uint id;
        string content;
        address from;
        address to;
        uint creatAt;
    }
    //1
    mapping(uint=>Tweet) public tweets;//Structure mapped with uint//for storing tweet
    //2
    mapping(address=>uint[]) public tweetsOf;//Array mappped with address// storing our ids
    //3
    mapping(address=>Message[]) public conversations;//Structure array mapped with uint//stores msgs 
    //4
    mapping(address=>mapping(address=>bool)) public operators;//for giving access to operate our id
    //5
    mapping(address=>address[]) public following;//stores following ids

    //variables used as count
    uint nextId;//0
    uint nextMessageId;//0
    
    function _tweet(address _from,string memory _content) internal{
        require(_from==msg.sender /*means caller is seeing its id's function  */ || operators[_from][msg.sender]==true,"Wrong identity");//means allowed caller is seeing owners id's//msg.sender saves caller address
        tweets[nextId]=Tweet(nextId,_from,_content,block.timestamp);//here there would be mapping of mapping1
        tweetsOf[_from].push(nextId);////here there would be mapping of mapping2//it pushed all nextIds of respective address
        ++nextId;//nextId=0 for first tweet,+1 for second tweet and soon//counts no of tweets till now
    }

    function _sendMessage(address _from,address _to,string memory _content) internal{//here there would be mapping of mapping3
        conversations[_from].push(Message(nextMessageId,_content,_from,_to,block.timestamp));
        nextMessageId++;//nextIdMessage=0 for first msgf,+1 for second tweet and soon
    }

    function Itweet(string memory _content)public{
        _tweet(msg.sender,_content);//If I tweets
    }

    function Elsetweet(address _from,string memory _content)public{
        _tweet(_from,_content);//if else tweet from my Id
    }

    function IsendMessage(address _to,string memory _content)public{
        _sendMessage(msg.sender,_to,_content);//If I send msg
    }

    function ElsesendMessage(address _from,address _to,string memory _content)public{
        _sendMessage(_from,_to,_content);//If else send msg
    }

    function follow(address _followed)public{
        following[msg.sender].push(_followed);//mapping5 //stores following ids
    }

    function allow(address _operator)public{
        operators[msg.sender][_operator]=true;//mapping4//we are allowing operator to operate our id//for exapmle: as our id comes in address _from in tweet-function and allow_function give access to _opertaor to get access of the tweet-function
    }

    function disallow(address _operator)public{
        operators[msg.sender][_operator]=false;//mapping4//we are disallowing operator to operate our id
    }

    function GetlatestTweets(uint count) public view returns(Tweet[] memory) {
        require(count>0 && count<=nextId,"Count is not proper");
        Tweet[]memory _tweets = new Tweet[](count);//Tweet type empty array which is of length of count// length part is done by "new" keyowrd

    uint j;

    for(uint i=nextId-count;i<nextId;i++){//from this we would get latest tweets as much tweets as count is

        Tweet storage _structure = tweets[i];//structure variable points tweets[i] as it return Tweet        strucutre, which extracted with help of mapping1 where i represents the uint id

//Now here we are extracting all the lastest form tweets mapping and importing them into Tweet type array taht is _tweets

//method:1
    // tweets[j]=Tweet(tweets[i].id,tweets[i].author,tweets[i].content,tweets[i].createdAt);

//method :2
        _tweets[j]=Tweet(_structure.id,_structure.author,_structure.content,_structure.createdAt);

        j++;
    }
    //now we are returning the array
    //all this much is done because mapping values cant be return from function

    return _tweets;  
    }
 
       
    function getLatestofUser(address _user,uint count) public view returns(Tweet[] memory){//count defines how many to watch
    //In this this function we used above function codes to extract the tweets and added codes to extract count number of latest tweets of passed address
    require(count>0 && count<=tweetsOf[_user].length,"Count is not defined");
    Tweet[]memory _tweets = new Tweet[](count);//new memory array whose length is count ,where the mapped value is placed and returns from function

    tweetsOf[_user];//this stores all the nextIds of the respective user address
   uint[] memory ids= tweetsOf[_user];

    uint j;

    for(uint i=tweetsOf[_user].length-count;i<tweetsOf[_user].length;i++){//from this we would get latest tweets as much tweets as count is
        _tweets[j]=Tweet(tweets[ids[i]].id,tweets[ids[i]].author,tweets[ids[i]].content,tweets[ids[i]].createdAt);//here in tweets we passesd the nextIds from tweetsOf and import the Tweet strucutre in _tweets array in each iteration
        j++;
    }  
    return _tweets;  
    }





}


