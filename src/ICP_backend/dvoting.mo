actor VotingSystem {
  type Vote = { candidate: Text; timestamp: Time

  // Map to store votes for each candidate
  var votes : HashMap<Text, Nat> = HashMap<Text, Nat>();

  // Record a vote for a specific candidate
  public shared func vote(candidate: Text) : async Bool {
    // Check if the candidate exists
    if (!votes.contains(candidate)) {
      votes.put(candidate, 0);
    }

    // Record the vote
    votes[candidate] = votes[candidate] + 1;

    // Vote recorded successfully
    return true;
  };

  // Get the total votes for a specific candidate
  public query func getVotes(candidate: Text) : async Nat {
    return votes.get(candidate, 0);
  };

  // Get the list of candidates
  public query func getCandidates() : async Iter<Text> {
    Iter.fromArray(votes.keys());
  };
}