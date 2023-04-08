import 'package:flutter/material.dart';
import 'package:mymosque/app/compare.dart';
import 'package:mymosque/components/carduser.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/usermodel.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';

class Rank extends StatefulWidget {
  const Rank({Key? key}) : super(key: key);
  _RankState createState() => _RankState();
}

class _RankState extends State<Rank> {
  getUsers() async {
    var response = await postRequest(linkViewUsers, {
      "id": sharedPref.getString("id"),
      "day_number": dt.weekday.toString(),
    });
    return response;
  }

  String sortColumn = "finalScore";
  String rankName = "كلي";

  var dt = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('rank initState');

    dt = DateTime.now();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 160.0,
          backgroundColor: backgroundColor,
          centerTitle: true,
          actions: const [],
          title: Column(
            children: [
              Image.asset(
                'assets/images/compare_bannar.png',
                height: 50.0,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "باقي لنهاية تحدي الاسبوع ${8 - int.parse(dt.weekday.toString())} يوم!",
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Column(
                      children: [
                        Icon(Icons.favorite, size: 15.0),
                        Text(
                          "كلي",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                    onTap: () {
                      sortColumn = 'finalScore';
                      rankName = "كلي";
                      setState(() {});
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Icon(Icons.favorite, size: 15.0),
                        Text(
                          "صلاة",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                    onTap: () {
                      sortColumn = 'finalprayScore';
                      rankName = "صلاة";
                      setState(() {});
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Icon(Icons.favorite, size: 15.0),
                        Text(
                          "سنن",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                    onTap: () {
                      sortColumn = 'finalsunahScore';
                      rankName = "سنن";
                      setState(() {});
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Icon(Icons.favorite, size: 15.0),
                        Text(
                          "نوافل",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                    onTap: () {
                      sortColumn = 'finalnuafelScore';
                      rankName = "نوافل";
                      setState(() {});
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Icon(Icons.favorite, size: 15.0),
                        Text(
                          "قران",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                    onTap: () {
                      sortColumn = 'finalquranScore';
                      rankName = "قران";
                      setState(() {});
                    },
                  ),
                  InkWell(
                    highlightColor: Colors.green,
                    child: Column(
                      children: [
                        Icon(Icons.favorite, size: 15.0),
                        Text(
                          "نشاط",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                    onTap: () {
                      sortColumn = 'finalactivityScore';
                      rankName = "نشاط";
                      setState(() {});
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(" التصنيف حسب $rankName"),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              FutureBuilder(
                  future: getUsers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // sort the score
                      List userData = snapshot.data['data'];
                      // userData.sort((a, b) => int.parse(b['finalScore'])
                      //     .compareTo(int.parse(a['finalScore'])));
                      // /////////////////////////////
                      userData.sort((a, b) {
                        int cmp = int.parse(b[sortColumn])
                            .compareTo(int.parse(a[sortColumn]));
                        if (cmp != 0) return cmp;
                        return int.parse(b['totalScore'])
                            .compareTo(int.parse(a['totalScore']));
                      });
                      if (snapshot.data['status'] == 'fail')
                        return Center(
                            child: Text(
                          "لايوجد مشتركين",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ));
                      return ListView.builder(
                          itemCount: snapshot.data['data'].length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return CardUsers(
                              ontap: () {
                                print(snapshot.data['data'][i]['id']);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CompareScreen(
                                          userID2: snapshot.data['data'][i]
                                              ['id'],
                                        )));
                              },
                              usermodel:
                                  UserModel.fromJson(snapshot.data['data'][i]),
                              rank_index: i,
                            );
                          });
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          children: [
                            Text("جاري التحميل ..."),
                            Lottie.asset(
                              'assets/lottie/93603-loading-lottie-animation.json',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      child: Center(
                        child: Column(
                          children: [
                            Text("خطأ في التحميل ..."),
                            Lottie.asset(
                              'assets/lottie/52108-error.json',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
