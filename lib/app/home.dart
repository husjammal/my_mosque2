import 'package:flutter/material.dart';
import 'package:mymosque/app/pages/activity/activity.dart';
import 'package:mymosque/app/pages/duaa/duaa.dart';
import 'package:mymosque/app/pages/duaa/initialduaa.dart';
import 'package:mymosque/app/pages/pray/initialpray.dart';
import 'package:mymosque/app/pages/pray/pray.dart';
import 'package:mymosque/app/pages/quran/quran.dart';
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
  String? _TodayScore = "0";
  String? _FinalScore = "0";
  String? _TotalScore = "0";
  String _userWeek = "0";
  List<UserModel> userData = [];
  List userDataList = [];
  String? newTotalScore = "0";

  /// day and date
  String weekNumber = "0";
  var dt = DateTime.now();
  bool isLoading = false;

  getTodayScore() async {
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkViewNotes, {
      "user_id": sharedPref.getString("id"),
      "day_number": dt.weekday.toString()
    });
    _TodayScore = response['data'][0]['score'].toString();
    isLoading = false;
    setState(() {});
    return response;
  }

  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  final now = DateTime.now();

  getFinalScore() async {
    final firstJan = DateTime(now.year, 1, 1);
    weekNumber = (weeksBetween(firstJan, now)).toString();
    print("weekNumber $weekNumber");
    isLoading = true;
    setState(() {});
    var response1 = await postRequest(linkViewNotes,
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
      print('the response of total $_FinalScore');
      sharedPref.setString("finalScore", _FinalScore.toString());
      ////////////////

      var response = await postRequest(linkViewOneUser, {
        "id": sharedPref.getString("id"),
      });
      userDataList = response['data'] as List;
      userData = userDataList
          .map<UserModel>((json) => UserModel.fromJson(json))
          .toList();

      /// the rest of the week
      _userWeek = userData[0].userWeek.toString();
      if (int.parse(weekNumber.toString()) > int.parse(_userWeek.toString())) {
        print("delete the old week score");
        reset_val(sharedPref.getString("id")!);
        save_Week();
        print("init done");
      }

      //// the total score
      _TotalScore = userData[0].userTotalScore.toString();
      var oldFinalScore = userData[0].userFinalScore.toString();
      if (oldFinalScore == _FinalScore) {
        newTotalScore = _TotalScore;
      } else {
        newTotalScore = (int.parse(_TotalScore!) +
                int.parse(_FinalScore!) -
                int.parse(oldFinalScore))
            .toString();
      }
      sharedPref.setString("totalScore", newTotalScore!);
      isLoading = false;
      setState(() {});
      return response;
    } else {
      print("failed");
      return [];
    }
  }

  reset_val(String user_id) async {
    isLoading = true;
    setState(() {});

    var response = await postRequest(linkReset, {
      "user_id": user_id,
      "score": "0",
      "subuh": "0",
      "zhur": "0",
      "asr": "0",
      "magrib": "0",
      "isyah": "0",
      "quranRead": "0",
      "quranLearn": "0",
      "quranListen": "0",
      "duaaScore": "0",
      "prayScore": "0",
      "quranScore": "0",
      "activityScore": "0",
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
      "user_id": sharedPref.getString("id"),
      "finalScore": "0",
      "week": weekNumber.toString(),
      "totalScore": sharedPref.getString('totalScore'),
    });
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('home initState');
    getTodayScore();
    var dt = DateTime.now();
    //getOneUser();
    getFinalScore();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.0),
                    color: Colors.purple[300],
                  ),
                  child: isLoading
                      ? Text("تحميل ...")
                      : Text(
                          'مجموعك لليوم هو $_TodayScore الموافق ل ${dt.day}/${dt.month}/${dt.year} و مجموع الاسبوع هو $_FinalScore',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                ),
                Container(
                  child: Image.asset(
                    'images/logo.png',
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
                      color: Colors.yellow),
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
                            'images/praying.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onTap: (() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InitialPray()));
                        }),
                      ),
                      Text(
                        'صلاتي',
                        style:
                            TextStyle(fontSize: 22.0, color: Colors.grey[400]),
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
                            'images/quran.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onTap: (() {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Quran()));
                        }),
                      ),
                      Text(
                        'قرآني',
                        style:
                            TextStyle(fontSize: 22.0, color: Colors.grey[400]),
                      ),
                    ]),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
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
                          'images/ramadan.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: (() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Activity()));
                      }),
                    ),
                    Text(
                      'نشاطاتي',
                      style: TextStyle(fontSize: 22.0, color: Colors.grey[400]),
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
                          'images/muslim.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: (() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => InitialDuaa()));
                      }),
                    ),
                    Text(
                      'أذكاري',
                      style: TextStyle(fontSize: 22.0, color: Colors.grey[400]),
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
