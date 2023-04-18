import 'package:flutter/material.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:convert';

// Creating a stateful widget to manage
// the state of the app
class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
// value set to false
  GlobalKey<FormState> formstate = GlobalKey();
  String? user_id;

  List<String> _list = [];

  bool? _parent = false;
  bool? _charity = false;
  bool? _prayerProphet = false;
  bool? _praise = false;
  bool? _fasting = false;
  bool? _askForgiveness = false;
  bool? _isOther = false;

// Fuction to save prayers
  bool isLoading = false;
  int activityScore = 0;
  String _score = "0";
  String _duaaScore = "0";
  String _prayScore = "0";
  String _quranScore = "0";
  String _activityScore = "0";
  String _sunahScore = "0";
  String _nuafelScore = "0";
  String _actList = "0";

  var dt = DateTime.now();
  var now = DateTime.now();

  save_activity(String user_id) async {
    // calculate the quranScore

    _score = (int.parse(_prayScore) +
            int.parse(_quranScore) +
            activityScore +
            int.parse(_duaaScore) +
            int.parse(_nuafelScore) +
            int.parse(_sunahScore))
        .toString();
    print('_score $_score');
    // save the database
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkActivity, {
      "user_id": user_id,
      "day_number": dt.weekday.toString(),
      "score": _score,
      "activityScore": activityScore.toString(),
      "actList": _list.toString().replaceAll('[', '').replaceAll(']', '')
    });
    isLoading = false;
    setState(() {});
    if (response['status'] == "success") {
      // Navigator.of(context)
      //     .pushNamedAndRemoveUntil("initialScreen", (route) => false);
      AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: 'تم',
        desc: 'تم حفظ النشاط بنجاح',
        btnOkOnPress: () {
          debugPrint('OnClcik');
        },
        btnOkIcon: Icons.check_circle,

        // onDissmissCallback: () {
        //   debugPrint('Dialog Dissmiss from callback');
        // };
      )..show();
    } else {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: 'تنبية',
          desc: 'يوجد خطأ',
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
        ..show();
    }
  }

  getActivityNotes() async {
    var response = await postRequest(linkViewActions, {
      "user_id": sharedPref.getString("id"),
      "day_number": dt.weekday.toString(),
    });
    print(response);
    _score = response['data'][0]['score'].toString();
    _duaaScore = response['data'][0]['duaaScore'].toString();
    _prayScore = response['data'][0]['prayScore'].toString();
    _sunahScore = response['data'][0]['sunahScore'].toString();
    _nuafelScore = response['data'][0]['nuafelScore'].toString();
    _quranScore = response['data'][0]['quranScore'].toString();
    _activityScore = response['data'][0]['activityScore'].toString();
    _actList = response['data'][0]['actList'].toString();
    // _list = _actList as List<String>;
    // _list = json.decode(_actList).cast<String>().toList();
    _list = (_actList.split(','));
    print("_actList $_actList");
    print("_list $_list");

    int.parse(_activityScore) > 0
        ? {
            activityScore = int.parse(_activityScore),
          }
        : {activityScore = 0};

    _actList.contains("رضى الوالدين جيد") ? _parent = true : _parent = false;
    _actList.contains("صيام اليوم") ? _fasting = true : _fasting = false;
    _actList.contains("صدقة") ? _charity = true : _charity = false;
    _actList.contains("مئة تسابيح") ? _praise = true : _praise = false;
    _actList.contains("مئة استغفار")
        ? _askForgiveness = true
        : _askForgiveness = false;
    _actList.contains("مئة صلاة على النبي")
        ? _prayerProphet = true
        : _prayerProphet = false;
    _actList.contains("عبدات اخرى") ? _isOther = true : _isOther = false;

    setState(() {});
    return response;
  }

  @override
  void initState() {
    super.initState();
    print('Activity initState');
    print(sharedPref.getString("id"));
    getActivityNotes();
    var dt = DateTime.now();
    setState(() {});
  }

// App widget tree
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100.0,
          title: Column(
            children: [
              const Text('بعض من نشاطاتي'),
              Container(
                height: 25.0,
                width: 200,
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: buttonColor,
                ),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                        Icons.arrow_circle_right,
                        color: Colors.white,
                      ),
                      onTap: () {
                        var new_dt = dt.subtract(Duration(hours: 24));
                        if (new_dt.weekday < 7) {
                          dt = new_dt;
                          setState(() {});
                          getActivityNotes();
                        } else {
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.RIGHSLIDE,
                              headerAnimationLoop: false,
                              title: 'تنبية',
                              desc: 'لايمكن العودة اكثر!',
                              btnOkOnPress: () {},
                              btnOkIcon: Icons.cancel,
                              btnOkColor: Colors.red)
                            ..show();
                        }
                      },
                    ),
                    Text("اليوم ${dt.day}/${dt.month}/${dt.year}"),
                    InkWell(
                      child: Icon(
                        Icons.arrow_circle_left,
                        color: Colors.white,
                      ),
                      onTap: () {
                        var new_dt = dt.add(Duration(hours: 24));
                        if (new_dt.weekday <= now.weekday &&
                            new_dt.weekday != 1) {
                          dt = new_dt;
                          setState(() {});
                          getActivityNotes();
                        } else {
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.RIGHSLIDE,
                              headerAnimationLoop: false,
                              title: 'تنبية',
                              desc: 'لايمكن التقدم اكثر!',
                              btnOkOnPress: () {},
                              btnOkIcon: Icons.cancel,
                              btnOkColor: Colors.red)
                            ..show();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: buttonColor,

          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("initialScreen", (route) => false);
              },
              icon: const Icon(Icons.exit_to_app),
              tooltip: 'رجوع',
            )
          ], //IconButton
        ), //AppBar
        body: SingleChildScrollView(
          child: Container(
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    //height: 45.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: buttonColor,
                    ),
                    child: Image.asset(
                      'assets/images/activity_green.jpg',
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 120,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: buttonColor,
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/images/avtivity_layout_green.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    /////////////////////////////////////////////
                    // the code of the imput form of the Activity///
                    ////////////////////////////////////////////
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              CheckboxListTile(
                                title: const Text(
                                  " رضى الوالدين جيد",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _parent,
                                secondary: const Icon(Icons.animation),
                                onChanged: (value) {
                                  setState(() {
                                    _parent = value;
                                    String selectVal = " رضى الوالدين جيد";
                                    if (value == true) {
                                      _list[0] = selectVal;
                                      activityScore++;
                                    } else {
                                      _list[0] = "0";
                                      activityScore--;
                                    }
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  "صيام اليوم",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _fasting,
                                secondary: const Icon(Icons.animation),
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    _fasting = value;
                                    String selectVal = "صيام اليوم";
                                    if (value == true) {
                                      _list[1] = selectVal;
                                      activityScore++;
                                    } else {
                                      _list[1] = "0";
                                      activityScore--;
                                    }
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  "صدقة",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _charity,
                                secondary: const Icon(Icons.animation),
                                onChanged: (value) {
                                  setState(() {
                                    _charity = value;
                                    String selectVal = "صدقة";
                                    if (value == true) {
                                      _list[2] = selectVal;
                                      activityScore++;
                                    } else {
                                      _list[2] = "0";
                                      activityScore--;
                                    }
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  "مئة تسبيح",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _praise,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                secondary: const Icon(Icons.animation),
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                onChanged: (value) {
                                  setState(() {
                                    _praise = value;
                                    String selectVal = "مئة تسابيح";
                                    if (value == true) {
                                      _list[3] = selectVal;
                                      activityScore++;
                                    } else {
                                      _list[3] = "0";
                                      activityScore--;
                                    }
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  "مئة استغفار",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _askForgiveness,
                                controlAffinity:
                                    ListTileControlAffinity.platform,
                                secondary: const Icon(Icons.animation),
                                onChanged: (value) {
                                  setState(() {
                                    _askForgiveness = value;
                                    String selectVal = "مئة استغفار";
                                    if (value == true) {
                                      _list[4] = selectVal;
                                      activityScore++;
                                    } else {
                                      _list[4] = "0";
                                      activityScore--;
                                    }
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  "مئة صلاة على النبي",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _prayerProphet,
                                secondary: const Icon(Icons.animation),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Colors.green,
                                checkColor: Colors.amber,
                                onChanged: (value) {
                                  setState(() {
                                    _prayerProphet = value;
                                    String selectVal = "مئة صلاة على النبي";
                                    if (value == true) {
                                      _list[5] = selectVal;
                                      activityScore++;
                                    } else {
                                      _list[5] = "0";
                                      activityScore--;
                                    }
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  "عبادات أخرى",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _isOther,
                                secondary: const Icon(Icons.offline_bolt),
                                activeColor: Colors.red,
                                checkColor: Colors.yellow,
                                subtitle: const Text(
                                    "نشطات غير المذكورة في الاعلى",
                                    style: TextStyle(color: Colors.grey)),
                                onChanged: (value) {
                                  setState(() {
                                    _isOther = value;
                                    String selectVal = "عبدات اخرى";
                                    if (value == true) {
                                      _list[6] = selectVal;
                                      activityScore++;
                                    } else {
                                      _list[6] = "0";
                                      activityScore--;
                                    }
                                  });
                                },
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    const Text("مجموع نقاط نشاطاتي"),
                                    const Text("  "),
                                    Text("$activityScore")
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Center(
                            child: _list.isEmpty
                                ? const Text("")
                                : RichText(
                                    text: TextSpan(
                                        text: "نشاطاتي هي :\n",
                                        // style:
                                        //     DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                        TextSpan(
                                            text: '${_list.toString()} ',
                                            style:
                                                const TextStyle(fontSize: 16)),
                                      ]))),
                      ],
                    ),
                  ),
                ],
              ), //Container
            ), //Padding
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //() => setState(() => _count++),
            String? user_id = sharedPref.getString("id");
            print("user is is $user_id");
            await save_activity(user_id.toString());
            // Navigator.of(context)
            //     .pushNamedAndRemoveUntil("initialScreen", (route) => false);
          },
          tooltip: 'حفظ نشاطاتي',
          // label: Text('حفظ صلاواتي'),
          child: const Icon(
            Icons.thumb_up,
            color: Colors.yellow,
          ),
          backgroundColor: buttonColor,
        ), //SizedBox
      ),
    ); //MaterialApp
  }
}
