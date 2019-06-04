pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EventTickets.sol";
import "../contracts/EventTicketsV2.sol";

// Proxy contract for testing throws
contract ThrowProxy {
  address public target;
  bytes data;

  constructor(address _target) internal {
    target = _target;
  }

  //prime the data using the fallback function.
  function() external {
    data = msg.data;
  }

  function execute() external returns (bool) {
    (bool r, ) = target.call(data);
	return r;
  }
}

contract TestEventTicket {

	uint public initialBalance = 1 ether;

	string description = "description";
	string url = "URL";
	uint ticketNumber = 100;
	EventTickets myEvent = new EventTickets(description, url, ticketNumber);
	uint ticketPrice = 100 wei;

	function testSelf() public {
		Assert.equal(address(this).balance, 1 ether, 'not enough balance to test');
	}

	function testSetup()
		public
	{
		Assert.equal(myEvent.owner(), address(this), 'the deploying address should be the owner');
		(, , , , bool isOpen) = myEvent.readEvent();
		Assert.equal(isOpen, true, 'the event should be open');
	}
	function testFunctions() public {
		(string memory eventDescription, string memory website, uint totalTickets, uint sales, ) = myEvent.readEvent();
		Assert.equal(eventDescription, description, "the event descriptions should match");
		Assert.equal(website, url, "the event urls should match");
		Assert.equal(totalTickets, ticketNumber, "the number of tickets for sale should be set");
		Assert.equal(sales, 0, "the ticket sales should be 0");
	}

	function testBuyTickets() public payable {
		myEvent.buyTickets.value(ticketPrice)(1);
		(, , , uint sales, ) = myEvent.readEvent();
		Assert.equal(sales, 1, 'the ticket sales should be 1');
	}

  function() external payable {
  }

}
