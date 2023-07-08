// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;
error Date_Error(string errmsg);
error Funding_Unsuccessful();

contract CrowdFund {
    //events
    event Funding_Successfull(address indexed funder, uint256 indexed amount);
    struct Campaign {
        address owner;
        string title;
        string tag;
        string description;
        uint256 target;
        uint256 lastDate;
        uint256 currentAmount;
        string image;
        address[] funders;
        uint256[] funds;
    }

    mapping(uint256 => Campaign) public s_campaigns;

    uint256 s_no_of_campaigns = 0;

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _tag,
        string memory _description,
        uint256 _target,
        uint256 _lastDate,
        string memory _image
    ) public returns (uint256) {
        if (_lastDate < block.timestamp) {
            revert Date_Error("Last Date Should Be In the Future");
        }
        Campaign storage campaign = s_campaigns[s_no_of_campaigns];
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.tag = _tag;
        campaign.description = _description;
        campaign.target = _target;
        campaign.lastDate = _lastDate;
        campaign.image = _image;
        campaign.currentAmount = 0;

        s_no_of_campaigns += 1;
        return s_no_of_campaigns - 1;
    }

    function fundCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;
        Campaign storage campaign = s_campaigns[_id];

        campaign.funders.push(msg.sender);
        campaign.funds.push(amount);

        (bool success, ) = payable(campaign.owner).call{value: amount}("");
        if (success) {
            campaign.currentAmount += amount;
            emit Funding_Successfull(msg.sender, amount);
        } else {
            revert Funding_Unsuccessful();
        }
    }

    function getFunders(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        return (s_campaigns[_id].funders, s_campaigns[_id].funds);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](s_no_of_campaigns);
        for (uint i = 0; i < s_no_of_campaigns; i++) {
            Campaign storage item = s_campaigns[i];
            allCampaigns[i] = item;
        }

        return allCampaigns;
    }
}
