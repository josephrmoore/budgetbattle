import controlP5.*;
import java.util.*;
import java.util.concurrent.*;
import org.json.*;
import processing.serial.*;
import ddf.minim.*;
Minim minim;
AudioPlayer intro, instructions, game, slash, ding;
AudioPlayer[] fxs = new AudioPlayer[6];
Player p1 = new Player(0);
Player p2 = new Player(1);
int state;
int bill_cycle, favor_cycle, calendar_cycle, bill_limit, favor_limit, calendar_limit;
int current_month, final_month;
int last_mybill, bills_passed;
int cut_left, cut_right, not_cut_left, not_cut_right;
PImage[] backgrounds = new PImage[11];
boolean p1ready, p2ready, mybill, player_cut, first_run;
PFont atlantic, gotham, bigcaslon;
Serial port;
Ending e1, e2;

ArrayList bills_left, favors_left, bills_cut, favors_passed, bills_presented;

JSON json, bills, favors, responses, endings, player_bill;
Actionable current_bill, current_favor;

// create actionables
// create players
// send actionables
// on interaction, do something
// keep a record of the interactions
// play responses according to actions
// choose ending based on the final state of the interactions

void setup() {
  state = 0;
  last_mybill = 0;
  bills_passed = 0;
  cut_left = 0;
  cut_right = 0;
  not_cut_left = 0;
  not_cut_right = 0;
  p1ready=false;
  p2ready=false;
  mybill = false;
  player_cut = false;
  first_run = false;
  backgrounds[0] = loadImage("bb_title.jpg");
  backgrounds[1] = loadImage("bb_instructions.jpg");
  backgrounds[2] = loadImage("bb_game.jpg");
  backgrounds[3] = loadImage("background.jpg");
  backgrounds[4] = loadImage("best_true.jpg");
  backgrounds[5] = loadImage("medium_true.jpg");
  backgrounds[6] = loadImage("worst_true.jpg");
  backgrounds[7] = loadImage("best_false.jpg");
  backgrounds[8] = loadImage("medium_false.jpg");
  backgrounds[9] = loadImage("worst_false.jpg");
  backgrounds[10] = loadImage("bb_postit.png");
  port = new Serial(this, Serial.list()[0], 9600);
  port.bufferUntil('\n');
  atlantic = loadFont("atlantic.vlw");
  gotham = loadFont("gotham.vlw");
  bigcaslon = loadFont("bigcaslon.vlw");
  size(800, 600);
  background(0);
  rectMode(CENTER);
  json = JSON.load(dataPath("budgetbattle.json"));
  //  println(json);
  favors = json.getArray("favors");
  endings = json.getArray("endings");
  responses = json.getArray("responses");
  bills = json.getArray("bills");
  player_bill = json.getObject("player_bill");
  bills_left = new ArrayList();
  favors_left = new ArrayList();
  bills_cut = new ArrayList();
  favors_passed = new ArrayList();
  bills_presented = new ArrayList();

  for (int i=0; i<bills.length(); i++) {
    bills_left.add(bills.getObject(i));
  }
  for (int i=0; i<favors.length(); i++) {
    favors_left.add(favors.getObject(i));
  }
  JSON this_bill = bills.getObject((int)random(bills.length()));
  JSON this_favor = favors.getObject((int)random(favors.length()));
  bill_cycle = 0;
  favor_cycle = 0;
  calendar_cycle = 0;
  bill_limit = 1500;
  favor_limit = 3000;
  calendar_limit = 1000;
  current_month = 1;
  final_month = 600;
  minim = new Minim(this);
  intro = minim.loadFile("intro.mp3");
  instructions = minim.loadFile("instructions.mp3");
  game = minim.loadFile("game.mp3");
  slash = minim.loadFile("slash.mp3");
  ding = minim.loadFile("ding.mp3");
  fxs[0] = minim.loadFile("ohyeah.mp3");
  fxs[1] = minim.loadFile("cutitcutit.mp3");
  fxs[2] = minim.loadFile("cutit.mp3");
  fxs[3] = minim.loadFile("leavenothing.mp3");
  fxs[4] = minim.loadFile("salttheearth.mp3");
  fxs[5] = minim.loadFile("cutitall.mp3");
}

void draw() {
  // Intro screen
  if (state == 0) {
    image(backgrounds[state], 0, 0);
    startScreen();
    if (!intro.isPlaying() && !intro.isLooping()) {
      if (game.isPlaying()) {
        game.close();
      }
      intro.loop();
    }
    // Splitscreen explanation
  } 
  else if (state == 1) {
    image(backgrounds[state], 0, 0);
    playersScreen();
    if (!instructions.isPlaying() && !instructions.isLooping()) {
      if (intro.isPlaying()) {
        intro.close();
      }
      instructions.loop();
    }
    // The game
  } 
  else if (state == 2) {
    image(backgrounds[state], 0, 0);
    game();
    if (!game.isPlaying() && !game.isLooping()) {
      if (instructions.isPlaying()) {
        instructions.close();
      }
      game.loop();
    }
    // Endings
  } 
  else if (state == 3) {
    results();
  }
}

void keyPressed() {
  if (key == 'q') {
    action(p1);
  }
  if (key == 'p') {
    action(p2);
  }
  if (key == '0') {
    state = 0;
  }
  if (key == '1') {
    state = 1;
  }
  if (key == '2') {
    state = 2;
  }
  if (key == '3') {
    state = 3;
  }
}

void startScreen() {
  state = 0;
}

void playersScreen() {
  state = 1;
  fill(#e7db76);
  textFont(gotham, 32);
  textAlign(LEFT);
  if (p1ready==true) {
    // text saying ready
    text("Ready!".toUpperCase(), 135, 540);
  } 
  else {
    text("Vote to Start".toUpperCase(), 70, 540);
  }
  if (p2ready==true) {
    text("Ready!".toUpperCase(), 540, 540);
  } 
  else {
    text("Cut to Start".toUpperCase(), 470, 540);
  }
}

void game() {
  state = 2;
  // start timer
  timer("bill");
  timer("favor");
  timer("calendar");
  current_bill.render();
  current_favor.render();
  scoreText();
}

void results() {
  state = 3;
  if (first_run == false) {
    first_run = true;
    for (int j=0; j<bills_presented.size(); j++) {
      JSON b = (JSON) bills_presented.get(j);
      boolean cut = false;
      for (int k=0; k<bills_cut.size(); k++) {
        Actionable a = (Actionable) bills_cut.get(k);
        if (b.getString("name").equals(a.name)) {
          cut = true;
        }
        println(b.getString("name") + " <++++++++> " + a.name);
        println(b.getString("name").equals(a.name));
        println("");
        println("");
      }
      if (cut==true && b.getString("affiliation").equals("left")) {
        cut_left += 1;
      }
      if (cut==true && b.getString("affiliation").equals("right")) {
        cut_right += 1;
      }
      if (cut==false && b.getString("affiliation").equals("left")) {
        not_cut_left += 1;
      }
      if (cut==false && b.getString("affiliation").equals("right")) {
        not_cut_right += 1;
      }
    }
    println(cut_left + " " + cut_right + " " + not_cut_left + " " + not_cut_right);
    e1 = calculateEnding(p1);
    e2 = calculateEnding(p2);
  } 
  else {
    e1 = calculateEnding(p1);
    e2 = calculateEnding(p2);
  }
  if (p1ready == false) {
    e1.draw();
  } 
  else if (p1ready == true && p2ready == false) {
    e2.draw();
  } 
  else {
    state = 0;
  }
}

void action(Player p) {
  if (state==0) {
    state=1;
  } 
  else if (state==1) {
    if (p.player==0 && p1ready==false) {
      p1ready=true;
    }
    if (p.player==1 && p2ready==false) {
      p2ready=true;
    }
    if (p1ready==true && p2ready==true) {
      state=2;
      p1ready=false;
      p2ready=false;
    }
  } 
  else if (state==2) {
    p.act();
  } 
  else if (state==3) {
    if (p.player==0 && p1ready==false) {
      p1ready=true;
    }
    if (p.player==1 && p2ready==false) {
      p2ready=true;
    }
    if (p1ready==true && p2ready==true) {
      if (e1.reelected == true && e2.reelected == true) {
        state = 2;
        final_month += 24;
      } 
      else {
        state = 0;
        last_mybill = 0;
        bills_passed = 0;
        cut_left = 0;
        cut_right = 0;
        not_cut_left = 0;
        not_cut_right = 0;
        p1ready=false;
        p2ready=false;
        mybill = false;
        player_cut = false;
        first_run = false;
        bills_left = new ArrayList();
        favors_left = new ArrayList();
        bills_cut = new ArrayList();
        favors_passed = new ArrayList();
        bills_presented = new ArrayList();

        for (int i=0; i<bills.length(); i++) {
          bills_left.add(bills.getObject(i));
        }
        for (int i=0; i<favors.length(); i++) {
          favors_left.add(favors.getObject(i));
        }
        bill_cycle = 0;
        favor_cycle = 0;
        calendar_cycle = 0;
        bill_limit = 1500;
        favor_limit = 3000;
        calendar_limit = 1000;
        current_month = 1;
        final_month = 24;
        p1 = new Player(0);
        p2 = new Player(1);
      }
      p1ready=false;
      p2ready=false;
    }
  }
}

Ending calculateEnding(Player p) {
  Ending e = new Ending(cut_left, cut_right, not_cut_left, not_cut_right, bills_passed, player_cut, p);
  return e;
}

void load(String type, ArrayList container) {
  if (type=="bills") {
  } 
  else if (type=="favors") {
  } 
  else if (type=="responses") {
  } 
  else if (type=="endings") {
  }
}

int timer(String type) {
  int r = 0;
  if (type == "bill") {
    if ((millis()-bill_cycle)>=bill_limit) {
      bill_cycle = millis();
      billReset();
      r = (int)(bill_cycle-millis());
    }
  } 
  else if (type == "favor") {
    if ((millis()-favor_cycle)>=favor_limit) {
      favor_cycle = millis();
      favorReset();
      r = (int)(favor_cycle-millis());
    }
  } 
  else if (type == "calendar") {
    if (current_month<final_month) {
      if ((millis()-calendar_cycle)>=calendar_limit) {
        calendar_cycle = millis();
        calendarReset();
        r = (int)(calendar_cycle-millis());
      }
    }
  } 
  return r;
}

void billReset() {
  if (favors_passed.size()%4 == 0 && favors_passed.size() > last_mybill) {
    last_mybill = favors_passed.size();
    current_bill = new Actionable("bill", player_bill);
    bills_passed+=1;
  } 
  else {
    if (bills_left.size()>0) {
      if (bills_left.size() != bills.length()) {
        if (current_bill.active) {
          current_bill.active = false;
        }
      }
      int bill_i = (int)random(0, bills_left.size()-1);
      current_bill = new Actionable("bill", (JSON) bills_left.get(bill_i));
      bills_presented.add(bills.getObject(bill_i));
      bills_left.remove(bill_i);
    } 
    else {
      for (int i=0; i<bills.length(); i++) {
        bills_left.add(bills.getObject(i));
      }
      for (int i=0; i<favors.length(); i++) {
        favors_left.add(favors.getObject(i));
      }
    }
  }
}

void favorReset() {
  if (favors_left.size()>0) {
    int favor_i = (int)random(0, favors_left.size()-1);
    current_favor = new Actionable("favor", (JSON) favors_left.get(favor_i));
    favors_left.remove(favor_i);
  }
}

void calendarReset() {
  current_month += 1;
  if (current_month >= final_month) {
    state = 3;
  }
}

void scoreText() {
  fill(#610d0d);
  textAlign(CENTER);
    textFont(bigcaslon, 24);
  if (p1.score == 0) {  
    text("$0", 220, 50);
  } 
  else {
    text("$"+nfc(p1.score*10)+",000", 220, 50);
  }
  textFont(bigcaslon, 16);
  text("SPENT", 220, 90);
  textFont(bigcaslon, 24);
  if (p2.score == 0) {  
    text("$0", 650, 50);
  } 
  else {
    text("$"+nfc(p2.score*10)+",000", 690, 50);
  }
  textFont(bigcaslon, 16);
  text("SAVED", 690, 90);
    textFont(bigcaslon, 36);
  text(favors_passed.size(), 75, 50);
    textFont(bigcaslon, 16);
  text("FAVORS PASSED", 75, 90);
    textFont(bigcaslon, 36);
  text(bills_cut.size(), 550, 50);
    textFont(bigcaslon, 16);
  text("BILLS PASSED", 67, 290);
    textFont(bigcaslon, 36);
  text(bills_passed, 67, 250);
    textFont(bigcaslon, 16);
  text("BLLS CUT", 550, 90);
  fill(255);
  textFont(bigcaslon, 14);
  text("MONTHS INTO TERM", 400, 30);
  textFont(bigcaslon, 60);
  text(current_month, 400, 95);
}

void serialEvent (Serial port) {
  String message = port.readStringUntil('\n');
  String[] parts = message.split(" ");
  if (parts.length == 2) {
    if (float(parts[0]) == 1) {
      action(p1);
    }
    if (float(parts[1]) == 1) {
      action(p2);
    }
  }
}

void stop()
{
  if (state == 3) {
    game.close();
  } 
  else if (state == 2) {
    instructions.close();
  } 
  else if (state == 1) {
    intro.close();
  }

  minim.stop();
  super.stop();
}

/**
 wordwrap taken from http://wiki.processing.org/index.php?title=Word_wrap_text
 @author Daniel Shiffman
 */

// Function to return an ArrayList of Strings (maybe redo to just make simple array?)
// Arguments: String to be wrapped, maximum width in pixels of each line
ArrayList wordWrap(String s, int maxWidth) {
  // Make an empty ArrayList
  ArrayList a = new ArrayList();
  float w = 0;    // Accumulate width of chars
  int i = 0;      // Count through chars
  int rememberSpace = 0; // Remember where the last space was
  // As long as we are not at the end of the String
  while (i < s.length ()) {
    // Current char
    char c = s.charAt(i);
    w += textWidth(c); // accumulate width
    if (c == ' ') rememberSpace = i; // Are we a blank space?
    if (w > maxWidth) {  // Have we reached the end of a line?
      String sub = s.substring(0, rememberSpace); // Make a substring
      // Chop off space at beginning
      if (sub.length() > 0 && sub.charAt(0) == ' ') sub = sub.substring(1, sub.length());
      // Add substring to the list
      a.add(sub);
      // Reset everything
      s = s.substring(rememberSpace, s.length());
      i = 0;
      w = 0;
    } 
    else {
      i++;  // Keep going!
    }
  }

  // Take care of the last remaining line
  if (s.length() > 0 && s.charAt(0) == ' ') s = s.substring(1, s.length());
  a.add(s);

  return a;
}


//import processing.serial.*;
//import ddf.minim.*;
//
//Minim minim;
//AudioPlayer intro, instructions, game, slash;
//AudioPlayer[] fxs = new AudioPlayer[6];
//
//Serial port;
//
//int term, inactivity, freq, freq_limit, freq_last, month_interval, current_month; // timers
//int current, player_score, player_cuts, instructions_start, months, slice_time;
//int rand_curr, rand_target;
//int head_y, rn, head_flag;
//float scissors;
//PImage[] backgrounds = new PImage[4];
//PImage[] teaparty = new PImage[6];
//PFont atlantic, gotham, bigcaslon;
//String[] names = new String[50];
//int[] costs = new int[50];
//ArrayList reductions, onscreen;
//int state = 0;
//float DEG, BOUND_MIN, BOUND_MAX, FEDERAL_BUDGET, FEDERAL_DEFICIT;
//
//void setup() {
//  DEG = .174532925;
//  BOUND_MIN = .05;
//  BOUND_MAX = .20;
//  int totalcuts = 0;
//  FEDERAL_BUDGET = 298000000;
//  FEDERAL_DEFICIT = 90000000;
//  port = new Serial(this, Serial.list()[0], 9600);
//  port.bufferUntil('\n');
//  atlantic = loadFont("atlantic.vlw");
//  gotham = loadFont("gotham.vlw");
//  bigcaslon = loadFont("bigcaslon.vlw");
//  size(800, 600);
//  background(0);
//  rectMode(CENTER);
//  freq_limit = 1100;
//  freq_last = 0;
//  month_interval = 2000;
//  current_month = 0;
//  current = 0;
//  player_score = 0;
//  player_cuts = 0;
//  instructions_start = 0;
//  months = 0;
//  slice_time = 0;
//  head_y = 250;
//  rn = 0;
//  head_flag = -1;
//  minim = new Minim(this);
//  intro = minim.loadFile("intro.mp3");
//  instructions = minim.loadFile("instructions.mp3");
//  game = minim.loadFile("game.mp3");
//  slash = minim.loadFile("slash.mp3");
//  fxs[0] = minim.loadFile("ohyeah.mp3");
//  fxs[1] = minim.loadFile("cutitcutit.mp3");
//  fxs[2] = minim.loadFile("cutit.mp3");
//  fxs[3] = minim.loadFile("leavenothing.mp3");
//  fxs[4] = minim.loadFile("salttheearth.mp3");
//  fxs[5] = minim.loadFile("cutitall.mp3");
//  backgrounds[0] = loadImage("title.jpg");
//  backgrounds[1] = loadImage("instructions.jpg");
//  backgrounds[2] = loadImage("level.jpg");
//  backgrounds[3] = loadImage("background.jpg");
//  teaparty[0] = loadImage("tp0.png");
//  teaparty[1] = loadImage("tp1.png");
//  teaparty[2] = loadImage("tp2.png");
//  teaparty[3] = loadImage("tp3.png");
//  teaparty[4] = loadImage("tp4.png");
//  teaparty[5] = loadImage("tp5.png");
//  reductions = new ArrayList();
//  onscreen = new ArrayList();
//  for (int i=0;i<47;i++) {
//    Reduction r = new Reduction(names[i], costs[i]);
//    r.x = -width;
//    r.y = -height;
//    r.x_last = (int)random((int)(width*BOUND_MIN), (int)(width*BOUND_MAX));
//    r.y_last = (int)random((int)(height*BOUND_MIN), (int)(height*BOUND_MAX));
//    r.rotation = random(-DEG, DEG);
//
//    r.x_rate = (r.x_last - r.x)/30;
//    r.y_rate = (r.y_last - r.y)/30;
//    reductions.add(r);
//    totalcuts += r.cost;
//    //    println(r.name);
//  }
//  //  println(totalcuts);
//  //  println(totalcuts/FEDERAL_DEFICIT);
//  //  println(totalcuts/FEDERAL_BUDGET);
//}
//
//void draw() {
//  image(backgrounds[state], 0, 0);
//  if (state == 0) {
//    if (!intro.isPlaying()) {
//      intro.loop();
//    }
//    // title screen
//  } 
//  else if (state == 1) {
//    if (!instructions.isPlaying() && !instructions.isLooping()) {
//      if (intro.isPlaying()) {
//        intro.close();
//      }
//      instructions.loop();
//    }
//    // instructions
//  }
//  else if (state == 2) {
//    if (!game.isPlaying() && !game.isLooping()) {
//      if (instructions.isPlaying()) {
//        instructions.close();
//      }
//      game.loop();
//    }
//    fill(0);
//    textFont(bigcaslon, 24);
//    if (player_score==0) {
//      fill(#610d0d);
//      text("$0", 650, 50);
//      text("SAVED", 650, 90);
//      textAlign(CENTER);
//    } 
//    else {
//      fill(#610d0d);
//      text("$"+nfc(player_score*10)+",000", 650, 50);
//      text("SAVED", 650, 90);
//      textAlign(CENTER);
//    }
//    fill(#610d0d);
//    text(player_cuts, 150, 50);
//    text("CUTS", 150, 90);
//    textAlign(CENTER);
//    fill(255);
//    textFont(bigcaslon, 14);
//    text("MONTHS INTO TERM", 400, 30);
//    textAlign(CENTER);
//    textFont(bigcaslon, 60);
//    text(months, 400, 95);
//    textAlign(CENTER);
//    for (int i=0;i<onscreen.size();i++) {
//      Reduction r = (Reduction) onscreen.get(i);
//      r.render();
//    }
//
//    if ((millis()-freq_last)>=freq_limit) {
//      freq_last = millis();
//      if (current<47) {
//        //        println(current);
//        int rand = (int)random(reductions.size());
//        //        println("first rand: " + rand);
//        if (onscreen.size()>0) {
//          for (int i=0;i<onscreen.size();i++) {
//            Reduction r_random = (Reduction) reductions.get(rand);
//            Reduction r_i = (Reduction) onscreen.get(i);
//            if (r_i.name == r_random.name) {
//              rand = (int)random(reductions.size());
//              //              println("loop rand: " + rand);
//              i = -1;
//            }
//          }
//          onscreen.add((Reduction) reductions.get(rand));
//        } 
//        else {
//          onscreen.add((Reduction) reductions.get(rand));
//        }
//        current+=1;
//      }
//      if (current == 46) {
//        state = 3;
//      }
//    }
//    if ((millis()-current_month)>=month_interval) {
//      current_month = millis();
//      months++;
//      if (months >= 24) {
//        state = 3;
//      }
//    }
//    for (int i=0;i<teaparty.length;i++) {
//      if (i == rn) {
//        animateHead(i);
//      }
//    }
//  } 
//  else if (state == 3) {
//    String programs_cut = "";
//    for (int i=0;i<onscreen.size();i++) {
//      Reduction r = (Reduction) onscreen.get(i);
//      if (r.alive == false) {
//        programs_cut+=r.name;
//        programs_cut+="/";
//      }
//    }
//    if (programs_cut.length() > 0) {
//      programs_cut = programs_cut.substring(0, programs_cut.length() - 1);
//    }
//    fill(255);
//    textFont(bigcaslon, 48);
//    text("What We Lost:".toUpperCase(), 200, 60);
//    textAlign(LEFT);
//    textFont(bigcaslon, 12);
//    text(programs_cut.toUpperCase(), 420, 260, width-40, 330);
//    textFont(bigcaslon, 30);
//    text("What We Saved:".toUpperCase(), 50, 480);
//    fill(#e7db76);
//    float per = (player_score/FEDERAL_BUDGET)*100;
//    text(nfc(per, 3)+"%", 340, 480); 
//    fill(255);
//    textFont(bigcaslon, 18);
//    text(" of the budget for ".toUpperCase(), 440, 480); 
//    fill(#e7db76);
//    textFont(bigcaslon, 30);
//    text("1 year".toUpperCase(), 660, 480); 
//    textFont(bigcaslon, 36);
//    fill(255);
//    text("Was it worth it?", 300, 550);
//  }
//}
//
//void keyPressed() {
//  if (key == ' ') {
//    if (state == 0) {
//      state = 1;
//    } 
//    else if (state == 1) {
//      state = 2;
//    } 
//    else if (state == 2) {
//      cutBill();
//    }
//    else if (state == 3) {
//      // dunno yet
//    }
//  }
//  if (key == '0') {
//    state = 0;
//  }
//  if (key == '1') {
//    state = 1;
//  }
//  if (key == '2') {
//    state = 2;
//  }
//  if (key == '3') {
//    state = 3;
//  }
//}
//
//void cutBill() {
//  if (onscreen.size()>=1) {
//    Reduction r = (Reduction) onscreen.get(onscreen.size()-1);
//    if (r.x > 0) {
//      if (r.alive) {
//        player_cuts++;
//        player_score += r.cost;
//        r.slashed();
//        slash.play(20);
//        if (rand_curr<rand_target) {
//          rand_curr++;
//        } 
//        else {
//          rn = (int)random(6);
//          head_flag = rn;
//          fxs[rn].play(0);
//          rand_curr = 0;
//          rand_target = (int)random(2, 5);
//        }
//      }
//    }
//  }
//}
//
//void serialEvent (Serial port)
//{
//  scissors = float(port.readStringUntil('\n'));
//  if (scissors == 1) {
//    if (state == 0) {
//      state = 1;
//      instructions_start = millis();
//    } 
//    else if (state == 1) {
//      if ((millis()-instructions_start)>1000) {
//        state = 2;
//        slice_time = millis();
//      }
//    } 
//    else if (state == 2) {
//      if ((millis()-slice_time)>100) {
//        cutBill();
//        slice_time = millis();
//      }
//    }
//    else if (state == 3) {
//      // dunno yet
//    }
//  }
//}
//
//void animateHead(int i) {
//  if (fxs[i].isPlaying()) {
//    image(teaparty[i], 0, 0);
//  } 
//  else {
//    image(teaparty[i], 0, 250);
//  }
//}
//
//void stop()
//{
//  if (state == 3) {
//    game.close();
//  } 
//  else if (state == 2) {
//    instructions.close();
//  } 
//  else if (state == 1) {
//    intro.close();
//  }
//
//  minim.stop();
//  super.stop();
//}

