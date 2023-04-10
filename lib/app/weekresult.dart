import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/usermodel.dart';

class WeekResult extends StatefulWidget {
  const WeekResult({Key? key}) : super(key: key);
  _WeekResultState createState() => _WeekResultState();
}

class _WeekResultState extends State<WeekResult> {
  bool isLoading = false;

  rest_isWeeklyChange() async {
    // calculate the total score
    // save the database
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkIsWeekChange, {
      "user_id": sharedPref.getString("id"),
    });
    isLoading = false;
    setState(() {});
  }

  List userBadge1 = [];
  List userBadge2 = [];
  List userBadge3 = [];
  String weekNumber = "0";
  getBadge() async {
    final firstJan = DateTime(dt.year, 1, 1);
    weekNumber = (weeksBetween(firstJan, dt)).toString();
    isLoading = true;
    setState(() {});
    var response1 = await postRequest(linkViewBadge, {"badge": "1"});
    var userDataBadge1List = response1['data'] as List;
    userBadge1 = userDataBadge1List
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    var response2 = await postRequest(linkViewBadge, {"badge": "2"});
    var userDataBadge2List = response2['data'] as List;
    userBadge2 = userDataBadge2List
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    var response3 = await postRequest(linkViewBadge, {"badge": "3"});
    var userDataBadge3List = response3['data'] as List;
    userBadge3 = userDataBadge3List
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    isLoading = false;
    setState(() {});
  }

  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  var dt = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('badge initState');
    dt = DateTime.now();
    getBadge();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        // appBar: AppBar(
        //   // title: Text("نتائج الاسبوع الماضي"),
        //   actions: [],
        // ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "نتائج الاسبوع الماضي رقم ${int.parse(weekNumber) - 1}",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: textColor2),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Lottie.asset(
                      'assets/lottie/67230-trophy-winner.json',
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "الفائزون الثلاث الاوائل",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    Text("المرتبة الاولى"),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.network(
                        "$linkImageRoot/${userBadge1[0].usersImage}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      userBadge1[0].usersName.toString(),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text("المرتبة الثانية"),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                "$linkImageRoot/${userBadge2[0].usersImage}",
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              userBadge2[0].usersName.toString(),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          children: [
                            Text("المرتبة الثالثة"),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                "$linkImageRoot/${userBadge3[0].usersImage}",
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              userBadge3[0].usersName.toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                            onTap: () async {
                              await rest_isWeeklyChange();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "initialScreen", (route) => false);
                            },
                            child: Text("عدم اظهار مرة اخرى")),
                        SizedBox(
                          width: 60.0,
                        ),
                        InkWell(
                          child: Text("متابعة"),
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                "initialScreen", (route) => false);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
