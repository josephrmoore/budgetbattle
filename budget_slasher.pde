import processing.serial.*;
import ddf.minim.*;
Minim minim;
AudioPlayer intro, instructions, game, slash;
AudioPlayer[] fxs = new AudioPlayer[6];
Serial port;
int term, inactivity, freq, freq_limit, freq_last, month_interval, current_month; // timers
int current, player_score, player_cuts, instructions_start, months, slice_time;
int rand_curr, rand_target;
int head_y, rn, head_flag;
float scissors;
PImage[] backgrounds = new PImage[4];
PImage[] teaparty = new PImage[6];
PFont atlantic, gotham, bigcaslon;
String[] names = new String[50];
int[] costs = new int[50];
ArrayList reductions, onscreen;
int state = 0;
float DEG, BOUND_MIN, BOUND_MAX, FEDERAL_BUDGET, FEDERAL_DEFICIT;

void setup() {
  DEG = .174532925;
  BOUND_MIN = .05;
  BOUND_MAX = .20;
  int totalcuts = 0;
  FEDERAL_BUDGET = 298000000;
  FEDERAL_DEFICIT = 90000000;
  port = new Serial(this, Serial.list()[0], 9600);
  port.bufferUntil('\n');
  atlantic = loadFont("atlantic.vlw");
  gotham = loadFont("gotham.vlw");
  bigcaslon = loadFont("bigcaslon.vlw");
  size(800, 600);
  background(0);
  rectMode(CENTER);
  freq_limit = 1100;
  freq_last = 0;
  month_interval = 2000;
  current_month = 0;
  current = 0;
  player_score = 0;
  player_cuts = 0;
  instructions_start = 0;
  months = 0;
  slice_time = 0;
  head_y = 250;
  rn = 0;
  head_flag = -1;
  minim = new Minim(this);
  intro = minim.loadFile("intro.mp3");
  instructions = minim.loadFile("instructions.mp3");
  game = minim.loadFile("game.mp3");
  slash = minim.loadFile("slash.mp3");
  fxs[0] = minim.loadFile("ohyeah.mp3");
  fxs[1] = minim.loadFile("cutitcutit.mp3");
  fxs[2] = minim.loadFile("cutit.mp3");
  fxs[3] = minim.loadFile("leavenothing.mp3");
  fxs[4] = minim.loadFile("salttheearth.mp3");
  fxs[5] = minim.loadFile("cutitall.mp3");
  backgrounds[0] = loadImage("title.jpg");
  backgrounds[1] = loadImage("instructions.jpg");
  backgrounds[2] = loadImage("level.jpg");
  backgrounds[3] = loadImage("background.jpg");
  teaparty[0] = loadImage("tp0.png");
  teaparty[1] = loadImage("tp1.png");
  teaparty[2] = loadImage("tp2.png");
  teaparty[3] = loadImage("tp3.png");
  teaparty[4] = loadImage("tp4.png");
  teaparty[5] = loadImage("tp5.png");
  names[0] = "Corporation for Public Broadcasting Subsidy";
  names[1] = "Save America’s Treasures Program";
  names[2] = "International Fund for Ireland";
  names[3] = "Legal Services Corporation";
  names[4] = "National Endowment for the Arts";
  names[5] = "National Endowment for the Humanities";
  names[6] = "Hope VI Program";
  names[7] = "Amtrak Subsidies";
  names[8] = "Duplicative education programs. H.R. 2274";
  names[9] = "U.S. Trade Development Agency";
  names[10] = "Woodrow Wilson Center Subsidy";
  names[11] = "50% funding for congressional printing and binding";
  names[12] = "John C. Stennis Center Subsidy";
  names[13] = "Heritage Area Grants and Statutory Aid";
  names[14] = "50% Federal Travel Budget";
  names[15] = "20% Federal Vehicle Budget";
  names[16] = "Essential Air Service";
  names[17] = "Technology Innovation Program";
  names[18] = "Manufacturing Extension Partnership (MEP) Program";
  names[19] = "Department of Energy Grants to States for Weatherization";
  names[20] = "Beach Replenishment";
  names[21] = "New Starts Transit";
  names[22] = "Exchange Programs for Alaska, Natives Native Hawaiians, and Their Historical Trading Partners in Massachusetts.";
  names[23] = "Intercity and High Speed Rail Grants";
  names[24] = "Title X Family Planning";
  names[25] = "Appalachian Regional Commission";
  names[26] = "Economic Development Administration";
  names[27] = "Programs under the National and Community Services Act";
  names[28] = "Applied Research at Department of Energy";
  names[29] = "FreedomCAR and Fuel Partnership";
  names[30] = "Energy Star Program";
  names[31] = "Economic Assistance to Egypt";
  names[32] = "U.S. Agency for International Development";
  names[33] = "General Assistance to District of Columbia";
  names[34] = "Subsidy for Washington Metropolitan Area Transit Authority";
  names[35] = "Presidential Campaign Fund";
  names[36] = "Federal office space acquisition funding";
  names[37] = "Excess federal properties";
  names[38] = "Mohair Subsidies";
  names[39] = "Taxpayer subsidies to the United Nations Intergovernmental Panel on Climate Change";
  names[40] = "Market Access Program";
  names[41] = "USDA Sugar Program";
  names[42] = "Subsidy to Organisation for Economic Co-operation and Development (OECD)";
  names[43] = "Corporate Subsidies";
  names[44] = "Aid to Israel";
  names[45] = "Tax-Exempt Status for Churches";
  names[46] = "1% reduction in Defense Spending";
  names[47] = "MEDICARE";
  names[48] = "SOCIAL SECURITY";
  names[49] = "DEFENSE";
  costs[0] = 44500;
  costs[1] = 2500;
  costs[2] = 1700;
  costs[3] = 42000;
  costs[4] = 16750;
  costs[5] = 16750;
  costs[6] = 25000;
  costs[7] = 156500;
  costs[8] = 130000;
  costs[9] = 5500;
  costs[10] = 2000;
  costs[11] = 4700;
  costs[12] = 43;
  costs[13] = 2400;
  costs[14] = 750000;
  costs[15] = 60000;
  costs[16] = 15000;
  costs[17] = 7000;
  costs[18] = 12500;
  costs[19] = 53000;
  costs[20] = 9500;
  costs[21] = 200000;
  costs[22] = 900;
  costs[23] = 250000;
  costs[24] = 31800;
  costs[25] = 7600;
  costs[26] = 29300;
  costs[27] = 115000;
  costs[28] = 127000;
  costs[29] = 20000;
  costs[30] = 5200;
  costs[31] = 25000;
  costs[32] = 139000;
  costs[33] = 21000;
  costs[34] = 15000;
  costs[35] = 7750;
  costs[36] = 86400;
  costs[37] = 1500000;
  costs[38] = 100;
  costs[39] = 1250;
  costs[40] = 20000;
  costs[41] = 1400;
  costs[42] = 9300;
  costs[43] = 10000000;
  costs[44] = 300000;
  costs[45] = 7100000;
  costs[46] = 740000;
  costs[47] = 56000000;
  costs[48] = 65000000;
  costs[49] = 74000000;
  reductions = new ArrayList();
  onscreen = new ArrayList();
  for (int i=0;i<47;i++) {
    Reduction r = new Reduction(names[i], costs[i]);
    r.x = -width;
    r.y = -height;
    r.x_last = (int)random((int)(width*BOUND_MIN), (int)(width*BOUND_MAX));
    r.y_last = (int)random((int)(height*BOUND_MIN), (int)(height*BOUND_MAX));
    r.rotation = random(-DEG, DEG);

    r.x_rate = (r.x_last - r.x)/30;
    r.y_rate = (r.y_last - r.y)/30;
    reductions.add(r);
    totalcuts += r.cost;
    //    println(r.name);
  }
  //  println(totalcuts);
  //  println(totalcuts/FEDERAL_DEFICIT);
  //  println(totalcuts/FEDERAL_BUDGET);
}

void draw() {
  image(backgrounds[state], 0, 0);
  if (state == 0) {
    if (!intro.isPlaying()) {
      intro.loop();
    }
    // title screen
  } 
  else if (state == 1) {
    if (!instructions.isPlaying() && !instructions.isLooping()) {
      if (intro.isPlaying()) {
        intro.close();
      }
      instructions.loop();
    }
    // instructions
  }
  else if (state == 2) {
    if (!game.isPlaying() && !game.isLooping()) {
      if (instructions.isPlaying()) {
        instructions.close();
      }
      game.loop();
    }
    fill(0);
    textFont(bigcaslon, 24);
    if (player_score==0) {
      fill(#610d0d);
      text("$0", 650, 50);
      text("SAVED", 650, 90);
      textAlign(CENTER);
    } 
    else {
      fill(#610d0d);
      text("$"+nfc(player_score*10)+",000", 650, 50);
      text("SAVED", 650, 90);
      textAlign(CENTER);
    }
    fill(#610d0d);
    text(player_cuts, 150, 50);
    text("CUTS", 150, 90);
    textAlign(CENTER);
    fill(255);
    textFont(bigcaslon, 14);
    text("MONTHS INTO TERM", 400, 30);
    textAlign(CENTER);
    textFont(bigcaslon, 60);
    text(months, 400, 95);
    textAlign(CENTER);
    for (int i=0;i<onscreen.size();i++) {
      Reduction r = (Reduction) onscreen.get(i);
      r.render();
    }

    if ((millis()-freq_last)>=freq_limit) {
      freq_last = millis();
      if (current<47) {
        //        println(current);
        int rand = (int)random(reductions.size());
        //        println("first rand: " + rand);
        if (onscreen.size()>0) {
          for (int i=0;i<onscreen.size();i++) {
            Reduction r_random = (Reduction) reductions.get(rand);
            Reduction r_i = (Reduction) onscreen.get(i);
            if (r_i.name == r_random.name) {
              rand = (int)random(reductions.size());
              //              println("loop rand: " + rand);
              i = -1;
            }
          }
          onscreen.add((Reduction) reductions.get(rand));
        } 
        else {
          onscreen.add((Reduction) reductions.get(rand));
        }
        current+=1;
      }
      if (current == 46) {
        state = 3;
      }
    }
    if ((millis()-current_month)>=month_interval) {
      current_month = millis();
      months++;
      if (months >= 24) {
        state = 3;
      }
    }
    for (int i=0;i<teaparty.length;i++) {
      if (i == rn) {
        animateHead(i);
      }
    }
  } 
  else if (state == 3) {
    String programs_cut = "";
    for (int i=0;i<onscreen.size();i++) {
      Reduction r = (Reduction) onscreen.get(i);
      if (r.alive == false) {
        programs_cut+=r.name;
        programs_cut+="/";
      }
    }
    if (programs_cut.length() > 0) {
      programs_cut = programs_cut.substring(0, programs_cut.length() - 1);
    }
    fill(255);
    textFont(bigcaslon, 48);
    text("What We Lost:".toUpperCase(), 200, 60);
    textAlign(LEFT);
    textFont(bigcaslon, 12);
    text(programs_cut.toUpperCase(), 420, 260, width-40, 330);
    textFont(bigcaslon, 30);
    text("What We Saved:".toUpperCase(), 50, 480);
    fill(#e7db76);
    float per = (player_score/FEDERAL_BUDGET)*100;
    text(nfc(per, 3)+"%", 340, 480); 
    fill(255);
    textFont(bigcaslon, 18);
    text(" of the budget for ".toUpperCase(), 440, 480); 
    fill(#e7db76);
    textFont(bigcaslon, 30);
    text("1 year".toUpperCase(), 660, 480); 
    textFont(bigcaslon, 36);
    fill(255);
    text("Was it worth it?", 300, 550);
  }
}

void keyPressed() {
  if (key == ' ') {
    if (state == 0) {
      state = 1;
    } 
    else if (state == 1) {
      state = 2;
    } 
    else if (state == 2) {
      cutBill();
    }
    else if (state == 3) {
      // dunno yet
    }
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

void cutBill() {
  if (onscreen.size()>=1) {
    Reduction r = (Reduction) onscreen.get(onscreen.size()-1);
    if (r.x > 0) {
      if (r.alive) {
        player_cuts++;
        player_score += r.cost;
        r.slashed();
        slash.play(20);
        if (rand_curr<rand_target) {
          rand_curr++;
        } 
        else {
          rn = (int)random(6);
          head_flag = rn;
          fxs[rn].play(0);
          rand_curr = 0;
          rand_target = (int)random(2, 5);
        }
      }
    }
  }
}

void serialEvent (Serial port)
{
  scissors = float(port.readStringUntil('\n'));
  if (scissors == 1) {
    if (state == 0) {
      state = 1;
      instructions_start = millis();
    } 
    else if (state == 1) {
      if ((millis()-instructions_start)>1000) {
        state = 2;
        slice_time = millis();
      }
    } 
    else if (state == 2) {
      if ((millis()-slice_time)>100) {
        cutBill();
        slice_time = millis();
      }
    }
    else if (state == 3) {
      // dunno yet
    }
  }
}

void animateHead(int i) {
  if (fxs[i].isPlaying()) {
    image(teaparty[i], 0, 0);
  } 
  else {
    image(teaparty[i], 0, 250);
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





//  names[0] = "Corporation for Public Broadcasting Subsidy";
//  names[1] = "Save America’s Treasures Program";
//  names[2] = "International Fund for Ireland";
//  names[3] = "Legal Services Corporation";
//  names[4] = "National Endowment for the Arts";
//  names[5] = "National Endowment for the Humanities";
//  names[6] = "Hope VI Program";
//  names[7] = "Amtrak Subsidies";
//  names[8] = "Duplicative education programs. H.R. 2274";
//  names[9] = "U.S. Trade Development Agency";
//  names[10] = "Woodrow Wilson Center Subsidy";
//  names[11] = "50% funding for congressional printing and binding";
//  names[12] = "John C. Stennis Center Subsidy";
//  names[13] = "Heritage Area Grants and Statutory Aid";
//  names[14] = "50% Federal Travel Budget";
//  names[15] = "20% Federal Vehicle Budget";
//  names[16] = "Essential Air Service";
//  names[17] = "Technology Innovation Program";
//  names[18] = "Manufacturing Extension Partnership (MEP) Program";
//  names[19] = "Department of Energy Grants to States for Weatherization";
//  names[20] = "Beach Replenishment";
//  names[21] = "New Starts Transit";
//  names[22] = "Exchange Programs for Alaska, Natives Native Hawaiians, and Their Historical Trading Partners in Massachusetts.";
//  names[23] = "Intercity and High Speed Rail Grants";
//  names[24] = "Title X Family Planning";
//  names[25] = "Appalachian Regional Commission";
//  names[26] = "Economic Development Administration";
//  names[27] = "Programs under the National and Community Services Act";
//  names[28] = "Applied Research at Department of Energy";
//  names[29] = "FreedomCAR and Fuel Partnership";
//  names[30] = "Energy Star Program";
//  names[31] = "Economic Assistance to Egypt";
//  names[32] = "U.S. Agency for International Development";
//  names[33] = "General Assistance to District of Columbia";
//  names[34] = "Subsidy for Washington Metropolitan Area Transit Authority";
//  names[35] = "Presidential Campaign Fund";
//  names[36] = "Federal office space acquisition funding";
//  names[37] = "Excess federal properties";
//  names[38] = "Mohair Subsidies";
//  names[39] = "Taxpayer subsidies to the United Nations Intergovernmental Panel on Climate Change";
//  names[40] = "Market Access Program";
//  names[41] = "USDA Sugar Program";
//  names[42] = "Subsidy to Organisation for Economic Co-operation and Development (OECD)";
//  names[43] = "The National Organic Certification Cost-Share Program";
//  names[44] = "Fund for Obamacare administrative costs";
//  names[45] = "Ready to Learn TV Program";
//  names[46] = "Community Development Fund";
//  names[47] = "MEDICARE";
//  names[48] = "SOCIAL SECURITY";
//  names[49] = "DEFENSE";
//  costs[0] = 44500;
//  costs[1] = 2500;
//  costs[2] = 1700;
//  costs[3] = 42000;
//  costs[4] = 16750;
//  costs[5] = 16750;
//  costs[6] = 25000;
//  costs[7] = 156500;
//  costs[8] = 130000;
//  costs[9] = 5500;
//  costs[10] = 2000;
//  costs[11] = 4700;
//  costs[12] = 43;
//  costs[13] = 2400;
//  costs[14] = 750000;
//  costs[15] = 60000;
//  costs[16] = 15000;
//  costs[17] = 7000;
//  costs[18] = 12500;
//  costs[19] = 53000;
//  costs[20] = 9500;
//  costs[21] = 200000;
//  costs[22] = 900;
//  costs[23] = 250000;
//  costs[24] = 31800;
//  costs[25] = 7600;
//  costs[26] = 29300;
//  costs[27] = 115000;
//  costs[28] = 127000;
//  costs[29] = 20000;
//  costs[30] = 5200;
//  costs[31] = 25000;
//  costs[32] = 139000;
//  costs[33] = 21000;
//  costs[34] = 15000;
//  costs[35] = 7750;
//  costs[36] = 86400;
//  costs[37] = 1500000;
//  costs[38] = 100;
//  costs[39] = 1250;
//  costs[40] = 20000;
//  costs[41] = 1400;
//  costs[42] = 9300;
//  costs[43] = 5620;
//  costs[44] = 90000;
//  costs[45] = 2700;
//  costs[46] = 450000;
//  costs[47] = 56000000;
//  costs[48] = 65000000;
//  costs[49] = 74000000;



//class Timer {
//  int starting, ms, pausedat;
//  boolean looping, finished, paused;
//    this.ms = milliseconds;
//    this.fx = fx;
//    this.startTimer();
//    this.starting = millis();
//    this.looping = looping;
//    this.finished = false;
//    this.paused = false;
//    this.pausedat = 0;
//  }
//  void updateTimer() {
//    if (this.paused == false) {
//      if (this.pausedat != 0) {
//        int timeelapsed = this.pausedat-this.starting;
//        this.starting = millis()-timelapsed;
//        this.pausedat = 0;
//      }
//      if (millis()-this.starting > this.ms && this.finished == false) {
//        if (this.looping) {
//          this.fx();
//          this.starting = millis();
//        } 
//        else {
//          this.fx();
//          finished = true;
//        }
//      }
//    } 
//    else {
//      if (this.pausedat != 0) {
//        this.pausedat = millis();
//      }
//    }
//  }
//  void resetTimer() {
//    this.finished = false;
//    this.starting = millis();
//  }
//  void pauseTimer() {
//    if (this.paused = false) {
//      this.paused = true;
//    } 
//    else {
//      this.paused = false;
//    }
//  }
//  void changeTimer(int amount) {
//    this.ms = amount;
//  }
//}

