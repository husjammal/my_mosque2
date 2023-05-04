//2. Create a model class to hold the data:

class MosqueData {
  final String? id;
  final String? subuh;
  final String? zhur;
  final String? asr;
  final String? magrib;
  final String? isyah;
  final String? subuhsunah;
  final String? zhursunah;
  final String? asrsunah;
  final String? magribsunah;
  final String? isyahsunah;
  final String? wattersunah;
  final String? duhhanafel;
  final String? tarawehnafel;
  final String? keyamnafel;
  final String? tahajoudnafel;
  final String? quranread;
  final String? quranlearn;
  final String? quranlisten;
  final String? actlist;
  final String? duaascore;
  final String? subgroup;
  final String? mygroup;

  MosqueData({
    this.id,
    this.subuh,
    this.zhur,
    this.asr,
    this.magrib,
    this.isyah,
    this.subuhsunah,
    this.zhursunah,
    this.asrsunah,
    this.magribsunah,
    this.isyahsunah,
    this.wattersunah,
    this.duhhanafel,
    this.tarawehnafel,
    this.keyamnafel,
    this.tahajoudnafel,
    this.quranread,
    this.quranlearn,
    this.quranlisten,
    this.actlist,
    this.duaascore,
    this.subgroup,
    this.mygroup,
  });

  factory MosqueData.fromJson(Map<String?, dynamic> json) {
    return MosqueData(
      id: json['id'],
      subuh: json['subuh'],
      zhur: json['zhur'],
      asr: json['asr'],
      magrib: json['magrib'],
      isyah: json['isyah'],
      subuhsunah: json['subuhsunah'],
      zhursunah: json['zhursunah'],
      asrsunah: json['asrsunah'],
      magribsunah: json['magribsunah'],
      isyahsunah: json['isyahsunah'],
      wattersunah: json['wattersunah'],
      duhhanafel: json['duhhanafel'],
      tarawehnafel: json['tarawehnafel'],
      keyamnafel: json['keyamnafel'],
      tahajoudnafel: json['tahajoudnafel'],
      quranread: json['quranread'],
      quranlearn: json['quranlearn'],
      quranlisten: json['quranlisten'],
      actlist: json['actlist'],
      duaascore: json['duaascore'],
      subgroup: json['subgroup'],
      mygroup: json['mygroup'],
    );
  }
}
