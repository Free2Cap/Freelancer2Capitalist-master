class FirmModel {
  String? uid;
  String? name;
  String? background;
  String? age;
  double? budgetStart;
  double? budgetEnd;
  String? field;
  String? mission;
  String? firmImage;

  FirmModel(
      {this.uid,
      this.name,
      this.background,
      this.age,
      this.budgetStart,
      this.budgetEnd,
      this.field,
      this.mission,
      this.firmImage});

  FirmModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    name = map['name'];
    background = map['background'];
    age = map['age'];
    budgetStart = map['budgetStart'];
    budgetEnd = map['budgetEnd'];
    field = map['field'];
    mission = map["mission"];
    firmImage = map["firmImage"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "background": background,
      "age": age,
      "budgetStart": budgetStart,
      "budgetEnd": budgetEnd,
      "field": field,
      "mission": mission,
      "firmImage": firmImage,
    };
  }
}
