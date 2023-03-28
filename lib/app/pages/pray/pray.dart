import 'package:flutter/material.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';

import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mymosque/constant/colorConfig.dart';

// Creating a stateful widget to manage
// the state of the app
class Pray extends StatefulWidget {
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
      "quranScore": _quranScore
    });
    isLoading = false;

    setState(() {});
    if (response['status'] == "success") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("initialScreen", (route) => false);
    } else {
      AwesomeDialog(context: context, title: "تنبيه", body: Text("يوجد خطأ"))
        ..show();
    }
  }

  getNotes() async {
    var response = await postRequest(linkViewNotes, {
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
    _quranScore = response['data'][0]['quranScore'].toString();
    _activityScore = response['data'][0]['activityScore'].toString();

    setState(() {});
    return response;
  }

  var dt = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('pray initState');
    getNotes();
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
          title: Text('جدول صلاتي'),
          centerTitle: true,
          backgroundColor: buttonColor,
          leading: IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'قائمة',
            onPressed: () {},
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("initialScreen", (route) => false);
              },
              icon: Icon(Icons.exit_to_app),
              tooltip: 'رجوع',
            )
          ], //IconButton
        ), //AppBar
        body: isLoading == true
            ? Scaffold(
                backgroundColor: backgroundColor,
                body: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: backgroundColor,
                  color: buttonColor,
                )))
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
                            'images/logo2.png',
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
                              backgroundImage:
                                  AssetImage("images/subuh.png"), //NetworkImage
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
                              backgroundImage:
                                  AssetImage("images/zhur.png"), //NetworkImage
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
                              backgroundImage:
                                  AssetImage("images/asr.png"), //NetworkImage
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
                                  "images/magrib.png"), //NetworkImage
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
                              backgroundImage:
                                  AssetImage("images/isyah.png"), //NetworkImage
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
            Navigator.of(context)
                .pushNamedAndRemoveUntil("initialScreen", (route) => false);
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
