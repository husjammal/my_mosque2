import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mymosque/app/admin/users/studentadd.dart';
import 'package:mymosque/app/admin/users/studentedit.dart';
import 'package:mymosque/app/admin/users/studentview.dart';
import 'package:mymosque/components/carduser.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/usermodel.dart';
import 'package:lottie/lottie.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  getUsers() async {
    var response = await postRequest(linkViewUsers, {
      "subGroup": "ALL",
      "myGroup": sharedPref.getString("myGroup"),
    });
    return response;
  }

  late List userData;
  String sortColumn = "finalScore";
  String rankName = "كلي";

  bool _isSwitchedOn = false;

  var dt = DateTime.now();
  var now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('rank initState');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 160.0,
          backgroundColor: buttonColor2,
          centerTitle: true,
          leadingWidth: 0.0,
          actions: [],
          title: Column(
            children: [
              Text(
                "باقي لنهاية تحدي الاسبوع ${8 - int.parse(dt.weekday.toString())} يوم!",
                style: TextStyle(
                    color: textColor2,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Column(
                      children: [
                        Icon(Icons.star, size: 15.0, color: Colors.yellow),
                        Text(
                          "كلي",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                    onTap: () {
                      sortColumn = 'finalScore';
                      rankName = "كلي";
                      setState(() {});
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Icon(Icons.star, size: 15.0, color: Colors.yellow),
                        Text(
                          "صلاة",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                    onTap: () {
                      sortColumn = 'finalprayScore';
                      rankName = "صلاة";
                      setState(() {});
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Icon(Icons.star, size: 15.0, color: Colors.yellow),
                        Text(
                          "سنن",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                    onTap: () {
                      sortColumn = 'finalsunahScore';
                      rankName = "سنن";
                      setState(() {});
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Icon(Icons.star, size: 15.0, color: Colors.yellow),
                        Text(
                          "نوافل",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                    onTap: () {
                      sortColumn = 'finalnuafelScore';
                      rankName = "نوافل";
                      setState(() {});
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Icon(Icons.star, size: 15.0, color: Colors.yellow),
                        Text(
                          "قران",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                    onTap: () {
                      sortColumn = 'finalquranScore';
                      rankName = "قران";
                      setState(() {});
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Icon(
                          Icons.star,
                          size: 15.0,
                          color: Colors.yellow,
                        ),
                        Text(
                          "نشاط",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                    onTap: () {
                      sortColumn = 'finalactivityScore';
                      rankName = "نشاط";
                      setState(() {});
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    " التصنيف حسب",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    "$rankName",
                    style: TextStyle(fontSize: 18.0, color: textColor),
                  ),
                  SizedBox(
                    width: 40.0,
                  ),
                  SizedBox(
                    width: 150.0,
                    child: SwitchListTile(
                      title: Text(_isSwitchedOn ? 'حلقتي' : "مسجدي",
                          style: TextStyle(color: buttonColor, fontSize: 12.0)),
                      value: _isSwitchedOn,
                      onChanged: (bool value) {
                        setState(() {
                          _isSwitchedOn = value;
                        });
                      },
                      // subtitle: Text(_isSwitchedOn ? "مسجدي" : "حلقتي"),
                      // secondary: const Icon(Icons.filter),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              FutureBuilder(
                  future: getUsers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // sort the score
                      // List userData = snapshot.data['data'];
                      // userData.sort((a, b) => int.parse(b['finalScore'])
                      //     .compareTo(int.parse(a['finalScore'])));
                      // /////////////////////////////
                      if (_isSwitchedOn == true) {
                        userData = snapshot.data['data']
                            .where((o) =>
                                o['subGroup'] ==
                                sharedPref.getString("subGroup"))
                            .toList();
                      } else {
                        userData = snapshot.data['data'];
                      }

                      userData.sort((a, b) {
                        int cmp = int.parse(b[sortColumn])
                            .compareTo(int.parse(a[sortColumn]));
                        if (cmp != 0) return cmp;
                        return int.parse(b['totalScore'])
                            .compareTo(int.parse(a['totalScore']));
                      });
                      if (snapshot.data['status'] == 'fail')
                        return Center(
                            child: Text(
                          "لايوجد مشتركين",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ));
                      return ListView.builder(
                          itemCount: userData.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return CardUsers(
                              ontap: () {
                                print(userData[i]['id']);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => StudentView(
                                          user: userData[i],
                                        )));
                              },
                              usermodel: UserModel.fromJson(userData[i]),
                              rank_index: i,
                              sortColumn: sortColumn,
                            );
                          });
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          children: [
                            Text("جاري التحميل ..."),
                            Lottie.asset(
                              'assets/lottie/93603-loading-lottie-animation.json',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      child: Center(
                        child: Column(
                          children: [
                            Text("خطأ في التحميل ..."),
                            Lottie.asset(
                              'assets/lottie/52108-error.json',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: FloatingActionButton(
          mini: true,
          child: Icon(Icons.filter),
          tooltip: "اضافة مستخدم",
          elevation: 12,
          splashColor: textColor2,
          hoverColor: buttonColor,
          highlightElevation: 50,
          hoverElevation: 50,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => StudentAdd()));
          },
        ),
      ),
    );
  }
}
