class GroupModel {
  String? id;
  String? myGroup;
  String? subGroup;
  String? description;
  String? imageMosque;
  String? imagesubGroup;
  String? date;

  GroupModel(
      {this.id,
      this.myGroup,
      this.subGroup,
      this.description,
      this.imageMosque,
      this.imagesubGroup,
      this.date});

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    myGroup = json['myGroup'];
    subGroup = json['subGroup'];
    description = json['description'];
    imageMosque = json['imageMosque'];
    imagesubGroup = json['imagesubGroup'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['myGroup'] = this.myGroup;
    data['subGroup'] = this.subGroup;
    data['description'] = this.description;
    data['imageMosque'] = this.imageMosque;
    data['imagesubGroup'] = this.imagesubGroup;
    data['date'] = this.date;
    return data;
  }
}
