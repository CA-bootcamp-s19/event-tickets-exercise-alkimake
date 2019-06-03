pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EventTickets.sol";
import "../contracts/EventTicketsV2.sol";

contract TestEventTicket {

	string description = "description";
	string url = "URL";
	uint ticketNumber = 100;
	EventTickets myEvent;

	function beforeEach() public {
		myEvent = new EventTickets(description, url, ticketNumber);
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

}
