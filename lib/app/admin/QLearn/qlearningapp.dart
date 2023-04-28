import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/components/carduser.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/usermodel.dart';

class QLearnApp extends StatefulWidget {
  const QLearnApp({Key? key}) : super(key: key);
  _QLearnAppState createState() => _QLearnAppState();
}

class _QLearnAppState extends State<QLearnApp> {
  getHafatheh() async {
    var response = await postRequest(linkViewQLearnApp, {
      "subGroup": "ALL",
      "myGroup": sharedPref.getString("myGroup"),
    });
    return response;
  }

  late List hafathehData;

  bool _isSwitchedOn = false;

  List<UserModel> userData = [];
  List userDataList = [];
  bool isLoading = false;

  void getOneUser(String userID) async {
    isLoading = true;
    var response = await postRequest(linkViewOneUser, {
      "id": userID,
    });
    userDataList = response['data'] as List;
    userData = userDataList
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    // userData = response['data'];
    isLoading = false;
    setState(() {});
    // print("userOneData $userData");
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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("adminhome", (route) => false);
              },
              icon: Icon(Icons.exit_to_app),
              tooltip: 'رجوع',
            )
          ],
          title: Column(
            children: [
              Text(
                "قائمة الحفظة",
                style: TextStyle(
                    color: textColor2,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
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
                  future: getHafatheh(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // sort the score
                      // List userData = snapshot.data['data'];
                      // userData.sort((a, b) => int.parse(b['finalScore'])
                      //     .compareTo(int.parse(a['finalScore'])));
                      // /////////////////////////////
                      if (_isSwitchedOn == true) {
                        hafathehData = snapshot.data['data']
                            .where((o) =>
                                o['subGroup'] ==
                                sharedPref.getString("subGroup"))
                            .toList();
                      } else {
                        hafathehData = snapshot.data['data'];
                      }

                      // userData.sort((a, b) {
                      //   int cmp = int.parse(b[sortColumn])
                      //       .compareTo(int.parse(a[sortColumn]));
                      //   if (cmp != 0) return cmp;
                      //   return int.parse(b['totalScore'])
                      //       .compareTo(int.parse(a['totalScore']));
                      // });
                      if (snapshot.data['status'] == 'fail')
                        return Center(
                            child: Text(
                          "لايوجد حفظة",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ));
                      return ListView.builder(
                          itemCount: hafathehData.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            getOneUser(hafathehData[i]["user_id"]);
                            return InkWell(
                              onTap: () {},
                              child: Card(
                                color: backgroundColor,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        child: Image.asset(
                                          'assets/images/badge.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: ListTile(
                                        leading: FlutterLogo(),
                                        title: Column(
                                          children: [
                                            Text(
                                              "${hafathehData[i]["user_id"]}",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${userData[0].usersName}",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        // floatingActionButton: FloatingActionButton(
        //   mini: true,
        //   child: Icon(Icons.filter),
        //   tooltip: "مسجد/حلقة",
        //   elevation: 12,
        //   splashColor: textColor2,
        //   hoverColor: buttonColor,
        //   highlightElevation: 50,
        //   hoverElevation: 50,
        //   onPressed: () {
        //     AwesomeDialog(
        //       context: context,
        //       animType: AnimType.SCALE,
        //       dialogType: DialogType.INFO,
        //       keyboardAware: true,
        //       body: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Column(
        //           children: <Widget>[
        //             Text(
        //               'اختار الحلقة!',
        //               style: Theme.of(context).textTheme.headline6,
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             /////

        //             ///
        //             SizedBox(
        //               height: 10,
        //             ),
        //             AnimatedButton(text: 'تم', pressEvent: () {})
        //           ],
        //         ),
        //       ),
        //     )..show();
        //   },
        // ),
      ),
    );
  }
}
