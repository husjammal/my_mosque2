class NoteModel {
  String? id;
  String? title;
  String? description;
  String? image;
  String? subGroup;
  String? myGroup;
  String? date;

  NoteModel(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.subGroup,
      this.myGroup,
      this.date});

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    subGroup = json['subGroup'];
    myGroup = json['myGroup'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['subGroup'] = this.subGroup;
    data['myGroup'] = this.myGroup;
    data['date'] = this.date;
    return data;
  }
}
