class UserModel {
  String? usersId;
  String? usersName;
  String? usersEmail;
  String? usersPassword;
  String? usersPhone;
  String? usersImage;
  String? userJoinedAt;
  String? userfinalScore;
  String? userfinalprayScore;
  String? userfinalsunahScore;
  String? userfinalnuafelScore;
  String? userfinalquranScore;
  String? userfinalactivityScore;
  String? userWeek;
  String? userTotalScore;
  String? userSubGroup;
  String? userMyGroup;
  String? userIsWeekChange;
  String? userbadge;
  String? userpraybadge;
  String? userquranbadge;
  String? usernumBadge;
  String? usernumprayBadge;
  String? usernumquranBadge;

  UserModel({
    this.usersId,
    this.usersName,
    this.usersEmail,
    this.usersImage,
    this.userJoinedAt,
    this.userfinalScore,
    this.userfinalprayScore,
    this.userfinalsunahScore,
    this.userfinalnuafelScore,
    this.userfinalquranScore,
    this.userfinalactivityScore,
    this.userWeek,
    this.userTotalScore,
    this.userSubGroup,
    this.userMyGroup,
    this.userIsWeekChange,
    this.userbadge,
    this.userpraybadge,
    this.userquranbadge,
    this.usernumBadge,
    this.usernumprayBadge,
    this.usernumquranBadge,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    usersId = json['id'];
    usersName = json['username'];
    usersEmail = json['email'];
    usersPassword = json['password'];
    usersPhone = json['phone'];
    usersImage = json['image'];
    userJoinedAt = json['joinedAt'];
    userfinalScore = json['finalScore'];
    userfinalprayScore = json['finalprayScore'];
    userfinalsunahScore = json['finalsunahScore'];
    userfinalnuafelScore = json['finalnuafelScore'];
    userfinalquranScore = json['finalquranScore'];
    userfinalactivityScore = json['finalactivityScore'];
    userWeek = json['week'];
    userTotalScore = json['totalScore'];
    userSubGroup = json['subGroup'];
    userMyGroup = json['myGroup'];
    userIsWeekChange = json['isWeekChange'];
    userbadge = json['badge'];
    userpraybadge = json['praybadge'];
    userquranbadge = json['quranbadge'];
    usernumBadge = json['numBadge'];
    usernumprayBadge = json['numprayBadge'];
    usernumquranBadge = json['numquranBadge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.usersId;
    data['username'] = this.usersName;
    data['email'] = this.usersEmail;
    data['password'] = this.usersPassword;
    data['phone'] = this.usersPhone;
    data['image'] = this.usersImage;
    data['finalScore'] = this.userfinalScore;
    data['finalprayScore'] = this.userfinalprayScore;
    data['finalsunahScore'] = this.userfinalsunahScore;
    data['finalnuafelScore'] = this.userfinalnuafelScore;
    data['finalquranScore'] = this.userfinalquranScore;
    data['finalactivityScore'] = this.userfinalactivityScore;
    data['week'] = this.userWeek;
    data['totalScore'] = this.userTotalScore;
    data['subGroup'] = this.userSubGroup;
    data['myGroup'] = this.userMyGroup;
    data['isWeekChange'] = this.userIsWeekChange;
    data['badge'] = this.userbadge;
    data['praybadge'] = this.userpraybadge;
    data['quranbadge'] = this.userquranbadge;
    data['numBadge'] = this.usernumBadge;
    data['numprayBadge'] = this.usernumprayBadge;
    data['numquranBadge'] = this.usernumquranBadge;
    return data;
  }
}
