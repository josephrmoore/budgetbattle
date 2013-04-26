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

