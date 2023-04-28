import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/app/admin/QLearn/qlearningapp.dart';
import 'package:mymosque/app/admin/groups/grouphome.dart';
import 'package:mymosque/app/admin/marks/markhome.dart';
import 'package:mymosque/app/admin/notification/notehome.dart';
import 'package:mymosque/app/admin/users/initusers.dart';
import 'package:mymosque/app/admin/races/racehome.dart';

import 'package:mymosque/constant/colorConfig.dart';

import 'package:mymosque/main.dart';
import 'package:mymosque/model/usermodel.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String? user_name = sharedPref.getString("username");

  String? _userWeek;
  List<UserModel> userData = [];
  List userDataList = [];

  String weekNumber = "0";
  var dt = DateTime.now();
  bool isLoading = false;

  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('admin home initState');
    // dt = DateTime.now();
    // getFinalScore();
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
                  // getFinalScore();
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
          : Scaffold(
              appBar: AppBar(
                backgroundColor: buttonColor,
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      sharedPref.clear();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("login", (route) => false);
                    },
                    icon: Icon(Icons.exit_to_app),
                    tooltip: 'تسجيل خروج',
                  ),
                ],
                title: Text(
                  "مشرف جامعي",
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
                            fontSize: 18.0,
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
                                  'assets/images/adminMosques.png',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onTap: (() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Group()));
                              }),
                            ),
                            Text(
                              'المجموعات',
                              style:
                                  TextStyle(fontSize: 18.0, color: textColor),
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
                                  'assets/images/adminUsers.png',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onTap: (() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => InitUsers()));
                              }),
                            ),
                            Text(
                              'المستخدمين',
                              style:
                                  TextStyle(fontSize: 18.0, color: textColor),
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
                                    'assets/images/adminRaces.png',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: (() {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Race()));
                                }),
                              ),
                              Text(
                                'مسابقات',
                                style:
                                    TextStyle(fontSize: 18.0, color: textColor),
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
                                    'assets/images/adminNotes.png',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: (() {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Note()));
                                }),
                              ),
                              Text(
                                'اشعارات',
                                style:
                                    TextStyle(fontSize: 18.0, color: textColor),
                              ),
                            ]),
                          ]),
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
                                  'assets/images/adminMarks.png',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onTap: (() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SimpleTable()));
                              }),
                            ),
                            Text(
                              'وزن النقاط',
                              style:
                                  TextStyle(fontSize: 18.0, color: textColor),
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
                                  'assets/images/adminQLearn.png',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onTap: (() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => QLearnApp()));
                              }),
                            ),
                            Text(
                              'التسميع',
                              style:
                                  TextStyle(fontSize: 18.0, color: textColor),
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
              drawer: Drawer(
                backgroundColor: backgroundColor,

                // width: MediaQuery.of(context).size.width * 0.5,
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(color: buttonColor2),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            maxRadius: 40.0,
                            backgroundColor: backgroundColor,
                            backgroundImage: AssetImage(
                              'assets/images/ramadan.png',
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                sharedPref.getString("username").toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              Text(
                                sharedPref.getString("email").toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: const Text('المجموعات'),
                      onTap: () {
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             Activity()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.score),
                      title: const Text('المستخدمين'),
                      onTap: () {
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: const Text('ملفي'),
                      onTap: () {
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.local_activity),
                      title: const Text('مسابقات'),
                      onTap: () {
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: const Text('اشعارات'),
                      onTap: () {
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.list),
                      title: const Text('نتائج سابقة'),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "weekresult", (route) => false);
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: const Text('اعدادات التطبيق'),
                      onTap: () {
                        // Navigator.pop(context);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "setting", (route) => false);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help),
                      title: const Text('حول التطبيق'),
                      onTap: () {
                        // Navigator.pop(context);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "boarding", (route) => false);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.update),
                      title: const Text('تحديث التطبيق'),
                      onTap: () {
                        // Navigator.pop(context);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "version", (route) => false);
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                    ),
                    ListTile(
                      leading: Icon(Icons.info),
                      title: const Text('من نحن'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("about", (route) => false);
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: const Text('تسجيل خروج'),
                      onTap: () {
                        sharedPref.clear();
                        Navigator.pop(context);
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("login", (route) => false);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// getFinalScore() async {
//   final firstJan = DateTime(dt.year, 1, 1);
//   weekNumber = (weeksBetween(firstJan, dt)).toString();
//   print("weekNumber $weekNumber");
//   isLoading = true;
//   setState(() {});

//   var response = await postRequest(linkViewOneUser, {
//     "id": sharedPref.getString("id"),
//   });
//   userDataList = response['data'] as List;
//   userData = userDataList
//       .map<UserModel>((json) => UserModel.fromJson(json))
//       .toList();

//   /// the rest of the week//////////////////////////////////////////////////
//   _userWeek = userData[0].userWeek.toString();
//   if (int.parse(weekNumber.toString()) > int.parse(_userWeek.toString())) {
//     print("recorde the badges for the first three");
//     print("userDataList $userDataList");
//     print("userDate $userData");
//     save_badges();
//     print("delete the old week score");
//     reset_val();
//     save_Week();
//     print("init done");
//   }

//   /////////////////////////////////////////////////////////////////////////
//   ///check if ther is chane in finalScore ??
//   var response1 = await postRequest(linkViewNotes,
//       {"user_id": sharedPref.getString("id"), "day_number": "ALL"});
//   if (response1['status'] == "success") {
//     List totalScore = response1['data'];
//     _FinalScore = (int.parse(totalScore[0]['score']) +
//             int.parse(totalScore[1]['score']) +
//             int.parse(totalScore[2]['score']) +
//             int.parse(totalScore[3]['score']) +
//             int.parse(totalScore[4]['score']) +
//             int.parse(totalScore[5]['score']) +
//             int.parse(totalScore[6]['score']))
//         .toString();
//     _TodayScore = totalScore[dt.weekday - 1]['score'].toString();
//     print('the response of total $_FinalScore');
//     print('the response of _TodayScore $_TodayScore');
//     sharedPref.setString("finalScore", _FinalScore.toString());
//     /////////////////////////////////////////////////////////////////////
//     ///calc the other scores
//     _FinalprayScore = (int.parse(totalScore[0]['prayScore']) +
//             int.parse(totalScore[1]['prayScore']) +
//             int.parse(totalScore[2]['prayScore']) +
//             int.parse(totalScore[3]['prayScore']) +
//             int.parse(totalScore[4]['prayScore']) +
//             int.parse(totalScore[5]['prayScore']) +
//             int.parse(totalScore[6]['prayScore']))
//         .toString();
//     _FinalsunahScore = (int.parse(totalScore[0]['sunahScore']) +
//             int.parse(totalScore[1]['sunahScore']) +
//             int.parse(totalScore[2]['sunahScore']) +
//             int.parse(totalScore[3]['sunahScore']) +
//             int.parse(totalScore[4]['sunahScore']) +
//             int.parse(totalScore[5]['sunahScore']) +
//             int.parse(totalScore[6]['sunahScore']))
//         .toString();
//     _FinalnuafelScore = (int.parse(totalScore[0]['nuafelScore']) +
//             int.parse(totalScore[1]['nuafelScore']) +
//             int.parse(totalScore[2]['nuafelScore']) +
//             int.parse(totalScore[3]['nuafelScore']) +
//             int.parse(totalScore[4]['nuafelScore']) +
//             int.parse(totalScore[5]['nuafelScore']) +
//             int.parse(totalScore[6]['nuafelScore']))
//         .toString();
//     _FinalquranScore = (int.parse(totalScore[0]['quranScore']) +
//             int.parse(totalScore[1]['quranScore']) +
//             int.parse(totalScore[2]['quranScore']) +
//             int.parse(totalScore[3]['quranScore']) +
//             int.parse(totalScore[4]['quranScore']) +
//             int.parse(totalScore[5]['quranScore']) +
//             int.parse(totalScore[6]['quranScore']))
//         .toString();
//     _FinalactivityScore = (int.parse(totalScore[0]['activityScore']) +
//             int.parse(totalScore[1]['activityScore']) +
//             int.parse(totalScore[2]['activityScore']) +
//             int.parse(totalScore[3]['activityScore']) +
//             int.parse(totalScore[4]['activityScore']) +
//             int.parse(totalScore[5]['activityScore']) +
//             int.parse(totalScore[6]['activityScore']))
//         .toString();
//     /////////////////////////////////////////////////////////////////////
//     //// the total score
//     _TotalScore = userData[0].userTotalScore.toString();
//     var oldFinalScore = userData[0].userfinalScore.toString();
//     if (oldFinalScore == _FinalScore) {
//       newTotalScore = _TotalScore;
//       sharedPref.setString("totalScore", newTotalScore!);
//     } else {
//       newTotalScore = (int.parse(_TotalScore!) +
//               int.parse(_FinalScore!) -
//               int.parse(oldFinalScore))
//           .toString();
//       sharedPref.setString("totalScore", newTotalScore!);
//       save_TotalScore();
//       save_weekly();
//     }

//     isLoading = false;
//     setState(() {});
//     return response;
//   } else {
//     print("failed");
//     return [];
//   }
// }

// save_TotalScore() async {
//   // calculate the total score
//   // save the database
//   isLoading = true;
//   setState(() {});
//   var response = await postRequest(linkScoreUsers, {
//     "user_id": sharedPref.getString("id"),
//     "finalScore": sharedPref.getString('finalScore'),
//     "totalScore": sharedPref.getString('totalScore'),
//     "finalprayScore": _FinalprayScore,
//     "finalsunahScore": _FinalsunahScore,
//     "finalnuafelScore": _FinalnuafelScore,
//     "finalquranScore": _FinalquranScore,
//     "finalactivityScore": _FinalactivityScore,
//   });
//   isLoading = false;
//   setState(() {});
// }

// save_weekly() async {
//   // save the finalScore in weekly
//   // save the database
//   isLoading = true;
//   setState(() {});
//   var response = await postRequest(linkWeekly, {
//     "user_id": sharedPref.getString("id"),
//     "weekNum": weekNumber.toString(),
//     "score": sharedPref.getString('finalScore'),
//   });
//   isLoading = false;
//   setState(() {});
// }

// reset_val() async {
//   isLoading = true;
//   setState(() {});

//   var response = await postRequest(linkReset, {
//     "score": "0",
//     "subuh": "0",
//     "zhur": "0",
//     "asr": "0",
//     "magrib": "0",
//     "isyah": "0",
//     "subuhSunah": "0",
//     "zhurSunah": "0",
//     "asrSunah": "0",
//     "magribSunah": "0",
//     "isyahSunah": "0",
//     "watterSunah": "0",
//     "duhhaNafel": "0",
//     "tarawehNafel": "0",
//     "keyamNafel": "0",
//     "tahajoudNafel": "0",
//     "actList": "0,0,0,0,0,0,0",
//     "quranRead": "0",
//     "quranLearn": "0",
//     "quranListen": "0",
//     "duaaScore": "0",
//     "prayScore": "0",
//     "quranScore": "0",
//     "sunahScore": "0",
//     "nuafelScore": "0",
//     "activityScore": "0",
//   });
//   isLoading = false;
//   setState(() {});
//   if (response['status'] == "success") {
//     // close sign up
//     print("init success");
//   } else {
//     print("init Fail");
//   }
// }

// save_Week() async {
//   // calculate the total score

//   // save the database
//   isLoading = true;
//   setState(() {});
//   var response = await postRequest(linkWeek, {
//     "finalScore": "0",
//     "finalprayScore": "0",
//     "finalsunahScore": "0",
//     "finalnuafelScore": "0",
//     "finalquranScore": "0",
//     "finalactivityScore": "0",
//     "week": weekNumber.toString(),
//     "isWeekChange": "1"
//   });
//   isLoading = false;
//   setState(() {});
// }

// save_badges() async {
//   // all users
//   var response4 = await postRequest(linkViewUsers, {
//     "myGroup": sharedPref.getString("myGroup"),
//   });
//   var userDataList4 = response4['data'] as List;
//   var userData4 = userDataList4
//       .map<UserModel>((json) => UserModel.fromJson(json))
//       .toList();

//   userData4.sort((a, b) {
//     int cmp =
//         int.parse(b.userfinalScore!).compareTo(int.parse(a.userfinalScore!));
//     if (cmp != 0) return cmp;
//     return int.parse(b.userTotalScore!)
//         .compareTo(int.parse(a.userTotalScore!));
//   });
//   var firstfinalBadgeID = userData4[0].usersId;
//   var secondfinalBadgeID = userData4[1].usersId;
//   var thriedfinalBadgeID = userData4[2].usersId;
//   var firstnumBadge = (int.parse(userData4[0].usernumBadge!) + 1).toString();
//   var secondnumBadge = (int.parse(userData4[1].usernumBadge!) + 1).toString();
//   var thriednumBadge = (int.parse(userData4[2].usernumBadge!) + 1).toString();
//   print(
//       "badge $firstfinalBadgeID , $secondfinalBadgeID, $thriedfinalBadgeID");

//   userData4.sort((a, b) {
//     int cmp = int.parse(b.userfinalquranScore!)
//         .compareTo(int.parse(a.userfinalquranScore!));
//     if (cmp != 0) return cmp;
//     return int.parse(b.userTotalScore!)
//         .compareTo(int.parse(a.userTotalScore!));
//   });
//   var firstquranBadgeID = userData4[0].usersId;
//   var secondquranBadgeID = userData4[1].usersId;
//   var thriedquranBadgeID = userData4[2].usersId;
//   var firstnumquranBadge =
//       (int.parse(userData4[0].usernumquranBadge!) + 1).toString();
//   var secondnumquranBadge =
//       (int.parse(userData4[1].usernumquranBadge!) + 1).toString();
//   var thriednumquranBadge =
//       (int.parse(userData4[2].usernumquranBadge!) + 1).toString();

//   userData4.sort((a, b) {
//     int cmp = int.parse(b.userfinalprayScore!)
//         .compareTo(int.parse(a.userfinalprayScore!));
//     if (cmp != 0) return cmp;
//     return int.parse(b.userTotalScore!)
//         .compareTo(int.parse(a.userTotalScore!));
//   });
//   var firstprayBadgeID = userData4[0].usersId;
//   var secondprayBadgeID = userData4[1].usersId;
//   var thriedprayBadgeID = userData4[2].usersId;
//   var firstnumprayBadge =
//       (int.parse(userData4[0].usernumprayBadge!) + 1).toString();
//   var secondnumprayBadge =
//       (int.parse(userData4[1].usernumprayBadge!) + 1).toString();
//   var thriednumprayBadge =
//       (int.parse(userData4[2].usernumprayBadge!) + 1).toString();
//   // save the database
//   isLoading = true;
//   setState(() {});
//   var response3 = await postRequest(linkBadge, {
//     "firstfinalBadgeID": firstfinalBadgeID.toString(),
//     "secondfinalBadgeID": secondfinalBadgeID.toString(),
//     "thriedfinalBadgeID": thriedfinalBadgeID.toString(),
//     "firstquranBadgeID": firstquranBadgeID.toString(),
//     "secondquranBadgeID": secondquranBadgeID.toString(),
//     "thriedquranBadgeID": thriedquranBadgeID.toString(),
//     "firstprayBadgeID": firstprayBadgeID.toString(),
//     "secondprayBadgeID": secondprayBadgeID.toString(),
//     "thriedprayBadgeID": thriedprayBadgeID.toString(),
//     ///////////
//     "firstnumBadge": firstnumBadge.toString(),
//     "secondnumBadge": secondnumBadge.toString(),
//     "thriednumBadge": thriednumBadge.toString(),
//     "firstnumquranBadge": firstnumquranBadge.toString(),
//     "secondnumquranBadge": secondnumquranBadge.toString(),
//     "thriednumquranBadge": thriednumquranBadge.toString(),
//     "firstnumprayBadge": firstnumprayBadge.toString(),
//     "secondnumprayBadge": secondnumprayBadge.toString(),
//     "thriednumprayBadge": thriednumprayBadge.toString(),
//   });
//   isLoading = false;
//   setState(() {});
//   // print("response3 $response3");
// }
