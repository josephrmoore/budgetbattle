class Actionable {
  String type; // "bill" or "favor"
  String affiliation; // "left", "right", or "player"
  String name; // "Council for the Arts" or "Pork for Ohio", etc.
  int cost; // ex. 100000 
  int righteousness; // between 0 and 1

// Examples:
// Actionable a = new Actionable("bill", "left", "Council for the Arts", 230000, 1);
// Actionable a = new Actionable("favor", "left", "Pork for Ohio", 230000, .2);  

  Actionable(String type, String affiliation, String name, int cost, int righteousness) {
    this.type = type;
    this.name = name;
    this.cost = cost;
    this.affiliation = affiliation;
    this.righteousness = righteousness;
  }


