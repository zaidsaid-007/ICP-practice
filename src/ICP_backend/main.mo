actor Auction {
  type Item = {
    id : Nat;
    name : Text;
    description : Text;
    currentBid : Nat;
  };

  var items : [Item] = [];

  // public shared func addItem(name :Text, description: Text , initialBid : Nat) {
  //   items := items ++ [{id =Array.length(items) + 1  name = name }]
  // }


  public shared func addItem(name : Text, description : Text, initialBid : Nat) {
    items := items ++ [{ id = Array.length(items) + 1  name := name description := description currentBid := initialBid }];
  };

  public shared func placeBid(itemId : Nat, amount : Nat) : Bool {
    if (itemId < 1 | itemId > Array.length(items)) {
      Debug.print ("Invalid item id"); // Invalid item id
    }

    let item = items[itemId - 1];
    if (amount <= item.currentBid) {
      Debug.print("Bid is too low"); // Bid is too low
    }

    items := Array.update(items, itemId - 1, { item with currentBid = amount });
    return true;
  };

  public query func getItems() : [Item] {
    items;
  };
};