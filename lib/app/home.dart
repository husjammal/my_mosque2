import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/app/pages/activity/activity.dart';
import 'package:mymosque/app/pages/duaa/initialduaa.dart';
import 'package:mymosque/app/pages/pray/initialpray.dart';
import 'package:mymosque/app/pages/quran/quran.dart';
import 'package:mymosque/app/weekresult.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/usermodel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? user_name = sharedPref.getString("username");

  String? user_subGroup = sharedPref.getString("subGroup");
  String? user_myGroup = sharedPref.getString("myGroup");

  String? _TodayScore = "0";
  String? _FinalScore = "0";
  String? _FinalprayScore = "0";
  String? _FinalsunahScore = "0";
  String? _FinalnuafelScore = "0";
  String? _FinalquranScore = "0";
  String? _FinalactivityScore = "0";

  String? _TotalScore;
  String? _userWeek;
  List<UserModel> userData = [];
  List userDataList = [];
  String? newTotalScore;
  String weekNumber = "0";
  var dt = DateTime.now();
  bool isLoading = false;

  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  getFinalScore() async {
    final firstJan = DateTime(dt.year, 1, 1);
    weekNumber = (weeksBetween(firstJan, dt)).toString();
    print("weekNumber $weekNumber");
    isLoading = true;
    setState(() {});

    var response = await postRequest(linkViewOneUser, {
      "id": sharedPref.getString("id"),
    });
    userDataList = response['data'] as List;
    userData = userDataList
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();

    /// the rest of the week//////////////////////////////////////////////////
    _userWeek = userData[0].userWeek.toString();
    if (int.parse(weekNumber.toString()) > int.parse(_userWeek.toString())) {
      print("recorde the badges for the first three");
      print("userDataList $userDataList");
      print("userDate $userData");
      save_badges();
      print("delete the old week score");
      reset_val();
      save_Week();
      print("init done");
    }

    /////////////////////////////////////////////////////////////////////////
    ///check if ther is chane in finalScore ??
    var response1 = await postRequest(linkViewActions,
        {"user_id": sharedPref.getString("id"), "day_number": "ALL"});
    if (response1['status'] == "success") {
      List totalScore = response1['data'];
      _FinalScore = (int.parse(totalScore[0]['score']) +
              int.parse(totalScore[1]['score']) +
              int.parse(totalScore[2]['score']) +
              int.parse(totalScore[3]['score']) +
              int.parse(totalScore[4]['score']) +
              int.parse(totalScore[5]['score']) +
              int.parse(totalScore[6]['score']))
          .toString();
      _TodayScore = totalScore[dt.weekday - 1]['score'].toString();
      print('the response of total $_FinalScore');
      print('the response of _TodayScore $_TodayScore');
      sharedPref.setString("finalScore", _FinalScore.toString());
      /////////////////////////////////////////////////////////////////////
      ///calc the other scores
      _FinalprayScore = (int.parse(totalScore[0]['prayScore']) +
              int.parse(totalScore[1]['prayScore']) +
              int.parse(totalScore[2]['prayScore']) +
              int.parse(totalScore[3]['prayScore']) +
              int.parse(totalScore[4]['prayScore']) +
              int.parse(totalScore[5]['prayScore']) +
              int.parse(totalScore[6]['prayScore']))
          .toString();
      _FinalsunahScore = (int.parse(totalScore[0]['sunahScore']) +
              int.parse(totalScore[1]['sunahScore']) +
              int.parse(totalScore[2]['sunahScore']) +
              int.parse(totalScore[3]['sunahScore']) +
              int.parse(totalScore[4]['sunahScore']) +
              int.parse(totalScore[5]['sunahScore']) +
              int.parse(totalScore[6]['sunahScore']))
          .toString();
      _FinalnuafelScore = (int.parse(totalScore[0]['nuafelScore']) +
              int.parse(totalScore[1]['nuafelScore']) +
              int.parse(totalScore[2]['nuafelScore']) +
              int.parse(totalScore[3]['nuafelScore']) +
              int.parse(totalScore[4]['nuafelScore']) +
              int.parse(totalScore[5]['nuafelScore']) +
              int.parse(totalScore[6]['nuafelScore']))
          .toString();
      _FinalquranScore = (int.parse(totalScore[0]['quranLearn_app']) +
              int.parse(totalScore[1]['quranLearn_app']) +
              int.parse(totalScore[2]['quranLearn_app']) +
              int.parse(totalScore[3]['quranLearn_app']) +
              int.parse(totalScore[4]['quranLearn_app']) +
              int.parse(totalScore[5]['quranLearn_app']) +
              int.parse(totalScore[6]['quranLearn_app']))
          .toString();
      _FinalactivityScore = (int.parse(totalScore[0]['activityScore']) +
              int.parse(totalScore[1]['activityScore']) +
              int.parse(totalScore[2]['activityScore']) +
              int.parse(totalScore[3]['activityScore']) +
              int.parse(totalScore[4]['activityScore']) +
              int.parse(totalScore[5]['activityScore']) +
              int.parse(totalScore[6]['activityScore']))
          .toString();
      /////////////////////////////////////////////////////////////////////
      //// the total score
      _TotalScore = userData[0].userTotalScore.toString();
      var oldFinalScore = userData[0].userfinalScore.toString();
      if (oldFinalScore == _FinalScore) {
        newTotalScore = _TotalScore;
        sharedPref.setString("totalScore", newTotalScore!);
        save_TotalScore();
        save_weekly();
      } else {
        newTotalScore = (int.parse(_TotalScore!) +
                int.parse(_FinalScore!) -
                int.parse(oldFinalScore))
            .toString();
        sharedPref.setString("totalScore", newTotalScore!);
        save_TotalScore();
        save_weekly();
      }

      isLoading = false;
      setState(() {});
      return response;
    } else {
      print("failed");
      return [];
    }
  }

  save_TotalScore() async {
    // calculate the total score
    // save the database
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkScoreUsers, {
      "user_id": sharedPref.getString("id"),
      "finalScore": sharedPref.getString('finalScore'),
      "totalScore": sharedPref.getString('totalScore'),
      "finalprayScore": _FinalprayScore,
      "finalsunahScore": _FinalsunahScore,
      "finalnuafelScore": _FinalnuafelScore,
      "finalquranScore": _FinalquranScore,
      "finalactivityScore": _FinalactivityScore,
    });
    isLoading = false;
    setState(() {});
    return response;
  }

  save_weekly() async {
    // save the finalScore in weekly
    // save the database
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkWeekly, {
      "user_id": sharedPref.getString("id"),
      "weekNum": weekNumber.toString(),
      "score": sharedPref.getString('finalScore'),
    });
    isLoading = false;
    setState(() {});
  }

  reset_val() async {
    isLoading = true;
    setState(() {});

    var response = await postRequest(linkReset, {
      "score": "0",
      "subuh": "0",
      "zhur": "0",
      "asr": "0",
      "magrib": "0",
      "isyah": "0",
      "subuhSunah": "0",
      "zhurSunah": "0",
      "asrSunah": "0",
      "magribSunah": "0",
      "isyahSunah": "0",
      "watterSunah": "0",
      "duhhaNafel": "0",
      "tarawehNafel": "0",
      "keyamNafel": "0",
      "tahajoudNafel": "0",
      "actList": "0,0,0,0,0,0,0",
      "quranRead": "0",
      "quranLearn": "0",
      "quranLearn_app": "0",
      "quranListen": "0",
      "duaaScore": "0",
      "prayScore": "0",
      "quranScore": "0",
      "sunahScore": "0",
      "nuafelScore": "0",
      "activityScore": "0",
      "subGroup": user_subGroup,
      "myGroup": user_myGroup
    });
    isLoading = false;
    setState(() {});
    if (response['status'] == "success") {
      // close sign up
      print("init success");
    } else {
      print("init Fail");
    }
  }

  save_Week() async {
    // calculate the total score

    // save the database
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkWeek, {
      "finalScore": "0",
      "finalprayScore": "0",
      "finalsunahScore": "0",
      "finalnuafelScore": "0",
      "finalquranScore": "0",
      "finalactivityScore": "0",
      "week": weekNumber.toString(),
      "isWeekChange": "1",
      "subGroup": user_subGroup,
      "myGroup": user_myGroup
    });
    isLoading = false;
    setState(() {});
    return response;
  }

  save_badges() async {
    // all users
    var response4 = await postRequest(linkViewUsers, {
      "subGroup": sharedPref.getString("subGroup"),
      "myGroup": sharedPref.getString("myGroup"),
    });
    var userDataList4 = response4['data'] as List;
    var userData4 = userDataList4
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();

    userData4.sort((a, b) {
      int cmp =
          int.parse(b.userfinalScore!).compareTo(int.parse(a.userfinalScore!));
      if (cmp != 0) return cmp;
      return int.parse(b.userTotalScore!)
          .compareTo(int.parse(a.userTotalScore!));
    });
    var firstfinalBadgeID = userData4[0].usersId;
    var secondfinalBadgeID = userData4[1].usersId;
    var thriedfinalBadgeID = userData4[2].usersId;
    var firstnumBadge = (int.parse(userData4[0].usernumBadge!) + 1).toString();
    var secondnumBadge = (int.parse(userData4[1].usernumBadge!) + 1).toString();
    var thriednumBadge = (int.parse(userData4[2].usernumBadge!) + 1).toString();
    print(
        "badge $firstfinalBadgeID , $secondfinalBadgeID, $thriedfinalBadgeID");

    userData4.sort((a, b) {
      int cmp = int.parse(b.userfinalquranScore!)
          .compareTo(int.parse(a.userfinalquranScore!));
      if (cmp != 0) return cmp;
      return int.parse(b.userTotalScore!)
          .compareTo(int.parse(a.userTotalScore!));
    });
    var firstquranBadgeID = userData4[0].usersId;
    var secondquranBadgeID = userData4[1].usersId;
    var thriedquranBadgeID = userData4[2].usersId;
    var firstnumquranBadge =
        (int.parse(userData4[0].usernumquranBadge!) + 1).toString();
    var secondnumquranBadge =
        (int.parse(userData4[1].usernumquranBadge!) + 1).toString();
    var thriednumquranBadge =
        (int.parse(userData4[2].usernumquranBadge!) + 1).toString();

    userData4.sort((a, b) {
      int cmp = int.parse(b.userfinalprayScore!)
          .compareTo(int.parse(a.userfinalprayScore!));
      if (cmp != 0) return cmp;
      return int.parse(b.userTotalScore!)
          .compareTo(int.parse(a.userTotalScore!));
    });
    var firstprayBadgeID = userData4[0].usersId;
    var secondprayBadgeID = userData4[1].usersId;
    var thriedprayBadgeID = userData4[2].usersId;
    var firstnumprayBadge =
        (int.parse(userData4[0].usernumprayBadge!) + 1).toString();
    var secondnumprayBadge =
        (int.parse(userData4[1].usernumprayBadge!) + 1).toString();
    var thriednumprayBadge =
        (int.parse(userData4[2].usernumprayBadge!) + 1).toString();
    // save the database
    isLoading = true;
    setState(() {});
    var response3 = await postRequest(linkBadge, {
      "firstfinalBadgeID": firstfinalBadgeID.toString(),
      "secondfinalBadgeID": secondfinalBadgeID.toString(),
      "thriedfinalBadgeID": thriedfinalBadgeID.toString(),
      "firstquranBadgeID": firstquranBadgeID.toString(),
      "secondquranBadgeID": secondquranBadgeID.toString(),
      "thriedquranBadgeID": thriedquranBadgeID.toString(),
      "firstprayBadgeID": firstprayBadgeID.toString(),
      "secondprayBadgeID": secondprayBadgeID.toString(),
      "thriedprayBadgeID": thriedprayBadgeID.toString(),
      ///////////
      "firstnumBadge": firstnumBadge.toString(),
      "secondnumBadge": secondnumBadge.toString(),
      "thriednumBadge": thriednumBadge.toString(),
      "firstnumquranBadge": firstnumquranBadge.toString(),
      "secondnumquranBadge": secondnumquranBadge.toString(),
      "thriednumquranBadge": thriednumquranBadge.toString(),
      "firstnumprayBadge": firstnumprayBadge.toString(),
      "secondnumprayBadge": secondnumprayBadge.toString(),
      "thriednumprayBadge": thriednumprayBadge.toString(),
      /////
      "subGroup": user_subGroup,
      "myGroup": user_myGroup,
    });
    isLoading = false;
    setState(() {});
    // print("response3 $response3");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('home initState');
    dt = DateTime.now();
    getFinalScore();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: isLoading
          ? Scaffold(
              backgroundColor: backgroundColor,
              body: InkWell(
                onTap: () {
                  getFinalScore();
                },
                child: Center(
                  child: Lottie.asset(
                    'assets/lottie/60089-eid-mubarak.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
          : userData[0].userIsWeekChange == "1"
              ? WeekResult()
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: buttonColor2,
                    actions: const [],
                    toolbarHeight: 70,
                    title: Container(
                      // padding: EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: isLoading
                          ? Text(
                              "تحميل ...",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: textColor2),
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'مجموعك لليوم ${dt.day}/${dt.month}/${dt.year}   ',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: textColor2),
                                    ),
                                    Icon(Icons.star),
                                    Text(
                                      '$_TodayScore',
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: buttonColor),
                                    ),
                                    Icon(Icons.star),
                                  ],
                                ),
                                Text(
                                  'و مجموع الاسبوع  $_FinalScore',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: textColor),
                                ),
                              ],
                            ),
                    ),
                  ),
                  backgroundColor: backgroundColor,
                  body: SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 200,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            'السلام عليكم يا ${sharedPref.getString("username")} ! ',
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: textColor2),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(children: <Widget>[
                                InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      color: buttonColor,
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: const Offset(
                                            3.0,
                                            3.0,
                                          ), //Offset
                                          blurRadius: 10.0,
                                          spreadRadius: 2.0,
                                        ), //BoxShadow
                                        BoxShadow(
                                          color: Colors.white,
                                          offset: const Offset(0.0, 0.0),
                                          blurRadius: 0.0,
                                          spreadRadius: 0.0,
                                        ), //BoxShadow
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/images/praying.png',
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onTap: (() {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InitialPray()));
                                  }),
                                ),
                                Text(
                                  'صلاتي',
                                  style: TextStyle(
                                      fontSize: 22.0, color: textColor),
                                ),
                              ]),
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(children: <Widget>[
                                InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      color: buttonColor,
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: const Offset(
                                            3.0,
                                            3.0,
                                          ), //Offset
                                          blurRadius: 10.0,
                                          spreadRadius: 2.0,
                                        ), //BoxShadow
                                        BoxShadow(
                                          color: Colors.white,
                                          offset: const Offset(0.0, 0.0),
                                          blurRadius: 0.0,
                                          spreadRadius: 0.0,
                                        ), //BoxShadow
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/images/quran.png',
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onTap: (() {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Quran()));
                                  }),
                                ),
                                Text(
                                  'قرآني',
                                  style: TextStyle(
                                      fontSize: 22.0, color: textColor),
                                ),
                              ]),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(children: <Widget>[
                                  InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                            offset: const Offset(
                                              3.0,
                                              3.0,
                                            ), //Offset
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          ), //BoxShadow
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: const Offset(0.0, 0.0),
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                          ), //BoxShadow
                                        ],
                                      ),
                                      child: Image.asset(
                                        'assets/images/ramadan.png',
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    onTap: (() {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Activity()));
                                    }),
                                  ),
                                  Text(
                                    'نشاطاتي',
                                    style: TextStyle(
                                        fontSize: 22.0, color: textColor),
                                  ),
                                ]),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Column(children: <Widget>[
                                  InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                            offset: const Offset(
                                              3.0,
                                              3.0,
                                            ), //Offset
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                          ), //BoxShadow
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: const Offset(0.0, 0.0),
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                          ), //BoxShadow
                                        ],
                                      ),
                                      child: Image.asset(
                                        'assets/images/muslim.png',
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    onTap: (() {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InitialDuaa()));
                                    }),
                                  ),
                                  Text(
                                    'أذكاري',
                                    style: TextStyle(
                                        fontSize: 22.0, color: textColor),
                                  ),
                                ]),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
