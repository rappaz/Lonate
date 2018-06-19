pragma solidity ^0.4.16;

contract Ballot {

    struct Voter {
        uint weight; 
        bool voted;  
        uint vote;   
    }

    struct ProposalProjects {
        bytes32 name;   
        uint voteCount; 
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    ProposalProjects[] public proposals;

    function Ballot(bytes32[] proposalNames) public {
        
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        
        for (uint i = 0; i < proposalNames.length; i++) {
        
            proposals.push(ProposalProjects({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function giveRightToVote(address voter) public {

        require(
            (msg.sender == chairperson) &&
            !voters[voter].voted &&
            (voters[voter].weight == 0)
        );
        voters[voter].weight = 1;
    }


    function vote(uint proposal) public {

        Voter storage sender = voters[msg.sender];
        require(!sender.voted);
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
    }


    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }


    function winnerName() public view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}