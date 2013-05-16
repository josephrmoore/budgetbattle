class Actionable {
  float DEG = .174532925;
  float BOUND_MIN = .05;
  float BOUND_MAX = .20;
  String type; // "bill" or "favor"
  JSON json;
  String affiliation; // "left", "right", or "player"
  String name; // "Council for the Arts" or "Pork for Ohio", etc.
  int cost; // ex. 100000 
  float righteousness; // between 0 and 1
  boolean active, flying, alive;
  int x, y, x_last, y_last;
  float rotation, x_rate, y_rate;
  color f;
  PImage party;
  // Examples:
  // Actionable a = new Actionable("bill", "left", "Council for the Arts", 230000, 1);
  // Actionable a = new Actionable("favor", "left", "Pork for Ohio", 230000, .2);  

  Actionable(String type, JSON json) {
    this.type = type;
    this.json = json;
    this.active = true;
    this.flying = true;
    this.alive = true;
    this.x = -width;
    this.y = -height;
    this.x_last = (int)random((int)(width*BOUND_MIN), (int)(width*BOUND_MAX));
    this.y_last = (int)random((int)(height*BOUND_MIN), (int)(height*BOUND_MAX));
    this.rotation = random(-DEG, DEG);
    this.x_rate = (this.x_last - this.x)/30;
    this.y_rate = (this.y_last - this.y)/30;

    if (this.type == "bill") {
      this.name = json.getString("name");
      this.affiliation = json.getString("affiliation");
      this.cost = json.getInt("cost");
    } 
    else if (this.type == "favor") {
      this.name = json.getString("name");
      this.affiliation = (String)json.getString("affiliation");
      this.cost = json.getInt("cost");
      this.righteousness = json.getFloat("righteousness");
    }
    if(this.affiliation.equals("left")){
      this.f = color(159,180,245);
      this.party = loadImage("d.png");
    } else if (this.affiliation.equals("right")){
      this.f = color(245,159,159);
      this.party = loadImage("r.png");
    } else if (this.affiliation.equals("player")){
      this.f = color(255,230,90);
      this.party = loadImage("p.png");
    }
  }

  void render() {
    if (this.type == "bill") {
      fill(this.f);
      pushMatrix();
      translate(width/2, height/2);
      rotate(this.rotation);
      strokeWeight(1);
      stroke(0);
      rect(this.x, this.y, 400, 250);
      fill(0);
      textFont(atlantic, 14);
      text(this.name, this.x, this.y+0, 300, 100);
      if(this.alive == false){
        strokeWeight(10);
        stroke(#610d0d);
        line(this.x-220, this.y-145, this.x+220, this.y+145);
      }
      popMatrix();
      if (this.x < this.x_last || this.y < this.y_last) {
        this.flyIn();
        this.flying = true;
      } 
      else {
        this.flying = false;
      }
    }
    if (this.type == "favor") {
      pushMatrix();
      translate(width/20, height/2);
      rotate(this.rotation);
      image(backgrounds[10], this.x-60, this.y+10);
      fill(0);
      image(this.party, this.x-30, this.y+17);
      textFont(atlantic, 14);
      text("Favor".toUpperCase(), this.x+50, this.y+50, 164, 40);
      textFont(bigcaslon, 14);
      text(this.name.toUpperCase(), this.x+40, this.y+150, 164, 164);
      fill(255);
      if(this.alive == false){
        strokeWeight(10);
        stroke(#18a135);
        line(this.x+100, this.y+100, this.x+200, this.y-10);
        line(this.x+80, this.y+50, this.x+100, this.y+100);
      }
      popMatrix();
      if (this.x < this.x_last || this.y < this.y_last) {
        this.flyIn();
        this.flying = true;
      } 
      else {
        this.flying = false;
      }
    }
  }

  void flyIn() {
    this.x += this.x_rate;
    this.y += this.y_rate;
  }
  
  void acted() {
    if(this.alive){
      this.alive = false;
      if(this.type == "bill"){
        bills_cut.add(this);
        if(this.affiliation.equals("player")){
          player_cut = true;
        }
      } else {
        favors_passed.add(this);
      }
    }
  }
  
}

