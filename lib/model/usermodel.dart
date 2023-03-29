class UserModel {
  String? usersId;
  String? usersName;
  String? usersEmail;
  String? usersPassword;
  String? usersPhone;
  String? usersImage;
  String? userFinalScore;
  String? userWeek;
  String? userTotalScore;
  String? subGroup;
  String? myGroup;

  UserModel({
    this.usersId,
    this.usersName,
    this.usersEmail,
    this.usersImage,
    this.userFinalScore,
    this.userWeek,
    this.userTotalScore,
    this.subGroup,
    this.myGroup,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    usersId = json['id'];
    usersName = json['username'];
    usersEmail = json['email'];
    usersPassword = json['password'];
    usersPhone = json['phone'];
    usersImage = json['image'];
    userFinalScore = json['finalScore'];
    userWeek = json['week'];
    userTotalScore = json['totalScore'];
    subGroup = json['subGroup'];
    myGroup = json['myGroup'];
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
    data['subGroup'] = this.subGroup;
    data['myGroup'] = this.myGroup;
    return data;
  }
}
