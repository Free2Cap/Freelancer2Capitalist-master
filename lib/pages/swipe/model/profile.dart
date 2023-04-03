class Project {
  const Project({
    required this.uid,
    required this.aim,
    required this.objective,
    required this.budgetStart,
    required this.budgetEnd,
    required this.field,
    required this.projectImages,
    required this.creator,
    required this.creatorUid,
  });
  final String uid;
  final String creator;
  final String aim;
  final String objective;
  final String budgetStart;
  final String budgetEnd;
  final String field;
  final String projectImages;
  final String creatorUid;
}

class Firm {
  const Firm({
    required this.uid,
    required this.name,
    required this.mission,
    required this.budgetStart,
    required this.budgetEnd,
    required this.field,
    required this.firmImages,
    required this.creator,
    required this.creatorUid,
  });
  final String uid;
  final String name;
  final String mission;
  final String budgetStart;
  final String budgetEnd;
  final String field;
  final String firmImages;
  final String creator;
  final String creatorUid;
}
