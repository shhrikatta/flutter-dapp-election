//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.5.0 <0.9.0;

contract Election {
    struct Candidate {
        string name;
        uint numVotes;
    }

    struct Voter {
        string name;
        bool isAuthorised;
        uint whom;
        bool isVoted;
    }

    address public owner;
    string public electionName;

    mapping(address=>Voter) public voters;
    Candidate[] public candidates;

    uint public totalVotes;

    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }

    // start the election and init the admin and name of the election
    function startElection(string memory _electionName) public {
        owner = msg.sender;
        electionName = _electionName;
    }

    // only owner can add a candidate
    function addCandidate(string memory _candidateName) public ownerOnly {
        candidates.push(
            Candidate(
                _candidateName,
                0
            )
        );
    }

    function authoriseVoter(address _voterAddress) public ownerOnly {
        voters[_voterAddress].isAuthorised = true;
    }

    function getNumCandidates() public view returns(uint) {
        return candidates.length;
    }

    function getTotalVotes() public view returns(uint) {
        return totalVotes;
    }

    function getCandidateInfo(uint index) public view returns (Candidate memory) {
        return candidates[index];
    }

    function vote(uint _candidateIndex) public {
        require(!voters[msg.sender].isVoted);
        require(voters[msg.sender].isAuthorised);
        voters[msg.sender].whom = _candidateIndex;
        voters[msg.sender].isVoted = true;
        candidates[_candidateIndex].numVotes++;
        totalVotes++;
    }
}