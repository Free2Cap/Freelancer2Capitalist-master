class ProjectModel {
  String? uid;
  String? creator;
  String? aim;
  String? objective;
  String? scope;
  double? budgetStart;
  double? budgetEnd;
  String? field;
  String? feasiility;
  List<String>? projectImages;

  ProjectModel(
      {this.creator,
      this.uid,
      this.aim,
      this.objective,
      this.scope,
      this.budgetStart,
      this.budgetEnd,
      this.field,
      this.feasiility,
      this.projectImages});

  ProjectModel.fromMap(Map<String, dynamic> map) {
    creator = map["creator"];
    uid = map["uid"];
    aim = map['aim'];
    objective = map['objective'];
    scope = map['scope'];
    budgetStart = map['budgetStart'];
    budgetEnd = map['budgetEnd'];
    field = map['field'];
    feasiility = map["feasiility"];
    projectImages =
        List<String>.from(map['projectImages']?.cast<String>() ?? []);
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "creator": creator,
      "aim": aim,
      "objective": objective,
      "scope": scope,
      "budgetStart": budgetStart,
      "budgetEnd": budgetEnd,
      "field": field,
      "feasiility": feasiility,
      "projectImages": projectImages,
    };
  }
}
