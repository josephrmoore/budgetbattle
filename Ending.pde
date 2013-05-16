class Ending {
  int cut_l, cut_r, not_l, not_r, passed;
  boolean player;
  Player p;
  boolean reelected; // true or false
  String party; // "left" or "right"
  String degree; // "good", "mediocre", or "bad"
  int slide;
  // Examples:
  // Ending e = new Ending(true, "left", "mediocre", endings[2]);
  // Ending e = new Ending(false, "right", "good", endings[3]);  

  Ending(int cut_l, int cut_r, int not_l, int not_r, int passed, boolean player, Player p) {
    this.cut_l = cut_l;
    this.cut_r = cut_r;
    this.not_l = not_l;
    this.not_r = not_r;
    this.passed = passed;
    this.player = player;
    this.p = p;

    if (p.player == 0) {
      // voting player
      this.party = "left";
      if (p.number == 0) {
        this.degree = "bad";
      } 
      else {
        if ((p.righteousness/p.number)<.34) {
          this.degree = "bad";
        } 
        else if ((p.righteousness/p.number)>=.34 && (p.righteousness/p.number)<=.66) {
          this.degree = "mediocre";
        } 
        else if ((p.righteousness/p.number)>.66) {
          this.degree = "good";
        } 
        else {
          // error
          this.degree = "error";
        }
      }
      if (passed > 0) {
        // re-elected
        this.reelected = true;
      } 
      else {
        // not re-elected
        this.reelected = false;
      }
    } 
    else {
      // cutting player
      this.party = "right";

      if (this.player == true) {
        // re-elected
        this.reelected = true;
      } 
      else {
        // not re-elected
        this.reelected = false;
      }

      if (cut_r == 0) {
        this.degree = "good";
      } 
      else if (cut_r > 0 && cut_r < 3) {
        this.degree = "mediocre";
      } 
      else {
        this.degree = "bad";
        this.reelected = false;
      }
    }

    if (this.party == "left") {
      if (this.reelected == true) {
        if (this.degree == "good") {
          this.slide = 0;
        } 
        else if (this.degree == "mediocre") {
          this.slide = 1;
        } 
        else if (this.degree == "bad") {
          this.slide = 2;
        } 
        else {
          println("error: level-degree");
        }
      } 
      else if (this.reelected == false) {
        if (this.degree == "good") {
          this.slide = 3;
        } 
        else if (this.degree == "mediocre") {
          this.slide = 4;
        } 
        else if (this.degree == "bad") {
          this.slide = 5;
        } 
        else {
          println("error: level-degree");
        }
      } 
      else {
        println("error: level-elected");
      }
    } 
    else if (this.party == "right") {
      if (this.reelected == true) {
        if (this.degree == "good") {
          this.slide = 6;
        } 
        else if (this.degree == "mediocre") {
          this.slide = 7;
        } 
        else if (this.degree == "bad") {
          this.slide = 8;
        } 
        else {
          println("error: level-degree");
        }
      } 
      else if (this.reelected == false) {
        if (this.degree == "good") {
          this.slide = 9;
        } 
        else if (this.degree == "mediocre") {
          this.slide = 10;
        } 
        else if (this.degree == "bad") {
          this.slide = 11;
        } 
        else {
          println("error: level-degree");
        }
      } 
      else {
        println("error: level-elected");
      }
    } 
    else {
      println("error: level-party");
    }
  }
  void draw() {
    JSON e = endings.getObject(this.slide);
    image(backgrounds[e.getInt("img")], 0, 0);
    fill(255);
    textFont(bigcaslon, 60);
    textAlign(LEFT);
    if (this.party == "left") {
    fill(#051fe0);
    text("DEMOCRAT", 50, 80);
    } else {
    fill(#e00505);
    text("REPUBLICAN", 50, 80);
    }
    fill(#cccccc);
    textFont(bigcaslon, 45);
    if (this.reelected) {
      text("You were re-eected.", 50, 130);
    } 
    else {
      text("You were not re-elected", 50, 130);
    }
    fill(255);
    textFont(bigcaslon, 30);
    textAlign(CENTER);
    ArrayList strings = wordWrap(e.getString("content"), 450);
    for (int i=0; i<strings.size(); i++) {
      text((String)strings.get(i), 550, 300+(i*40));
    }
  }
}

