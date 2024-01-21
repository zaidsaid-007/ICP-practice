// Define the Auction actor, which represents a simple auction system
actor Auction {
  // Map of bids for each item
  var bids : HashMap<Text, Nat> = HashMap<Text, Nat>();

  // Start a new auction for an item
  public shared async function startAuction(item : Text) {
    // Initialize the bid for the item to 0
    bids[item] := 0;
  };

  // Place a bid for an item
  public shared async function placeBid(item : Text, amount : Nat) : async Bool {
    // Check if the bid is higher than the current highest bid
    let currentBid = switch (bids.get(item)) {
      | null => 0
      | some(bid) => bid
    };

    if (amount <= currentBid) {
      return false; // Bid is too low, place bid failed
    }

    // Update the bid for the item
    bids[item] := amount;

    // Bid placed successfully
    return true;
  };

  // Get the current highest bid for an item
  public query async function getHighestBid(item : Text) : async Nat {
    // Retrieve the current highest bid for the item from the 'bids' map
    switch (bids.get(item)) {
      | null => 0 // Return 0 if there are no bids for the item
      | some(bid) => bid // Return the current highest bid for the item
    };
  };
};
