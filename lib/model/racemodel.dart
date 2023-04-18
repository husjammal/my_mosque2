class RaceModel {
  String? id;
  String? title;
  String? description;
  String? mark;
  String? startDate;
  String? endDate;
  String? myGroup;
  String? subGroup;
  String? image;
  String? createdby;

  RaceModel(
      {this.id,
      this.title,
      this.description,
      this.mark,
      this.startDate,
      this.endDate,
      this.myGroup,
      this.subGroup,
      this.image,
      this.createdby});

  RaceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    mark = json['mark'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    myGroup = json['myGroup'];
    subGroup = json['subGroup'];
    image = json['image'];
    createdby = json['createdby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['mark'] = this.mark;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['myGroup'] = this.myGroup;
    data['subGroup'] = this.subGroup;
    data['image'] = this.image;
    data['createdby'] = this.createdby;
    return data;
  }
}
