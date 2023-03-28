import 'package:flutter/material.dart';
import 'package:mymosque/components/customtextform.dart';
import 'package:mymosque/components/valid.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';

import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mymosque/constant/colorConfig.dart';

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

  var dt = DateTime.now();
  save_quran(String user_id) async {
    // calculate the quranScore
    quranScore = (int.parse(_quranRead.text)) +
        (int.parse(_quranLearn.text)) +
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
      Navigator.of(context)
          .pushNamedAndRemoveUntil("initialScreen", (route) => false);
    } else {
      AwesomeDialog(context: context, title: "تنبيه", body: Text("يوجد خطأ"))
        ..show();
    }
  }

  getQuranNotes() async {
    var response = await postRequest(linkViewNotes, {
      "user_id": sharedPref.getString("id"),
      "day_number": dt.weekday.toString(),
    });
    print(response);
    _quranRead.text = response['data'][0]['quranRead'].toString();
    _quranLearn.text = response['data'][0]['quranLearn'].toString();
    _quranListen.text = response['data'][0]['quranListen'].toString();
    _score = response['data'][0]['score'].toString();
    _duaaScore = response['data'][0]['duaaScore'].toString();
    _prayScore = response['data'][0]['prayScore'].toString();
    _quranScore = response['data'][0]['quranScore'].toString();
    _activityScore = response['data'][0]['activityScore'].toString();

    setState(() {});
    return response;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('quran initState');
    print(sharedPref.getString("id"));
    getQuranNotes();
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
          title: Text('حصّتي من القران'),
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
                      'images/BasmAllah.png',
                      width: double.infinity,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 80,
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: buttonColor,
                      image: const DecorationImage(
                        image: AssetImage('images/Quran_layout.png'),
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
                                    fontSize: 22.0, color: Colors.grey[400]),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width *
                                            3 /
                                            4) -
                                        20,
                                    child: CustomTextFormSign(
                                      valid: (val) {
                                        return validInput(val!, 1, 3);
                                      },
                                      mycontroller: _quranRead,
                                      hint: "عدد صفحات القراءة",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  InkWell(
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  1 /
                                                  4) -
                                              50,
                                      height:
                                          (MediaQuery.of(context).size.width *
                                                  1 /
                                                  4) -
                                              50,
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
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
                                      ),
                                      child: Image.asset(
                                        'images/praying.png',
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    onTap: (() {
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(builder: (context) => Pray()));
                                    }),
                                  ),
                                ],
                              ),
                              Text(
                                'حفظ',
                                style: TextStyle(
                                    fontSize: 22.0, color: Colors.grey[400]),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width *
                                            3 /
                                            4) -
                                        20,
                                    child: CustomTextFormSign(
                                      valid: (val) {
                                        return validInput(val!, 1, 3);
                                      },
                                      mycontroller: _quranLearn,
                                      hint: "عدد صفحات الحفظ",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  InkWell(
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  1 /
                                                  4) -
                                              50,
                                      height:
                                          (MediaQuery.of(context).size.width *
                                                  1 /
                                                  4) -
                                              50,
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
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
                                      ),
                                      child: Image.asset(
                                        'images/praying.png',
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    onTap: (() {
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(builder: (context) => Pray()));
                                    }),
                                  ),
                                ],
                              ),
                              Text(
                                'استماع',
                                style: TextStyle(
                                    fontSize: 22.0, color: Colors.grey[400]),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width *
                                            3 /
                                            4) -
                                        20,
                                    child: CustomTextFormSign(
                                      valid: (val) {
                                        return validInput(val!, 1, 3);
                                      },
                                      mycontroller: _quranListen,
                                      hint: "عدد صفحات الاستماع",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  InkWell(
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  1 /
                                                  4) -
                                              50,
                                      height:
                                          (MediaQuery.of(context).size.width *
                                                  1 /
                                                  4) -
                                              50,
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
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
                                      ),
                                      child: Image.asset(
                                        'images/praying.png',
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    onTap: (() {
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(builder: (context) => Pray()));
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
            Navigator.of(context)
                .pushNamedAndRemoveUntil("initialScreen", (route) => false);
          },
          tooltip: 'حفظ تلاواتي',
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
