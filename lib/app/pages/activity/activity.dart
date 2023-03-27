import 'package:flutter/material.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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

  bool? _isFootBall = false;
  bool? _isCricket = false;
  bool? _isVolleyBall = false;
  bool? _isKabaddi = false;
  bool? _isBaseball = false;
  bool? _isBasketBall = false;
  bool? _isOther = false;

// Fuction to save prayers
  bool isLoading = false;
  int quranScore = 0;
  String _score = "0";
  String _duaaScore = "0";
  String _prayScore = "0";
  String _quranScore = "0";
  var dt = DateTime.now();

  save_activity(String user_id) async {
    // calculate the quranScore
    quranScore = 0;
    _score =
        (int.parse(_prayScore) + quranScore + int.parse(_duaaScore)).toString();
    print('_score $_score');
    // save the database
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkActivity, {
      "user_id": user_id,
      "day_number": dt.weekday.toString(),
      "score": _score,
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

  getActivityNotes() async {
    var response = await postRequest(linkViewNotes, {
      "user_id": sharedPref.getString("id"),
      "day_number": dt.weekday.toString(),
    });
    print(response);
    _score = response['data'][0]['score'].toString();
    _duaaScore = response['data'][0]['duaaScore'].toString();
    _prayScore = response['data'][0]['prayScore'].toString();
    _quranScore = response['data'][0]['quranScore'].toString();

    setState(() {});
    return response;
  }

  @override
  void initState() {
    // TODO: implement initState
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
          title: Text('بعض من نشاطاتي'),
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
                      'images/activity.jpg',
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 120,
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: buttonColor,
                      image: const DecorationImage(
                        image: AssetImage('images/avtivity_layout.jpg'),
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
                                title: Text(
                                  "جيد رضى الوالدين",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _isFootBall,
                                secondary: Icon(Icons.animation),
                                onChanged: (value) {
                                  setState(() {
                                    _isFootBall = value;
                                    String selectVal = "جيد رضى الوالدين";
                                    value!
                                        ? _list.add(selectVal)
                                        : _list.remove(selectVal);
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text(
                                  "صيام اليوم",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _isBaseball,
                                secondary: Icon(Icons.animation),
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    _isBaseball = value;
                                    String selectVal = "صيام اليوم";
                                    value!
                                        ? _list.add(selectVal)
                                        : _list.remove(selectVal);
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text(
                                  "صدقة",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _isCricket,
                                secondary: Icon(Icons.animation),
                                onChanged: (value) {
                                  setState(() {
                                    _isCricket = value;
                                    String selectVal = "صدقة";
                                    value!
                                        ? _list.add(selectVal)
                                        : _list.remove(selectVal);
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text(
                                  "مئة تسابيح",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _isKabaddi,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                secondary: Icon(Icons.animation),
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                onChanged: (value) {
                                  setState(() {
                                    _isKabaddi = value;
                                    String selectVal = "مئة تسابيح";
                                    value!
                                        ? _list.add(selectVal)
                                        : _list.remove(selectVal);
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text(
                                  "مئة استغفار",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _isBasketBall,
                                controlAffinity:
                                    ListTileControlAffinity.platform,
                                secondary: Icon(Icons.animation),
                                onChanged: (value) {
                                  setState(() {
                                    _isBasketBall = value;
                                    String selectVal = "مئة استغفار";
                                    value!
                                        ? _list.add(selectVal)
                                        : _list.remove(selectVal);
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text(
                                  "مئة صلاة على النبي",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _isVolleyBall,
                                secondary: Icon(Icons.animation),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Colors.green,
                                checkColor: Colors.amber,
                                onChanged: (value) {
                                  setState(() {
                                    _isVolleyBall = value;
                                    String selectVal = "مئة صلاة على النبي";
                                    value!
                                        ? _list.add(selectVal)
                                        : _list.remove(selectVal);
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text(
                                  "عبدات اخرى",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: _isOther,
                                secondary: Icon(Icons.offline_bolt),
                                activeColor: Colors.red,
                                checkColor: Colors.yellow,
                                subtitle: Text("نشطات غير المذكورة في الاعلى",
                                    style: TextStyle(color: Colors.grey)),
                                onChanged: (value) {
                                  setState(() {
                                    _isOther = value;
                                    String selectVal = "عبدات اخرى";
                                    value!
                                        ? _list.add(selectVal)
                                        : _list.remove(selectVal);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Center(
                            child: _list.isEmpty
                                ? Text("")
                                : RichText(
                                    text: TextSpan(
                                        text: "نشاطاتي هي :\n",
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                        TextSpan(
                                            text: '${_list.toString()} ',
                                            style: TextStyle(fontSize: 16)),
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
