class Player {
  int player; // false/0 = player 1, true/1 = player 2
  int value; // total money cut or spent
  String name; // Input from the player

// Examples:
// Player p = new Player(0);
// Player p = new Player(1);  

  Player(int player) {
    this.player = player;
  }

  void act(){
    if(this.player == 0){
      // vote
      current_favor.acted();
    } else if(this.player == 1){
      // cut
      current_bill.acted();
    }
  }
}
