class Player {
  boolean type; // false/0 = player 1, true/1 = player 2
  int value; // total money cut or spent
  String name; // Input from the player

// Examples:
// Player p = new Player(0);
// Player p = new Player(1);  

  Player(boolean type) {
    this.type = type;
  }

  void action(){
    if(this.type == 0){
      // cut
    } else if(this.type == 1){
      // vote
    }
  }

