class UserModel {
  String? usersId;
  String? usersName;
  String? usersEmail;
  String? usersPassword;
  String? usersPhone;
  String? usersImage;
  String? userScore;
  String? subGroup;
  String? myGroup;

  UserModel({
    this.usersId,
    this.usersName,
    this.usersEmail,
    this.usersImage,
    this.userScore,
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
    userScore = json['finalScore'];
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
    data['finalScore'] = this.userScore;
    data['subGroup'] = this.subGroup;
    data['myGroup'] = this.myGroup;
    return data;
  }
}
