import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/app/pages/quran/quranlearning.dart';
import 'package:mymosque/app/pages/quran/quranlistening.dart';
import 'package:mymosque/app/pages/quran/quranreading.dart';
import 'package:mymosque/components/valid.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// Creating a stateful widget to manage
// the state of the app
class Quran extends StatefulWidget {
  @override
  _QuranState createState() => _QuranState();
}

class _QuranState extends State<Quran> {
// value set to false
  GlobalKey<FormState> formstate = GlobalKey();
  String? user_id;

  TextEditingController _quranRead = TextEditingController();
  TextEditingController _quranLearn = TextEditingController();
  TextEditingController _quranListen = TextEditingController();

// Fuction to save prayers
  bool isLoading = false;
  int quranScore = 0;
  String _score = "0";
  String _duaaScore = "0";
  String _prayScore = "0";
  String _quranScore = "0";
  String _activityScore = "0";
  String _quranLearn_app = "0";

  save_quran(String user_id) async {
    // calculate the quranScore
    quranScore = (int.parse(_quranRead.text)) +
        (int.parse(_quranLearn_app)) +
        (int.parse(_quranListen.text));
    _score = (int.parse(_prayScore) +
            quranScore +
            int.parse(_duaaScore) +
            int.parse(_activityScore))
        .toString();
    print('_score $_score');
    // save the database
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkQuran, {
      "user_id": user_id,
      "day_number": dt.weekday.toString(),
      "score": _score,
      "quranRead": _quranRead.text,
      "quranLearn": _quranLearn.text,
      "quranListen": _quranListen.text,
      "duaaScore": _duaaScore,
      "prayScore": _prayScore,
      "quranScore": quranScore.toString()
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
        desc: 'تم حفظ القران بنجاح',
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

  getQuranNotes() async {
    isLoading = true;
    var response = await postRequest(linkViewActions, {
      "user_id": sharedPref.getString("id"),
      "day_number": dt.weekday.toString(),
    });

    if (response['status'] == "success") {
      print(response);
      _quranRead.text = response['data'][0]['quranRead'].toString();
      _quranLearn.text = response['data'][0]['quranLearn'].toString();
      _quranLearn_app = response['data'][0]['quranLearn_app'].toString();
      _quranListen.text = response['data'][0]['quranListen'].toString();
      _score = response['data'][0]['score'].toString();
      _duaaScore = response['data'][0]['duaaScore'].toString();
      _prayScore = response['data'][0]['prayScore'].toString();
      _quranScore = response['data'][0]['quranScore'].toString();
      _activityScore = response['data'][0]['activityScore'].toString();

      isLoading = false;
      setState(() {});
    } else {}
    return response;
  }

  var dt = DateTime.now();
  var now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('quran initState');
    print(sharedPref.getString("id"));
    getQuranNotes();
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
              const Text('حصّتي من القران'),
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
                          getQuranNotes();
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
                          getQuranNotes();
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
        body: isLoading
            ? Scaffold(
                backgroundColor: backgroundColor,
                body: InkWell(
                  onTap: () {
                    getQuranNotes();
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
                            'assets/images/BasmAllah_green.png',
                            width: double.infinity,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height - 80,
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: buttonColor,
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/Quran_layout_green.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          /////////////////////////////////////////////
                          // the code of the imput form of the quran///
                          ////////////////////////////////////////////
                          child: ListView(
                            children: [
                              Form(
                                key: formstate,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'قراءة',
                                      style: TextStyle(
                                          fontSize: 22.0, color: textColor),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  3 /
                                                  4) -
                                              20,
                                          child: TextFormField(
                                            validator: (val) {
                                              return validInput(val!, 1, 3);
                                            },
                                            keyboardType: TextInputType.number,
                                            controller: _quranRead,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                              labelText: "عدد صفحات القراءة",
                                              labelStyle: const TextStyle(
                                                  color: textColor2),
                                              hintText: "عدد صفحات القراءة",
                                              errorStyle: const TextStyle(
                                                  color: textColor2),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: buttonColor,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: buttonColor2,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        InkWell(
                                          child: Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    4) -
                                                50,
                                            height: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    4) -
                                                50,
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              color: buttonColor,
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              boxShadow: [
                                                const BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(
                                                    3.0,
                                                    3.0,
                                                  ), //Offset
                                                  blurRadius: 10.0,
                                                  spreadRadius: 2.0,
                                                ), //BoxShadow
                                                const BoxShadow(
                                                  color: Colors.white,
                                                  offset: Offset(0.0, 0.0),
                                                  blurRadius: 0.0,
                                                  spreadRadius: 0.0,
                                                ), //BoxShadow
                                              ],
                                            ),
                                            child: Image.asset(
                                              'assets/images/praying.png',
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          onTap: (() {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        QuranReading()));
                                          }),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'حفظ',
                                      style: TextStyle(
                                          fontSize: 22.0, color: textColor),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  3 /
                                                  4) -
                                              20,
                                          child: TextFormField(
                                            validator: (val) {
                                              return validInput(val!, 1, 3);
                                            },
                                            keyboardType: TextInputType.number,
                                            controller: _quranLearn,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                              labelText: "عدد صفحات الحفظ",
                                              labelStyle: const TextStyle(
                                                  color: textColor2),
                                              hintText: "عدد صفحات الحفظ",
                                              errorStyle: const TextStyle(
                                                  color: textColor2),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: buttonColor,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: buttonColor2,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        InkWell(
                                          child: Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    4) -
                                                50,
                                            height: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    4) -
                                                50,
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              color: buttonColor,
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              boxShadow: [
                                                const BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(
                                                    3.0,
                                                    3.0,
                                                  ), //Offset
                                                  blurRadius: 10.0,
                                                  spreadRadius: 2.0,
                                                ), //BoxShadow
                                                const BoxShadow(
                                                  color: Colors.white,
                                                  offset: Offset(0.0, 0.0),
                                                  blurRadius: 0.0,
                                                  spreadRadius: 0.0,
                                                ), //BoxShadow
                                              ],
                                            ),
                                            child: Image.asset(
                                              'assets/images/praying.png',
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          onTap: (() {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        QuranLearning()));
                                          }),
                                        ),
                                      ],
                                    ),

                                    ///
                                    Text(
                                        _quranLearn.text != _quranLearn_app
                                            ? "الحفظ تحت مراجعة المشرف"
                                            : "",
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 12.0)),

                                    ///
                                    Text(
                                      'استماع',
                                      style: TextStyle(
                                          fontSize: 22.0, color: textColor),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  3 /
                                                  4) -
                                              20,
                                          child: TextFormField(
                                            validator: (val) {
                                              return validInput(val!, 1, 3);
                                            },
                                            keyboardType: TextInputType.number,
                                            controller: _quranListen,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                              labelText: "عدد صفحات الاستماع",
                                              labelStyle: const TextStyle(
                                                  color: textColor2),
                                              hintText: "عدد صفحات الاستماع",
                                              errorStyle: const TextStyle(
                                                  color: textColor2),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: buttonColor,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: buttonColor2,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        InkWell(
                                          child: Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    4) -
                                                50,
                                            height: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    4) -
                                                50,
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              color: buttonColor,
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              boxShadow: [
                                                const BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(
                                                    3.0,
                                                    3.0,
                                                  ), //Offset
                                                  blurRadius: 10.0,
                                                  spreadRadius: 2.0,
                                                ), //BoxShadow
                                                const BoxShadow(
                                                  color: Colors.white,
                                                  offset: Offset(0.0, 0.0),
                                                  blurRadius: 0.0,
                                                  spreadRadius: 0.0,
                                                ), //BoxShadow
                                              ],
                                            ),
                                            child: Image.asset(
                                              'assets/images/praying.png',
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          onTap: (() {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        QuranListening()));
                                          }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
            await save_quran(user_id.toString());
            // Navigator.of(context)
            //     .pushNamedAndRemoveUntil("initialScreen", (route) => false);
          },
          tooltip: 'حفظ تلاواتي',
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
