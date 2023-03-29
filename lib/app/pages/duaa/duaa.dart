import 'package:flutter/material.dart';
import 'package:mymosque/components/customtextform.dart';
import 'package:mymosque/components/valid.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';

import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Creating a stateful widget to manage
// the state of the app
class Duaa extends StatefulWidget {
  const Duaa({super.key});

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
    'أشْهَدُ أنْ لا إله إِلاَّ اللَّهُ وَحْدَهُ لا شَرِيك لَهُ ، وأشْهَدُ أنَّ مُحَمَّداً عَبْدُهُ وَرَسُولُهُ ، اللَّهُمَّ اجْعَلْنِي مِنَ التَوَّابِينَ ، واجْعَلْني مِنَ المُتَطَهِّرِينَ ، سُبْحانَكَ اللَّهُمَّ وبِحَمْدِكَ ، أشْهَدُ أنْ لا إلهَ إِلاَّ أنْتَ ، أسْتَغْفِرُكَ وأتُوبُ إِلَيْكَ',
    'اللَّهمَّ لَا سَهْلَ إِلاَّ مَا جَعَلتَهُ سَهْلاً وَأَنْتَ تَجْعَلُ الحَزَنَ إِذَا شِئْتَ سَهْلاً ',
    'عند دخول الحمام : اللهم إني أَعُوذ بك من الخُبُثِ والخَبَائِث. و عند الخروج : غفرانك',
    'عند الاستيقاظ : الحَمْدُ لله الذِي أحْيَانا بَعْدَ مَا أمَاتَنَا* وإلَيْهِ النَشُور',
    'قبل النوم : اللهمَّ باسمِك أموتُ وأحيا ',
    'عند دخول المنزل : بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا، ثُمَّ لِيُسَلِّمْ عَلَى أَهْلِهِ.',
    'عند الخروج من المنزل :  بسم الله، توكلتُ على الله، ولا حولَ ولا قوةَ إلا بالله',
    'عند ركوب السيارة : سبحان الذي سخَّر لنا هذا وما كُنَّا له مُقْرِنِينَ وإنَّا إلى ربِّنا لـمُنْقَلِبُون.',
    'عند الفراغ من الطعام : الحمدُ للهِ الذي أطعَمَني هذا الطَّعامَ ورَزَقَنيه من غيرِ حولٍ مِنِّي ولا قوةٍ',
    'قبل الطعام بسم الله فإن نسِي أن يذكُرَ اسمَ اللهِ تعالى في أوَّلِهِ، فليقُلْ: بسمِ اللهِ أوَّلَهُ وآخِرَهُ.',
    'عند لبس الثوب : الحمد لله الذي كساني هذا ورزقنيه من غير حولٍ مني ولا قوّة',
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
