class UserModel {
  String? usersId;
  String? usersName;
  String? usersEmail;
  String? usersPassword;
  String? usersPhone;
  String? usersImage;
  String? userJoinedAt;
  String? userFinalScore;
  String? userWeek;
  String? userTotalScore;
  String? userSubGroup;
  String? userMyGroup;
  String? userIsWeekChange;

  UserModel({
    this.usersId,
    this.usersName,
    this.usersEmail,
    this.usersImage,
    this.userJoinedAt,
    this.userFinalScore,
    this.userWeek,
    this.userTotalScore,
    this.userSubGroup,
    this.userMyGroup,
    this.userIsWeekChange,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    usersId = json['id'];
    usersName = json['username'];
    usersEmail = json['email'];
    usersPassword = json['password'];
    usersPhone = json['phone'];
    usersImage = json['image'];
    userJoinedAt = json['joinedAt'];
    userFinalScore = json['finalScore'];
    userWeek = json['week'];
    userTotalScore = json['totalScore'];
    userSubGroup = json['subGroup'];
    userMyGroup = json['myGroup'];
    userIsWeekChange = json['isWeekChange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.usersId;
    data['username'] = this.usersName;
    data['email'] = this.usersEmail;
    data['password'] = this.usersPassword;
    data['phone'] = this.usersPhone;
    data['image'] = this.usersImage;
    data['finalScore'] = this.userFinalScore;
    data['week'] = this.userWeek;
    data['totalScore'] = this.userTotalScore;
    data['subGroup'] = this.userSubGroup;
    data['myGroup'] = this.userMyGroup;
    data['isWeekChange'] = this.userIsWeekChange;

    return data;
  }
}
