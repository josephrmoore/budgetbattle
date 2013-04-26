class Reduction {
  String name;
  int cost;
  boolean alive, played, flying;
  int x, y, x_last, y_last;
  float rotation, x_rate, y_rate;
  Reduction(String name, int cost) {

    this.name = name;
    this.cost = cost;
    this.alive = true;
    this.played = false;
    this.flying = false;
  }

  void render() {
    if (this.alive) {
      fill(255);
      pushMatrix();
      translate(width/2, height/2);
      rotate(this.rotation);
      rect(this.x, this.y, 400, 250);
      popMatrix();
      if (this.x < this.x_last || this.y < this.y_last) {
        this.flyIn();
        this.flying = true;
      } 
      else {
        this.flying = false;
      }
      //    println("x: " + this.x + " y: " + this.y + " x_last: " + this.x_last + " y_last: " + this.y_last + " x_rate: " + this.x_rate + " y_rate: " + this.y_rate);
      //    println(this.name);
    }
  }

  void flyIn() {
    this.x += this.x_rate;
    this.y += this.y_rate;
  }

  void slashed() {
    // slashing animation
    this.alive = false;
    if (!this.played) {
      this.playMessage();
      this.played = true;
    }
  }

  void playMessage() {
    // flash name and cost of program on the screen then fade
  }
}

