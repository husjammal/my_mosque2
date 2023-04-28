import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mymosque/app/admin/users/teacheradd.dart';
import 'package:mymosque/app/admin/users/teacherview.dart';
import 'package:mymosque/components/cardAdmin.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/adminmodel.dart';
import 'package:lottie/lottie.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);
  _TeacherState createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  getUsers() async {
    var response = await postRequest(linkViewAdmins, {
      "subGroup": "ALL",
      "myGroup": sharedPref.getString("myGroup"),
    });
    return response;
  }

  late List adminData;
  String sortColumn = "myGroup";

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
          toolbarHeight: 80.0,
          backgroundColor: buttonColor2,
          centerTitle: true,
          leadingWidth: 0.0,
          actions: [],
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      if (_isSwitchedOn == true) {
                        adminData = snapshot.data['data']
                            .where((o) =>
                                o['subGroup'] ==
                                sharedPref.getString("subGroup"))
                            .toList();
                      } else {
                        adminData = snapshot.data['data'];
                      }

                      // adminData.sort((a, b) {
                      //   int cmp = int.parse(b[sortColumn])
                      //       .compareTo(int.parse(a[sortColumn]));
                      //   if (cmp != 0) return cmp;
                      //   return int.parse(b['myGroup'])
                      //       .compareTo(int.parse(a['myGroup']));
                      // });
                      if (snapshot.data['status'] == 'fail')
                        return Center(
                            child: Text(
                          "لايوجد مشتركين",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ));
                      return ListView.builder(
                          itemCount: adminData.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return CardAdmins(
                              ontap: () {
                                print(adminData[i]['id']);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TeacherView(
                                          admin: adminData[i],
                                        )));
                              },
                              adminmodel: AdminModel.fromJson(adminData[i]),
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
          tooltip: "اضافة مشرف",
          elevation: 12,
          splashColor: textColor2,
          hoverColor: buttonColor,
          highlightElevation: 50,
          hoverElevation: 50,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AdminAdd()));
          },
        ),
      ),
    );
  }
}
