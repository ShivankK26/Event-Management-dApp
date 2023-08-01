pragma solidity >=0.5.0 < 0.9.0;

// The value of struct data type, mapping value name & word after public and all the arrays in which we add value are inter-connected.

contract EventContract{ // This line refers that we're declaring our contract
    struct Event { // struct Event refers to an individual contract which we're creating and all the values which it includes reside in one particular event
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ricketRemain;
    }

    mapping(uint => Event) public events; // This mapping is used to create future events by directing that uint means individual event number and Event refers to a proper event, including all the properties inside that struct as well. It creates a hashing type of table which provides kinf od index number to each event so that we can call them for our future use
    mapping(address => mapping(uint=>uint)) public tickets; // This mapping is useful when any particular individual wants to buy tickets for multiple FUTURE events. It is called as a 2D mapping. For better understanding refer the image in "imgs" folder
    uint public nextId; // It creates a nextId for our future events so that they can easily increment


    // memory: This is a temporary and transient data location used for storing variables during the execution of a function. Variables declared with the memory keyword are allocated in the function's execution context and are discarded once the function completes its execution. It is commonly used when working with dynamically-sized arrays, strings, and struct types inside functions.
    function createEvent(string memory name, uint date, uint price, uint ticketCount) public { // This function is used to create an event
        require(date > block.timestamp, "You can organize the event for future data."); // Condition: the date of event should be greater than the timeperiod for mining a block.
        require(ticketCount > 0, "You can organize event only if you create more than 0 tickets."); // Condition: The ticketcount for any event should be > 0

        events[nextId] = Event(msg.sender, name, date, price, ticketCount, ticketCount); // This statement is used to create an array for all the future events. Here we've written ticketCount twice as ticketCount =  ticketRemain
        nextId++; // Used for creating further events
    }


    function buyTicket(uint id, uint quantity) public payable { // This function is used for buying tickets
        require(events[id].date!=0, "The event does not exist."); // Used to check if the event exists or not
        require(events[id].date > block.timestamp, "The event has occured."); // The date of event should be in future
        Event storage _event = events[id]; // Storing all the events in an array , permanantly.
        require(msg.value == (_event.price*quantity), "Not enough Ether."); // Price paid should be equal to the actual price of the ticket
        require(_event.ticketRemain > quantity, "Not enough tickets."); // Obvious statement
        _event.ticketRemain -= quantity; // decreasing the number of tickets after purchase
        tickets[msg.sender][id] += quantity; // sending the ticket to buyer
    }


    function transferTicket(uint id, uint quantity, address to) public { // This function is used to tranfer the ticket purchased to someone else
        require(events[id].date!=0, "The event does not exist."); // Explained above
        require(events[id].date > block.timestamp, "The event has occured."); // Explained above
        require(tickets[msg.sender][id] >= quantity, "You don't have enough tickets."); // Tickets finished
        tickets[msg.sender][id] -= quantity; // Sending the tickets from sender's account
        tickets[to][id] += quantity; // Sending the tickets to receiver's account
    }
}
