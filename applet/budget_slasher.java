import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class budget_slasher extends PApplet {

int term, inactivity, freq, freq_limit, freq_last; // timers
int current;
PImage[] backgrounds = new PImage[4];
String[] names = new String[50];
int[] costs = new int[50];
ArrayList reductions, onscreen;
int state = 0;
float DEG, BOUND_MIN, BOUND_MAX, FEDERAL_BUDGET, FEDERAL_DEFICIT;
Timer t;
public void testMe() {
};

public void setup() {
  DEG = .174532925f;
  BOUND_MIN = .05f;
  BOUND_MAX = .20f;
  int totalcuts = 0;
  FEDERAL_BUDGET = 298000000;
  FEDERAL_DEFICIT = 90000000;
  size(800, 600);
  background(0);
  rectMode(CENTER);
  freq_limit = 3000;
  freq_last = 0;
  current = 0;
  backgrounds[0] = loadImage("title.jpg");
  backgrounds[1] = loadImage("instructions.jpg");
  backgrounds[2] = loadImage("level.jpg");
  backgrounds[3] = loadImage("background.jpg");
  names[0] = "Corporation for Public Broadcasting Subsidy";
  names[1] = "Save America\u2019s Treasures Program";
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
  names[43] = "The National Organic Certification Cost-Share Program";
  names[44] = "Fund for Obamacare administrative costs";
  names[45] = "Ready to Learn TV Program";
  names[46] = "Community Development Fund";
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
  costs[43] = 5620;
  costs[44] = 90000;
  costs[45] = 2700;
  costs[46] = 450000;
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
    println(r.name);
  }
//  println(totalcuts);
//  println(totalcuts/FEDERAL_DEFICIT);
//  println(totalcuts/FEDERAL_BUDGET);
}

public void draw() {
  image(backgrounds[state], 0, 0);
  if (state == 0) {
    // title screen
  } 
  else if (state == 1) {
    // instructions
  }
  else if (state == 2) {
    // level
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
  } 
  else if (state == 3) {
    // results
  }
}

public void keyPressed() {
  if (key == ' ') {
    if (state == 0) {
      state = 1;
    } 
    else if (state == 1) {
      state = 2;
    } 
    else if (state == 2) {
      if (onscreen.size()>=1) {
        Reduction r = (Reduction) onscreen.get(onscreen.size()-1);
        if (r.flying == false) {
//          print(r.name+" ");
//          println(r.cost);
          r.slashed();
          //          onscreen.remove(onscreen.size()-1);
        }
      }
    } 
    else if (state == 3) {
      state = 1;
    }
  }
}

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

  public void render() {
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

  public void flyIn() {
    this.x += this.x_rate;
    this.y += this.y_rate;
  }

  public void slashed() {
    // slashing animation
    this.alive = false;
    if (!this.played) {
      this.playMessage();
      this.played = true;
    }
  }

  public void playMessage() {
    // flash name and cost of program on the screen then fade
  }
}

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

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "budget_slasher" });
  }
}
