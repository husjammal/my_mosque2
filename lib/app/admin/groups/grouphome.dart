import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mymosque/app/admin/groups/groupadd.dart';
import 'package:mymosque/app/admin/groups/groupupdate.dart';
import 'package:mymosque/components/cardgroup.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/groupmodel.dart';
import 'package:lottie/lottie.dart';

class Group extends StatefulWidget {
  const Group({Key? key}) : super(key: key);
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  getGroups() async {
    var response = await postRequest(linkViewGroups, {
      "subGroup": "ALL",
      "myGroup": "ALL",
    });
    return response;
  }

  late List groupData;
  String sortColumn = "subGroup";
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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("adminhome", (route) => false);
              },
              icon: Icon(Icons.exit_to_app),
              tooltip: 'رجوع',
            )
          ], //IconButton

          title: Column(
            children: [
              Text(
                "قائمة باسماء الحلقات",
                style: TextStyle(
                    color: textColor2,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 150.0,
                child: SwitchListTile(
                  title: Text(_isSwitchedOn ? 'مسجدي' : "الكل",
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
          // leadingWidth: 1.0,
        ),
        backgroundColor: backgroundColor,
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              FutureBuilder(
                  future: getGroups(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // sort the score
                      // List groupData = snapshot.data['data'];
                      // groupData.sort((a, b) => int.parse(b['finalScore'])
                      //     .compareTo(int.parse(a['finalScore'])));
                      // /////////////////////////////
                      if (_isSwitchedOn == true) {
                        groupData = snapshot.data['data']
                            .where((o) =>
                                o['myGroup'] == sharedPref.getString("myGroup"))
                            .toList();
                      } else {
                        groupData = snapshot.data['data'];
                      }

                      // groupData.sort((a, b) {
                      //   int cmp = int.parse(b[sortColumn])
                      //       .compareTo(int.parse(a[sortColumn]));
                      //   if (cmp != 0) return cmp;
                      //   return int.parse(b['myGroup'])
                      //       .compareTo(int.parse(a['myGroup']));
                      // });
                      if (snapshot.data['status'] == 'fail')
                        return Center(
                            child: Text(
                          "لايوجد مجموعات",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ));
                      return ListView.builder(
                          itemCount: groupData.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return CardGroup(
                              ontap: () {
                                print(groupData[i]['id']);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        GroupUpdate(group: groupData[i])));
                              },
                              groupmodel: GroupModel.fromJson(groupData[i]),
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
          tooltip: "مسجد/حلقة",
          elevation: 12,
          splashColor: textColor2,
          hoverColor: buttonColor,
          highlightElevation: 50,
          hoverElevation: 50,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => GroupAdd()));
            // AwesomeDialog(
            //   context: context,
            //   animType: AnimType.SCALE,
            //   dialogType: DialogType.INFO,
            //   keyboardAware: true,
            //   body: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       children: <Widget>[
            //         Text(
            //           'اختار الحلقة!',
            //           style: Theme.of(context).textTheme.headline6,
            //         ),
            //         SizedBox(
            //           height: 10,
            //         ),
            //         /////

            //         ///
            //         SizedBox(
            //           height: 10,
            //         ),
            //         AnimatedButton(text: 'تم', pressEvent: () {})
            //       ],
            //     ),
            //   ),
            // )..show();
          },
        ),
      ),
    );
  }
}
