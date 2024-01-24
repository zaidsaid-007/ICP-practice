actor Auction {
  type Item = {
    id : Nat;
    name : Text;
    description : Text;
    currentBid : Nat;
  };

  var items : [Item] = [];

  public shared func addItem(name : Text, description : Text, initialBid : Nat) {
    items := items ++ [{ id = Array.length(items) + 1; name = name; description = description; currentBid = initialBid }];
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

actor VideoStorage {
  var videos : [Text] = [];

  public shared func uploadVideo(video : Text) {
    videos := videos ++ [video];
  };

  public shared func downloadVideo(videoId : Nat) : Text {
    if (videoId < 1 | videoId > Array.length(videos)) {
      Debug.print ("Invalid video id"); // Invalid video id
    }

    return videos[videoId - 1];
  };

  public shared func deleteVideo(videoId : Nat) {
    if (videoId < 1 | videoId > Array.length(videos)) {
      Debug.print ("Invalid video id"); // Invalid video id
    }

    videos := Array.update(videos, videoId - 1, { videos[videoId - 1] with video = "" });
  };
};

actor UserRegistration {
  var users : [Text] = [];

  public shared func registerUser(username : Text) {
    users := users ++ [username];
  };

  public shared func loginUser(username : Text) : Bool {
    if (Array.contains(users, username)) {
      return true;
    } else {
      return false;
    }
  };

  public shared func logoutUser(username : Text) {
    users := Array.update(users, Array.indexOf(users, username), { users[Array.indexOf(users, username)] with username = "" });
  };
};