import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// Creating a stateful widget to manage
// the state of the app
class Pray extends StatefulWidget {
  const Pray({super.key});

  @override
  _PrayState createState() => _PrayState();
}

class _PrayState extends State<Pray> {
// value set to false
  bool _subuh = false;
  bool _zhur = false;
  bool _asr = false;
  bool _magrib = false;
  bool _isyah = false;

// Fuction to save prayers
  bool isLoading = false;

  int prayScore = 0;
  String _score = "0";
  String _duaaScore = "0";
  String _prayScore = "0";
  String _quranScore = "0";
  String _activityScore = "0";
  String _sunahScore = "0";
  String _nuafelScore = "0";

  save_prayers(String user_id) async {
    // calculate the prayScore
    prayScore = (_subuh ? 1 : 0) +
        (_zhur ? 1 : 0) +
        (_asr ? 1 : 0) +
        (_magrib ? 1 : 0) +
        (_zhur ? 1 : 0);
    print('prayScore is $prayScore');
    _score = (int.parse(_duaaScore) +
            prayScore +
            int.parse(_quranScore) +
            int.parse(_nuafelScore) +
            int.parse(_sunahScore) +
            int.parse(_activityScore))
        .toString();
    print('_score $_score');
    // save the dat_duaaScore_quranScore+
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkPrayer, {
      "user_id": user_id,
      "day_number": dt.weekday.toString(),
      "score": _score,
      "subuh": _subuh ? "1" : "0",
      "zhur": _zhur ? "1" : "0",
      "asr": _asr ? "1" : "0",
      "magrib": _magrib ? "1" : "0",
      "isyah": _isyah ? "1" : "0",
      "duaaScore": _duaaScore,
      "prayScore": prayScore.toString(),
      "quranScore": _quranScore,
      "sunahScore": _sunahScore,
      "nuafelScore": _nuafelScore,
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
        desc: 'تم حفظ الفروض بنجاح',
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

    _subuh = response['data'][0]['subuh'].toString() == "1" ? true : false;
    _zhur = response['data'][0]['zhur'].toString() == "1" ? true : false;
    _asr = response['data'][0]['asr'].toString() == "1" ? true : false;
    _magrib = response['data'][0]['magrib'].toString() == "1" ? true : false;
    _isyah = response['data'][0]['isyah'].toString() == "1" ? true : false;
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
    print('pray initState');
    getNotes();

    setState(() {});
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            title: const Text('صلاة الفجر'),
                            subtitle: const Text(
                                ' وقت صلاة الصبح هو طلوع الفجر الصادق وآخره هو طلوع الشمس'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/subuh.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _subuh,
                            value: _subuh,
                            onChanged: (bool? value) {
                              setState(() {
                                _subuh = value!;
                                print(_subuh);
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
                            title: const Text('صلاة الظهر'),
                            subtitle: const Text(
                                'يدخل بزوال الشمس عن وسط السماءو ينتهي إذاأصبح ظِلّ الشيءِ مثلُه'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/zhur.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _zhur,
                            value: _zhur,
                            onChanged: (bool? value) {
                              setState(() {
                                _zhur = value!;
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
                            title: const Text('صلاة العصر'),
                            subtitle: const Text(
                                'الوقت يدخل عند زيادة ظِلُّ الشيءِ عن مثله وينتهي عند غروب الشمس'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/asr.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _asr,
                            value: _asr,
                            onChanged: (bool? value) {
                              setState(() {
                                _asr = value!;
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
                            title: const Text('صلاة المغرب'),
                            subtitle: const Text(
                                'الوقت يبدأ من غروب الشمس واخره غياب الشفق الأحمر'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/magrib.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _magrib,
                            value: _magrib,
                            onChanged: (bool? value) {
                              setState(() {
                                _magrib = value!;
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
                            title: const Text('صلاة العشاء'),
                            subtitle: const Text(
                                'الوقت يدخل من مغيب الشفق و ينتهي عند طلوع الفجر'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/isyah.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _isyah,
                            value: _isyah,
                            onChanged: (bool? value) {
                              setState(() {
                                _isyah = value!;
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
            await save_prayers(user_id.toString());
            // Navigator.of(context)
            //     .pushNamedAndRemoveUntil("initialScreen", (route) => false);
          },
          tooltip: 'حفظ صلاواتي',
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
