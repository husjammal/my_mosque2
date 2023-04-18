import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// Creating a stateful widget to manage
// the state of the app
class Sunah extends StatefulWidget {
  const Sunah({super.key});

  @override
  _SunahState createState() => _SunahState();
}

class _SunahState extends State<Sunah> {
// value set to false
  bool _subuhSunah = false;
  bool _zhurSunah = false;
  bool _asrSunah = false;
  bool _magribSunah = false;
  bool _isyahSunah = false;
  bool _watterSunah = false;

// Fuction to save prayers
  bool isLoading = false;

  int sunahScore = 0;
  String _score = "0";
  String _duaaScore = "0";
  String _prayScore = "0";
  String _sunahScore = "0";
  String _nuafelScore = "0";
  String _quranScore = "0";
  String _activityScore = "0";

  save_sunah(String user_id) async {
    // calculate the prayScore
    sunahScore = (_subuhSunah ? 1 : 0) +
        (_zhurSunah ? 1 : 0) +
        (_asrSunah ? 1 : 0) +
        (_magribSunah ? 1 : 0) +
        (_isyahSunah ? 1 : 0) +
        (_watterSunah ? 1 : 0);
    print('sunahScore is $sunahScore');
    _score = (int.parse(_duaaScore) +
            sunahScore +
            int.parse(_prayScore) +
            int.parse(_nuafelScore) +
            int.parse(_quranScore) +
            int.parse(_activityScore))
        .toString();
    print('_score $_score');
    // save the dat_duaaScore_quranScore+
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkSunah, {
      "user_id": user_id,
      "day_number": dt.weekday.toString(),
      "score": _score,
      "subuhSunah": _subuhSunah ? "1" : "0",
      "zhurSunah": _zhurSunah ? "1" : "0",
      "asrSunah": _asrSunah ? "1" : "0",
      "magribSunah": _magribSunah ? "1" : "0",
      "isyahSunah": _isyahSunah ? "1" : "0",
      "watterSunah": _watterSunah ? "1" : "0",
      "duaaScore": _duaaScore,
      "prayScore": _prayScore,
      "sunahScore": sunahScore.toString(),
      "nuafelScore": _nuafelScore,
      "quranScore": _quranScore,
      "activityScore": _activityScore
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
        desc: 'تم حفظ السنن بنجاح',
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

  getNotes() async {
    var response = await postRequest(linkViewActions, {
      "user_id": sharedPref.getString("id"),
      "day_number": dt.weekday.toString()
    });

    _subuhSunah =
        response['data'][0]['subuhSunah'].toString() == "1" ? true : false;
    _zhurSunah =
        response['data'][0]['zhurSunah'].toString() == "1" ? true : false;
    _asrSunah =
        response['data'][0]['asrSunah'].toString() == "1" ? true : false;
    _magribSunah =
        response['data'][0]['magribSunah'].toString() == "1" ? true : false;
    _isyahSunah =
        response['data'][0]['isyahSunah'].toString() == "1" ? true : false;
    _watterSunah =
        response['data'][0]['watterSunah'].toString() == "1" ? true : false;
    _score = response['data'][0]['score'].toString();
    _duaaScore = response['data'][0]['duaaScore'].toString();
    _prayScore = response['data'][0]['prayScore'].toString();
    _sunahScore = response['data'][0]['sunahScore'].toString();
    _nuafelScore = response['data'][0]['nuafelScore'].toString();
    _quranScore = response['data'][0]['quranScore'].toString();
    _activityScore = response['data'][0]['activityScore'].toString();

    setState(() {});
    return response;
  }

  var dt = DateTime.now();
  var now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('sunah pray initState');
    getNotes();
  }

// App widget tree
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          actions: const [],
          centerTitle: true,

          /// the date selector
          title: Container(
            height: 25.0,
            width: 200,
            margin: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: buttonColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      getNotes();
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
                    if (new_dt.weekday <= now.weekday && new_dt.weekday != 1) {
                      dt = new_dt;
                      setState(() {});
                      getNotes();
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
        ),
        body: isLoading == true
            ? Scaffold(
                backgroundColor: backgroundColor,
                body: InkWell(
                  onTap: () {
                    getNotes();
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
                            'assets/images/logo2.png',
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Subuh
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                          ), //BoxDecoration

                          /** CheckboxListTile Widget **/
                          child: CheckboxListTile(
                            title: const Text('سنة الفجر'),
                            subtitle: const Text('ركعتان قبل الفجر'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/subuh.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _subuhSunah,
                            value: _subuhSunah,
                            onChanged: (bool? value) {
                              setState(() {
                                _subuhSunah = value!;
                                print(_subuhSunah);
                              });
                            },
                          ), //CheckboxListTile
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //Zhur
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                          ), //BoxDecoration

                          /** CheckboxListTile Widget **/
                          child: CheckboxListTile(
                            title: const Text('سنة الظهر'),
                            subtitle: const Text(
                                'أربع ركعات قبل الظهر و ركعتان بعد الظهر'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/zhur.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _zhurSunah,
                            value: _zhurSunah,
                            onChanged: (bool? value) {
                              setState(() {
                                _zhurSunah = value!;
                              });
                            },
                          ), //CheckboxListTile
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //Zhur
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                          ), //BoxDecoration

                          /** CheckboxListTile Widget **/
                          child: CheckboxListTile(
                            title: const Text('سنة العصر'),
                            subtitle: const Text('أربع ركعات قبل العصر'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/asr.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _asrSunah,
                            value: _asrSunah,
                            onChanged: (bool? value) {
                              setState(() {
                                _asrSunah = value!;
                              });
                            },
                          ), //CheckboxListTile
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //Zhur
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                          ), //BoxDecoration

                          /** CheckboxListTile Widget **/
                          child: CheckboxListTile(
                            title: const Text('سنة المغرب'),
                            subtitle: const Text('ركعتان بعد صلاة المغرب'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/magrib.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _magribSunah,
                            value: _magribSunah,
                            onChanged: (bool? value) {
                              setState(() {
                                _magribSunah = value!;
                              });
                            },
                          ), //CheckboxListTile
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //Zhur
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                          ), //BoxDecoration

                          /** CheckboxListTile Widget **/
                          child: CheckboxListTile(
                            title: const Text('سنة العشاء'),
                            subtitle: const Text(
                                'ركعتان قبل العشاء و ركعتان بعد العشاء'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/isyah.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _isyahSunah,
                            value: _isyahSunah,
                            onChanged: (bool? value) {
                              setState(() {
                                _isyahSunah = value!;
                              });
                            },
                          ), //CheckboxListTile
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //Zhur
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                          ), //BoxDecoration

                          /** CheckboxListTile Widget **/
                          child: CheckboxListTile(
                            title: const Text('سنة الوتر'),
                            subtitle: const Text(
                                'وتراً أي ركعة واحدة، أو ثلاثاً أو أكثر أي عدداً فردياً'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/mecca.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _watterSunah,
                            value: _watterSunah,
                            onChanged: (bool? value) {
                              setState(() {
                                _watterSunah = value!;
                              });
                            },
                          ), //CheckboxListTile
                        ),
                        SizedBox(
                          height: 30,
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
            await save_sunah(user_id.toString());
            // Navigator.of(context)
            //     .pushNamedAndRemoveUntil("initialScreen", (route) => false);
          },
          tooltip: 'حفظ سنني',
          // label: Text('حفظ صلاواتي'),
          child: Icon(
            Icons.thumb_up,
            color: Colors.yellow,
          ),
          backgroundColor: buttonColor,
        ), //SizedBox
      ),
    ); //MaterialApp
  }
}
