// Define a simple token wallet smart contract

import Token "mo:stablecoin";

actor TokenWallet {
  // Map of user accounts to their token balances
  var balances : HashMap<Principal, Nat> = HashMap<Principal, Nat>();

  // Initialize the token wallet with an initial balance
  public shared() {
    // For example, give the creator of the wallet an initial balance of 100 tokens
    balances.put(msg.caller, 100);
  };

  // Check the balance of the caller
  public query func getBalance() : async Nat {
    switch (balances.get(msg.caller)) {
      | null => 0 // Return 0 if the caller has no balance
      | some(balance) => balance
    };
  };

  // Transfer tokens to another user
  public shared func transfer(to : Principal, amount : Nat) : async Bool {
    // Check if the sender has enough tokens
    let senderBalance = switch (balances.get(msg.caller)) {
      | null => 0
      | some(balance) => balance
    };
    
    if (senderBalance < amount) {
      return false; // Insufficient balance
    }

    // Update sender and recipient balances
    balances[msg.caller] := senderBalance - amount;

    let recipientBalance = switch (balances.get(to)) {
      | null => 0
      | some(balance) => balance
    };

    balances[to] := recipientBalance + amount;

    // Transfer successful
    return true;
  };
};
