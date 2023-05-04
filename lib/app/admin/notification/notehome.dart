import 'package:flutter/material.dart';
import 'package:mymosque/app/admin/notification/noteadd.dart';
import 'package:mymosque/app/admin/notification/noteupdate.dart';
import 'package:mymosque/components/cardnote.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/model/notemodel.dart';

class Note extends StatefulWidget {
  const Note({Key? key}) : super(key: key);
  _RaceState createState() => _RaceState();
}

class _RaceState extends State<Note> {
  getUsers() async {
    var response = await postRequest(linkViewNotes, {
      "subGroup": "ALL",
      "myGroup": sharedPref.getString("myGroup"),
    });
    return response;
  }

  late List noteData;
  String sortColumn = "date";
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
          ],
          title: Column(
            children: [
              Text(
                "الاشعارات",
                style: TextStyle(
                    color: textColor2,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
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
                  future: getUsers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // sort the score
                      // List raceData = snapshot.data['data'];
                      // raceData.sort((a, b) => int.parse(b['finalScore'])
                      //     .compareTo(int.parse(a['finalScore'])));
                      // /////////////////////////////
                      if (_isSwitchedOn == true) {
                        noteData = snapshot.data['data']
                            .where((o) =>
                                o['subGroup'] ==
                                sharedPref.getString("subGroup"))
                            .toList();
                      } else {
                        noteData = snapshot.data['data'];
                      }

                      // raceData.sort((a, b) {
                      //   int cmp = int.parse(b[sortColumn])
                      //       .compareTo(int.parse(a[sortColumn]));
                      //   if (cmp != 0) return cmp;
                      //   return int.parse(b['myGroup'])
                      //       .compareTo(int.parse(a['myGroup']));
                      // });
                      if (snapshot.data['status'] == 'fail')
                        return Center(
                            child: Text(
                          "لايوجد اشعارات",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ));
                      return ListView.builder(
                          itemCount: noteData.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return CardNotes(
                              ontap: () {
                                print(noteData[i]['id']);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NoteUpdate(
                                          note: noteData[i],
                                        )));
                              },
                              notemodel: NoteModel.fromJson(noteData[i]),
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
                .push(MaterialPageRoute(builder: (context) => NoteAdd()));
          },
        ),
      ),
    );
  }
}
