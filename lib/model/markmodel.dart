/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myMarkModelNode = MarkModel.fromJson(map);
*/
class MarkModel {
  String? subuh;
  String? zhur;
  String? asr;
  String? magrib;
  String? isyah;
  String? subuhSunah;
  String? zhurSunah;
  String? asrSunah;
  String? magribSunah;
  String? isyahSunah;
  String? watterSunah;
  String? duhhaNafel;
  String? tarawehNafel;
  String? keyamNafel;
  String? tahajoudNafel;
  String? quranRead;
  String? quranLearn;
  String? quranListen;
  String? actList;
  String? duaaScore;
  String? subGroup;
  String? myGroup;

  MarkModel(
      {this.subuh,
      this.zhur,
      this.asr,
      this.magrib,
      this.isyah,
      this.subuhSunah,
      this.zhurSunah,
      this.asrSunah,
      this.magribSunah,
      this.isyahSunah,
      this.watterSunah,
      this.duhhaNafel,
      this.tarawehNafel,
      this.keyamNafel,
      this.tahajoudNafel,
      this.quranRead,
      this.quranLearn,
      this.quranListen,
      this.actList,
      this.duaaScore,
      this.subGroup,
      this.myGroup});

  MarkModel.fromJson(Map<String, dynamic> json) {
    subuh = json['subuh'];
    zhur = json['zhur'];
    asr = json['asr'];
    magrib = json['magrib'];
    isyah = json['isyah'];
    subuhSunah = json['subuhSunah'];
    zhurSunah = json['zhurSunah'];
    asrSunah = json['asrSunah'];
    magribSunah = json['magribSunah'];
    isyahSunah = json['isyahSunah'];
    watterSunah = json['watterSunah'];
    duhhaNafel = json['duhhaNafel'];
    tarawehNafel = json['tarawehNafel'];
    keyamNafel = json['keyamNafel'];
    tahajoudNafel = json['tahajoudNafel'];
    quranRead = json['quranRead'];
    quranLearn = json['quranLearn'];
    quranListen = json['quranListen'];
    actList = json['actList'];
    duaaScore = json['duaaScore'];
    subGroup = json['subGroup'];
    myGroup = json['myGroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['subuh'] = subuh;
    data['zhur'] = zhur;
    data['asr'] = asr;
    data['magrib'] = magrib;
    data['isyah'] = isyah;
    data['subuhSunah'] = subuhSunah;
    data['zhurSunah'] = zhurSunah;
    data['asrSunah'] = asrSunah;
    data['magribSunah'] = magribSunah;
    data['isyahSunah'] = isyahSunah;
    data['watterSunah'] = watterSunah;
    data['duhhaNafel'] = duhhaNafel;
    data['tarawehNafel'] = tarawehNafel;
    data['keyamNafel'] = keyamNafel;
    data['tahajoudNafel'] = tahajoudNafel;
    data['quranRead'] = quranRead;
    data['quranLearn'] = quranLearn;
    data['quranListen'] = quranListen;
    data['actList'] = actList;
    data['duaaScore'] = duaaScore;
    data['subGroup'] = subGroup;
    data['myGroup'] = myGroup;
    return data;
  }
}
