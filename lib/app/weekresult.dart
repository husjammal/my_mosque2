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

  String? user_subGroup = sharedPref.getString("subGroup");
  String? user_myGroup = sharedPref.getString("myGroup");

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

  List userprayBadge1 = [];
  List userprayBadge2 = [];
  List userprayBadge3 = [];

  List userquranBadge1 = [];
  List userquranBadge2 = [];
  List userquranBadge3 = [];

  String weekNumber = "0";

  getBadge() async {
    final firstJan = DateTime(dt.year, 1, 1);
    weekNumber = (weeksBetween(firstJan, dt)).toString();
    print("get the badge");
    isLoading = true;
    setState(() {});
    var response1 = await postRequest(linkViewBadge,
        {"badge": "1", "subGroup": user_subGroup, "myGroup": user_myGroup});
    var userDataBadge1List = response1['data'] as List;
    userBadge1 = userDataBadge1List
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    var response2 = await postRequest(
      linkViewBadge,
      {"badge": "2", "subGroup": user_subGroup, "myGroup": user_myGroup},
    );
    var userDataBadge2List = response2['data'] as List;
    userBadge2 = userDataBadge2List
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    var response3 = await postRequest(linkViewBadge,
        {"badge": "3", "subGroup": user_subGroup, "myGroup": user_myGroup});
    var userDataBadge3List = response3['data'] as List;
    userBadge3 = userDataBadge3List
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    // isLoading = false;
    setState(() {});
  }

  getprayBadge() async {
    print("get the pray badge");
    isLoading = true;
    setState(() {});
    var response4 = await postRequest(linkViewprayBadge,
        {"badge": "1", "subGroup": user_subGroup, "myGroup": user_myGroup});
    var userDataBadge4List = response4['data'] as List;
    userprayBadge1 = userDataBadge4List
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    var response5 = await postRequest(linkViewprayBadge,
        {"badge": "2", "subGroup": user_subGroup, "myGroup": user_myGroup});
    var userDataBadge5List = response5['data'] as List;
    userprayBadge2 = userDataBadge5List
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    var response6 = await postRequest(linkViewprayBadge,
        {"badge": "3", "subGroup": user_subGroup, "myGroup": user_myGroup});
    var userDataBadge6List = response6['data'] as List;
    userprayBadge3 = userDataBadge6List
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    // isLoading = false;
    setState(() {});
  }

  getquranBadge() async {
    print("get quran the badge");
    isLoading = true;
    setState(() {});
    var response7 = await postRequest(linkViewquranBadge,
        {"badge": "1", "subGroup": user_subGroup, "myGroup": user_myGroup});
    var userDataBadge7List = response7['data'] as List;
    userquranBadge1 = userDataBadge7List
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    var response8 = await postRequest(linkViewquranBadge,
        {"badge": "2", "subGroup": user_subGroup, "myGroup": user_myGroup});
    var userDataBadge8List = response8['data'] as List;
    userquranBadge2 = userDataBadge8List
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    var response9 = await postRequest(linkViewquranBadge,
        {"badge": "3", "subGroup": user_subGroup, "myGroup": user_myGroup});
    var userDataBadge9List = response9['data'] as List;
    userquranBadge3 = userDataBadge9List
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
    getprayBadge();
    getquranBadge();
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
            ? Scaffold(
                backgroundColor: backgroundColor,
                body: InkWell(
                  onTap: () {
                    getquranBadge();
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
            : SingleChildScrollView(
                child: Container(
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
                      Divider(
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "حصل على الاوسمة",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: textColor2),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "اوائل الصلاة",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: textColor),
                          ),
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image.network(
                                "$linkImageRoot/${userprayBadge1[0].usersImage}",
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text(
                              userprayBadge1[0].usersName.toString(),
                            ),
                            subtitle: Text('المرتبة الاولى في الصلاة'),
                            trailing: Icon(Icons.one_k_plus),
                          ),

                          ///
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image.network(
                                "$linkImageRoot/${userprayBadge2[0].usersImage}",
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text(
                              userprayBadge2[0].usersName.toString(),
                            ),
                            subtitle: Text('المرتبة الثانية في الصلاة'),
                            trailing: Icon(Icons.one_k_plus),
                          ),

                          ///
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image.network(
                                "$linkImageRoot/${userprayBadge3[0].usersImage}",
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text(
                              userprayBadge3[0].usersName.toString(),
                            ),
                            subtitle: Text('المرتبة الثالثة في الصلاة'),
                            trailing: Icon(Icons.one_k_plus),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "اوائل القران",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: textColor),
                          ),
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image.network(
                                "$linkImageRoot/${userquranBadge1[0].usersImage}",
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text(
                              userquranBadge1[0].usersName.toString(),
                            ),
                            subtitle: Text('المرتبة الاولى في القران'),
                            trailing: Icon(Icons.one_k_plus),
                          ),

                          ///
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image.network(
                                "$linkImageRoot/${userquranBadge2[0].usersImage}",
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text(
                              userquranBadge2[0].usersName.toString(),
                            ),
                            subtitle: Text('المرتبة الثانية في القران'),
                            trailing: Icon(Icons.one_k_plus),
                          ),

                          ///
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image.network(
                                "$linkImageRoot/${userquranBadge3[0].usersImage}",
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text(
                              userquranBadge3[0].usersName.toString(),
                            ),
                            subtitle: Text('المرتبة الثالثة في القران'),
                            trailing: Icon(Icons.one_k_plus),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Divider(
                        thickness: 1.0,
                        height: 1.0,
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
                            child: Container(
                              padding: EdgeInsets.all(15.0),
                              width: 70.0,
                              color: buttonColor,
                              alignment: Alignment.center,
                              child: Text("متابعة",
                                  style: TextStyle(
                                      color: Colors.white,
                                      backgroundColor: buttonColor)),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "initialScreen", (route) => false);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
