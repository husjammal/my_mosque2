class AdminModel {
  String? id;
  String? username;
  String? email;
  String? password;
  String? phone;
  String? image;
  String? subGroup;
  String? myGroup;

  AdminModel(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.phone,
      this.image,
      this.subGroup,
      this.myGroup});

  AdminModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    image = json['image'];
    subGroup = json['subGroup'];
    myGroup = json['myGroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['subGroup'] = this.subGroup;
    data['myGroup'] = this.myGroup;
    return data;
  }
}
