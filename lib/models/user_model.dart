class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;
  String? bio;
  DateTime? lastSeen;
  bool? isActive;
  bool? isTyping;
  String? gender;
  String? userType;

  UserModel(
      {this.uid,
      this.fullname,
      this.email,
      this.profilepic,
      this.bio,
      this.lastSeen,
      this.isActive,
      this.isTyping,
      this.gender,
      this.userType});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    profilepic = map["profilepic"];
    bio = map["bio"];
    lastSeen = map["lastseen"].toDate();
    isActive = map["isActive"];
    isTyping = map["isTyping"];
    gender = map["gender"];
    userType = map["userType"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "profilepic": profilepic,
      "bio": bio,
      "lastseen": lastSeen,
      "isActive": isActive,
      "isTyping": isTyping,
      "userType": userType,
      "gender": gender,
    };
  }
}
