import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mymosque/app/pages/activity/activity.dart';
import 'package:mymosque/app/pages/duaa/duaa.dart';
import 'package:mymosque/app/pages/pray/pray.dart';
import 'package:mymosque/app/pages/quran/quran.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:marquee/marquee.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? user_name = sharedPref.getString("username");
  String? _TodayScore = "0";
  String? _TotalScore = "0";

  /// day and date
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

  getTotalScore() async {
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkViewNotes,
        {"user_id": sharedPref.getString("id"), "day_number": "ALL"});
    List totalScore = response['data'];
    _TotalScore = (int.parse(totalScore[0]['score']) +
            int.parse(totalScore[1]['score']) +
            int.parse(totalScore[2]['score']) +
            int.parse(totalScore[3]['score']) +
            int.parse(totalScore[4]['score']) +
            int.parse(totalScore[5]['score']) +
            int.parse(totalScore[6]['score']))
        .toString();
    print('the response of total $_TotalScore');
    sharedPref.setString("finalScore", _TotalScore.toString());
    isLoading = false;
    setState(() {});
    return response;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('home initState');
    getTodayScore();
    var dt = DateTime.now();
    getTotalScore();
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
                          'مجموعك لليوم هو $_TodayScore الموافق ل ${dt.day}/${dt.month}/${dt.year} و مجموع الاسبوع هو $_TotalScore',
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
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Pray()));
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
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Duaa()));
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
