import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mymosque/app/updateprofilescreen.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/profilemenuwidget.dart';
import 'package:mymosque/model/scoremodel.dart';
import 'package:mymosque/model/usermodel.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<UserModel> userData = [];
  List userDataList = [];
  List<ScoreModel> score = [];
  var dt = DateTime.now();
  bool isLoading = false;
  TooltipBehavior? _tooltipBehavior;

  void getOneUser() async {
    isLoading = true;
    var response = await postRequest(linkViewOneUser, {
      "id": sharedPref.getString("id"),
    });
    userDataList = response['data'] as List;
    userData = userDataList
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    // userData = response['data'];
    isLoading = false;
    setState(() {});
    print("userOneData $userData");
  }

  void getScore() async {
    isLoading = true;
    setState(() {});
    print("getScore");
    var response = await postRequest(linkViewNotes,
        {"user_id": sharedPref.getString("id"), "day_number": "ALL"});
    print("getScore response:  $response");

    var scorelist = response['data'] as List;
    print("scorelist $scorelist");
    score =
        scorelist.map<ScoreModel>((json) => ScoreModel.fromJson(json)).toList();
    isLoading = false;
    setState(() {});

    print("List Size: ${score.length}");
    print("score");
    print("score $score");
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    print('profile initState');
    dt = DateTime.now();
    _tooltipBehavior = TooltipBehavior(enable: true);
    getOneUser();
    getScore();
    print("List Size: ${score.length}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    /// -- IMAGE
                    Stack(
                      children: [
                        SizedBox(
                            // width: 100,
                            // height: 100,
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.network(
                            "$linkImageRoot/${userData[0].usersImage}",
                            width: 100,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                        )

                            // Positioned(
                            //   bottom: 0,
                            //   right: 0,
                            //   child: Container(
                            //     width: 35,
                            //     height: 35,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(100),
                            //         color: backgroundColor),
                            //     child: const Icon(
                            //       LineAwesomeIcons.alternate_pencil,
                            //       color: Colors.black,
                            //       size: 20,
                            //     ),
                            //   ),
                            // ),
                            ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(userData[0].usersName.toString(),
                        style: Theme.of(context).textTheme.headline4),
                    Text(userData[0].usersEmail.toString(),
                        style: Theme.of(context).textTheme.bodyText2),
                    const SizedBox(height: 20),

                    /// -- BUTTON
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          print("user: ${userDataList[0]}");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UpdateProfileScreen(user: userDataList[0])));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("تعديل معلوماتك",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 10),

                    /// -- MENU
                    SfCartesianChart(
                        // Initialize category axis
                        primaryXAxis: CategoryAxis(),
                        // Chart title
                        title: ChartTitle(text: 'مجموعي اليومي هذا الاسبوع'),
                        // Enable legend
                        // legend: Legend(isVisible: true),
                        // Enable tooltip
                        tooltipBehavior: _tooltipBehavior,
                        series: <LineSeries<ScoreModel, String>>[
                          LineSeries<ScoreModel, String>(
                              // Bind data source
                              dataSource: score,
                              xValueMapper: (ScoreModel score, _) =>
                                  score.day_number,
                              yValueMapper: (ScoreModel score, _) =>
                                  int.parse(score.score!))
                        ]),
                  ],
                ),
              ),
            ),
    );
  }
}
