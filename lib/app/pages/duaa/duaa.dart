import 'package:flutter/material.dart';
import 'package:mymosque/components/customtextform.dart';
import 'package:mymosque/components/valid.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';

import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mymosque/constant/colorConfig.dart';

import 'package:carousel_slider/carousel_slider.dart';

// Creating a stateful widget to manage
// the state of the app
class Duaa extends StatefulWidget {
  @override
  _DuaaState createState() => _DuaaState();
}

class _DuaaState extends State<Duaa> {
////////////
  List imgList = [
    'images/Duaa-1.png',
    'images/Duaa-2.png',
    'images/Duaa-3.png',
    'images/Duaa-4.png',
    'images/Duaa-5.png',
    'images/Duaa-6.png',
    'images/Duaa-7.png',
    'images/Duaa-8.png',
    'images/Duaa-9.png',
    'images/Duaa-10.png',
    'images/Duaa-11.png',
  ];
  List duaaList = [
    'قبل الوضوء : بسم الله . و بعد الوضوء اشهد ان لا الة الا الله وحده لا شريك له، و اشهد ان محمدا عبده و رسوله. اللهم اجعلني من التوابيين و اجعلني من المتطهرين',
    'اللهم لا سهل الا ما جعلته سهلا. و انت تجعل الحزن اذا شئت سهلا',
    'عند دخول الحمام : اللهم اني اعوذ بك من الخبث و الخبائث. و عند الخروج : غفرانك',
    'عند الاستيقاظ : الحمد لله الذي احيانا بعد ما اماتنا و الية النشور',
    'قبل النوم : باسمك اللهم اموت و احيا',
    'عند دخول المنزل : بسم الله ولجنا و بسم الله خرجنا و على الله ربنا توكلنا. ثم يسلم على اهله.',
    'عند الخروج من المنزل : بسم الله توكلت على الله و لا حول و لا قوة الا بالله',
    'عند ركوب السيارة : سبحان الذي سخر لنا هذا و ما كنا ل مقرنين و انا الى ربنا لمنقلبون.',
    'عند الفراغ من الطعام : الحمد لله الذي اطعمني هذا و رزقنيه من غير حول لي و لا قوة',
    'قبل الطعام بسم الله فإن نسي في اوله فليقل بسم الله في أوله و اخرة.',
    'عند لبس الثوب : الحمد لله الذي كساني هذا و رزقنيه من غير حول لي و لا قوة',
  ];
  int _index = 0;
  TextEditingController _DuaaScore = TextEditingController();
// Fuction to save Duaaers
  bool isLoading = false;
  int duaaScore = 0;
  String _score = "0";
  String _duaaScore = "0";
  String _prayScore = "0";
  String _quranScore = "0";
  String _activityScore = "0";

  save_Duaa(String user_id) async {
    _score = (int.parse(_quranScore) +
            int.parse(_DuaaScore.text) +
            int.parse(_prayScore) +
            int.parse(_activityScore))
        .toString();
    print('_score $_score');

    isLoading = true;
    setState(() {});
    var response = await postRequest(linkDuaa, {
      "user_id": user_id,
      "day_number": dt.weekday.toString(),
      "score": _score,
      "duaaScore": _DuaaScore.text,
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

  getDuaaScore() async {
    var response = await postRequest(linkViewNotes, {
      "user_id": sharedPref.getString("id"),
      "day_number": dt.weekday.toString(),
    });
    _DuaaScore.text = response['data'][0]['duaaScore'].toString();
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
    print('duaa initState');
    getDuaaScore();
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
          title: Text('قائمة الادعية'),
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
                  height: MediaQuery.of(context).size.height,
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
                            'images/Duaa_logo1.png',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CarouselSlider.builder(
                          itemCount: imgList.length,
                          itemBuilder: (context, index, realIndex) {
                            return GestureDetector(
                              onTap: () {
                                print("Tapped  " + imgList[index]);
                                _index = index;
                                setState(() {});
                              },
                              child: Container(
                                //height: 5,
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      imgList[index].toString(),
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 200.0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 100,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: buttonColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(duaaList[_index],
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width:
                              (MediaQuery.of(context).size.width * 1 / 2) - 20,
                          child: CustomTextFormSign(
                            valid: (val) {
                              return validInput(val!, 1, 3);
                            },
                            mycontroller: _DuaaScore,
                            hint: "علامتي للدعاء من 10",
                          ),
                        ),
                        SizedBox(
                          width: 25.0,
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
            await save_Duaa(user_id.toString());
            Navigator.of(context)
                .pushNamedAndRemoveUntil("initialScreen", (route) => false);
          },
          tooltip: 'حفظ دعائي',
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
