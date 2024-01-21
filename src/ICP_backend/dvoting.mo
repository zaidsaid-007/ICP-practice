actor VotingSystem {
  type Vote = { candidate: Text; timestamp: Time };

  // Map to store votes for each candidate
  let votes : HashMap<Text, Nat> = HashMap<Text, Nat>();

  // Record a vote for a specific candidate
  public shared async func vote(candidate: Text) : async Bool {
    // Check if the candidate exists
    if (!votes.contains(candidate)) {
      votes.put(candidate, 0);
    }

    // Record the vote
    votes[candidate] += 1;

    // Vote recorded successfully
    return true;
  };

  // Get the total votes for a specific candidate
  public query async func getVotes(candidate: Text) : async Nat {
    return votes.get(candidate, 0);
  };

  // Get the list of candidates
  public query async func getCandidates() : async Iter<Text> {
    return Iter.fromArray(votes.keys());
  };
}