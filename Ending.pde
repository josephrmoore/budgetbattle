class Ending {
  boolean reelected; // true or false
  String party; // "left" or "right"
  String content; // Text of the ending
  String degree; // "good", "mediocre", or "bad"

// Examples:
// Ending e = new Ending(true, "left", "mediocre", endings[2]);
// Ending e = new Ending(false, "right", "good", endings[3]);  

  Ending(boolean reelected, String party, String degree, String content) {
    this.reelected = reelected;
    this.party = party;
    this.degree = degree;
    this.content = content;
  }


