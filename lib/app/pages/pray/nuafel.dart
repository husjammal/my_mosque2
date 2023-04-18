import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// Creating a stateful widget to manage
// the state of the app
class Nuafel extends StatefulWidget {
  const Nuafel({super.key});

  @override
  _NuafelState createState() => _NuafelState();
}

class _NuafelState extends State<Nuafel> {
// value set to false
  bool _duhhaNafel = false;
  bool _tarawehNafel = false;
  bool _keyamNafel = false;
  bool _tahajoudNafel = false;

// Fuction to save prayers
  bool isLoading = false;

  int nuafelScore = 0;
  String _score = "0";
  String _duaaScore = "0";
  String _prayScore = "0";
  String _sunahScore = "0";
  String _nuafelScore = "0";
  String _quranScore = "0";
  String _activityScore = "0";

  save_nuafel(String user_id) async {
    // calculate the prayScore
    nuafelScore = (_duhhaNafel ? 1 : 0) +
        (_tarawehNafel ? 1 : 0) +
        (_keyamNafel ? 1 : 0) +
        (_tahajoudNafel ? 1 : 0);
    print('sunahScore is $nuafelScore');
    _score = (int.parse(_duaaScore) +
            nuafelScore +
            int.parse(_prayScore) +
            int.parse(_sunahScore) +
            int.parse(_quranScore) +
            int.parse(_activityScore))
        .toString();
    print('_score $_score');
    // save the dat_duaaScore_quranScore+
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkNuafel, {
      "user_id": user_id,
      "day_number": dt.weekday.toString(),
      "score": _score,
      "duhhaNafel": _duhhaNafel ? "1" : "0",
      "tarawehNafel": _tarawehNafel ? "1" : "0",
      "keyamNafel": _keyamNafel ? "1" : "0",
      "tahajoudNafel": _tahajoudNafel ? "1" : "0",
      "duaaScore": _duaaScore,
      "prayScore": _prayScore,
      "sunahScore": _sunahScore,
      "nuafelScore": nuafelScore.toString(),
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
        desc: 'تم حفظ النوافل بنجاح',
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

    _duhhaNafel =
        response['data'][0]['duhhaNafel'].toString() == "1" ? true : false;
    _tarawehNafel =
        response['data'][0]['tarawehNafel'].toString() == "1" ? true : false;
    _keyamNafel =
        response['data'][0]['keyamNafel'].toString() == "1" ? true : false;
    _tahajoudNafel =
        response['data'][0]['tahajoudNafel'].toString() == "1" ? true : false;
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
                            title: const Text('صلاة الضحى'),
                            subtitle: const Text(
                                'صلاة الأوابين هي صلاة تؤدى بعد ارتفاع الشمس قِيدَ رمح وأقلها ركعتان، وأوسطها أربع ركعات، وأفضلها ثمانِ ركعات'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/subuh.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _duhhaNafel,
                            value: _duhhaNafel,
                            onChanged: (bool? value) {
                              setState(() {
                                _duhhaNafel = value!;
                                print(_duhhaNafel);
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
                            title: const Text('صلاة التراويح'),
                            subtitle: const Text(
                                'إحدى عشرة ركعة مع الوتر بثلاث ركعات.'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/mosque.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _tarawehNafel,
                            value: _tarawehNafel,
                            onChanged: (bool? value) {
                              setState(() {
                                _tarawehNafel = value!;
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
                            title: const Text('صلاة قيام الليل'),
                            subtitle: const Text(
                                'من بعد فعل صلاة العشاء، إلى طلوع الفجر الثاني'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/pray.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _keyamNafel,
                            value: _keyamNafel,
                            onChanged: (bool? value) {
                              setState(() {
                                _keyamNafel = value!;
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
                            title: const Text('صلاة التهجد'),
                            subtitle: const Text('الصلاة في الليل بعد نوم.'),
                            secondary: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/pray.png"), //NetworkImage
                              radius: 20,
                            ),
                            autofocus: false,
                            isThreeLine: true,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: _tahajoudNafel,
                            value: _tahajoudNafel,
                            onChanged: (bool? value) {
                              setState(() {
                                _tahajoudNafel = value!;
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
            await save_nuafel(user_id.toString());
            // Navigator.of(context)
            //     .pushNamedAndRemoveUntil("initialScreen", (route) => false);
          },
          tooltip: 'حفظ النوافل',
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
