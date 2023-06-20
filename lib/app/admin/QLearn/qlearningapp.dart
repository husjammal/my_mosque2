import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:date_format/date_format.dart';

class QLearnApp extends StatefulWidget {
  const QLearnApp({Key? key}) : super(key: key);
  _QLearnAppState createState() => _QLearnAppState();
}

class _QLearnAppState extends State<QLearnApp> {
  TextEditingController _quranLearn_app = TextEditingController();

  getHafatheh() async {
    var response = await postRequest(linkViewQLearnApp, {
      "subGroup": "ALL",
      "myGroup": sharedPref.getString("myGroup"),
    });
    return response;
  }

  saveHafathed(String user_id, String day_number, String quranLearn_app,
      String quranScore, String score) async {
    var response = await postRequest(linkEditQLearnApp, {
      "user_id": user_id,
      "day_number": day_number,
      "quranLearn_app": quranLearn_app,
      "quranScore": quranScore,
      "score": score,
    });
    return response;
  }

  late List hafathehData;

  bool _isSwitchedOn = false;

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
                            DateTime date = DateTime.utc(2022).add(Duration(
                                days: (int.parse(hafathehData[i]["week"]) - 1) *
                                        7 +
                                    (int.parse(
                                        hafathehData[i]["day_number"]))));
                            print(
                                'Date for week ${hafathehData[i]["week"]}, day ${hafathehData[i]["day_number"]}: ${date.year}-${date.month}-${date.day}');
                            String formattedDate =
                                formatDate(date, [yyyy, '/', mm, '/', dd]);

                            print('Date: $formattedDate');

                            return InkWell(
                              onTap: () {
                                _quranLearn_app.text =
                                    hafathehData[i]["quranLearn"];
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.scale,
                                  dialogType: DialogType.infoReverse,
                                  keyboardAware: true,
                                  body: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'تاكيد حفظ',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'في تاريخ $formattedDate',
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                        Text(
                                          'حفظ ${hafathehData[i]["username"]} مقدار  ${hafathehData[i]["quranLearn"]} صفحة و تم التاكد من ؟',
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Material(
                                          elevation: 0,
                                          color: Colors.blueGrey.withAlpha(40),
                                          child: TextFormField(
                                            textDirection: TextDirection.rtl,
                                            autofocus: true,
                                            keyboardType: TextInputType.number,
                                            controller: _quranLearn_app,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: 'عدد الصفحات',
                                              prefixIcon:
                                                  Icon(Icons.layers_rounded),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        AnimatedButton(
                                            text: 'تاكيد',
                                            pressEvent: () async {
                                              int _quranScore = int.parse(
                                                      hafathehData[i]
                                                          ["duaaScore"]) +
                                                  int.parse(
                                                      _quranLearn_app.text) +
                                                  int.parse(hafathehData[i]
                                                      ["prayScore"]);
                                              int _score = int.parse(
                                                      hafathehData[i]
                                                          ["sunahScore"]) +
                                                  int.parse(hafathehData[i]
                                                      ["nuafelScore"]) +
                                                  int.parse(hafathehData[i]
                                                      ["activityScore"]) +
                                                  _quranScore;
                                              await saveHafathed(
                                                  hafathehData[i]["user_id"],
                                                  hafathehData[i]["day_number"],
                                                  _quranLearn_app.text,
                                                  _quranScore.toString(),
                                                  _score.toString());
                                              Navigator.of(context).pop();
                                              setState(() {});
                                            })
                                      ],
                                    ),
                                  ),
                                )..show();
                              },
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
                                        child: FadeInImage.assetNetwork(
                                          image:
                                              "$linkImageRoot/${hafathehData[i]["image"]}",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.contain,
                                          placeholder:
                                              'assets/images/avatar.png',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: ListTile(
                                        leading: Column(
                                          children: [
                                            Text(
                                              "$formattedDate",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "week ${hafathehData[i]["week"]}",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        title: Column(
                                          children: [
                                            Text(
                                              "${hafathehData[i]["username"]}",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "حفظ ${hafathehData[i]["quranLearn"]}",
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
