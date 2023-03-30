class ScoreModel {
  String? usersId;
  String? dayNumber;
  String? score;
  String? duaaScore;
  String? prayScore;
  String? quranScore;
  String? activityScore;

  ScoreModel({
    this.usersId,
    this.dayNumber,
    this.score,
    this.duaaScore,
    this.prayScore,
    this.quranScore,
    this.activityScore,
  });

  ScoreModel.fromJson(Map<String, dynamic> json) {
    usersId = json['user_id'];
    dayNumber = json['day_number'];
    score = json['score'];
    duaaScore = json['duaaScore'];
    prayScore = json['prayScore'];
    quranScore = json['quranScore'];
    activityScore = json['activityScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.usersId;
    data['day_number'] = this.dayNumber;
    data['score'] = this.score;
    data['duaaScore'] = this.duaaScore;
    data['prayScore'] = this.prayScore;
    data['quranScore'] = this.quranScore;
    data['activityScore'] = this.activityScore;
    return data;
  }
}
