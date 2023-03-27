class ScoreModel {
  String? usersId;
  String? day_number;
  String? score;
  String? duaaScore;
  String? prayScore;
  String? quranScore;

  ScoreModel(
      {this.usersId,
      this.day_number,
      this.score,
      this.duaaScore,
      this.prayScore,
      this.quranScore});

  ScoreModel.fromJson(Map<String, dynamic> json) {
    usersId = json['user_id'];
    day_number = json['day_number'];
    score = json['score'];
    duaaScore = json['duaaScore'];
    prayScore = json['prayScore'];
    quranScore = json['quranScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.usersId;
    data['day_number'] = this.day_number;
    data['score'] = this.score;
    data['duaaScore'] = this.duaaScore;
    data['prayScore'] = this.prayScore;
    data['quranScore'] = this.quranScore;
    return data;
  }
}