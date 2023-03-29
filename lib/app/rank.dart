import 'package:flutter/material.dart';
import 'package:mymosque/app/compare.dart';
import 'package:mymosque/components/carduser.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/usermodel.dart';

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

  bool isLoading = false;

  save_TotalScore() async {
    // calculate the total score
    // save the database
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkScoreUsers, {
      "user_id": sharedPref.getString("id"),
      "finalScore": sharedPref.getString('finalScore'),
      "totalScore": sharedPref.getString('totalScore'),
    });
    isLoading = false;
    setState(() {});
  }

  var dt = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('rank initState');

    var dt = DateTime.now();

    save_TotalScore();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                      userData.sort((a, b) => int.parse(b['finalScore'])
                          .compareTo(int.parse(a['finalScore'])));

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
                        child: Text("جاري التحميل ..."),
                      );
                    }
                    return Center(
                      child: Text("خطأ في التحميل ..."),
                    );
                  })
              //CardUsers(ontap: () {}, title: "title", content: "content")
            ],
          ),
        ),
      ),
    );
  }
}
