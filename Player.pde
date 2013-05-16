class Player {
  int player; // false/0 = player 1, true/1 = player 2
  int score; // total money cut or spent
  String name; // Input from the player
  int number;
  int righteousness;
// Examples:
// Player p = new Player(0);
// Player p = new Player(1);  

  Player(int player) {
    this.player = player;
    this.score = 0;
    this.number = 0;
    this.righteousness = 0;
  }

  void act(){
    if(this.player == 0){
      // vote
      if(current_favor.alive){
        this.score += current_favor.cost;
        this.number += 1;
        this.righteousness += current_favor.righteousness;
        current_favor.acted();
        ding.play(0);
        ding.rewind();
      }
    } else if(this.player == 1){
      // cut
      if(current_bill.alive){
        this.score += current_bill.cost;
        this.number += 1;
        current_bill.acted();
        slash.play(20);
        slash.rewind();
      }
    }
  }
}
