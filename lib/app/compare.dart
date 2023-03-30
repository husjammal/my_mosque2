import 'package:flutter/material.dart';
import 'package:mymosque/app/inistialScreen.dart';
import 'package:mymosque/app/rank.dart';
import 'package:mymosque/app/updateprofilescreen.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/scoremodel.dart';
import 'package:mymosque/model/usermodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CompareScreen extends StatefulWidget {
  final userID2;
  const CompareScreen({Key? key, this.userID2}) : super(key: key);
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  List<UserModel> userData1 = [];
  List<UserModel> userData2 = [];

  List userDataList1 = [];
  List userDataList2 = [];

  List<ScoreModel> score1 = [];
  List<ScoreModel> score2 = [];

  var dt = DateTime.now();

  bool isLoading = false;
  TooltipBehavior? _tooltipBehavior;

  void getOneUser1() async {
    isLoading = true;
    var response = await postRequest(linkViewOneUser, {
      "id": sharedPref.get("id").toString(),
    });
    userDataList1 = response['data'] as List;
    userData1 = userDataList1
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    // userData = response['data'];
    isLoading = false;
    setState(() {});
    print("userOneData1 $userData1");
  }

  void getOneUser2() async {
    isLoading = true;
    var response = await postRequest(linkViewOneUser, {
      "id": widget.userID2.toString(),
    });
    userDataList2 = response['data'] as List;
    userData2 = userDataList2
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    // userData = response['data'];
    isLoading = false;
    setState(() {});
    print("userOneData2 $userData2");
  }

  void getScore1() async {
    isLoading = true;
    setState(() {});
    print("getScore");
    var response = await postRequest(linkViewNotes,
        {"user_id": sharedPref.get("id").toString(), "day_number": "ALL"});
    print("getScore response:  $response");

    var scorelist1 = response['data'] as List;
    print("scorelist $scorelist1");
    score1 = scorelist1
        .map<ScoreModel>((json) => ScoreModel.fromJson(json))
        .toList();
    isLoading = false;
    setState(() {});

    print("List1 Size: ${score1.length}");
    print("score1");
    print("score1 $score1");
  }

  void getScore2() async {
    isLoading = true;
    setState(() {});
    print("getScore");
    var response = await postRequest(linkViewNotes,
        {"user_id": widget.userID2.toString(), "day_number": "ALL"});
    print("getScore response:  $response");

    var scorelist2 = response['data'] as List;
    print("scorelist $scorelist2");
    score2 = scorelist2
        .map<ScoreModel>((json) => ScoreModel.fromJson(json))
        .toList();
    isLoading = false;
    setState(() {});

    print("List2 Size: ${score2.length}");
    print("score2");
    print("score2 $score2");
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    print('Compare initState');
    dt = DateTime.now();
    _tooltipBehavior = TooltipBehavior(enable: true);
    getOneUser1();
    getScore1();
    print("List1 Size: ${score1.length}");
    getOneUser2();
    getScore2();
    print("List2 Size: ${score2.length}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('منافسي'),
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
        ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                  // width: 100,
                                  // height: 100,
                                  child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(
                                  "$linkImageRoot/${userData1[0].usersImage}",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              )),
                              const SizedBox(height: 10),
                              Text(userData1[0].usersName.toString(),
                                  style: Theme.of(context).textTheme.headline4),
                              Text("مجموع"),
                              Text(userData1[0].userFinalScore.toString(),
                                  style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                          /////
                          SizedBox(
                            width: 20,
                          ),
                          /////
                          Column(
                            children: [
                              SizedBox(
                                  // width: 100,
                                  // height: 100,
                                  child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(
                                  "$linkImageRoot/${userData2[0].usersImage}",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              )),
                              const SizedBox(height: 10),
                              Text(userData2[0].usersName.toString(),
                                  style: Theme.of(context).textTheme.headline4),
                              Text("مجموع"),
                              Text(userData2[0].userFinalScore.toString(),
                                  style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 10),

                      /// -- MENU
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xfff3c8fb),
                          borderRadius: BorderRadius.circular(15.0),
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
                        child: SfCartesianChart(
                            // Initialize category axis
                            primaryXAxis: CategoryAxis(),
                            // Chart title
                            title:
                                ChartTitle(text: 'مجموعي اليومي هذا الاسبوع'),
                            // Enable legend
                            legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom),

                            // Enable tooltip
                            tooltipBehavior: _tooltipBehavior,
                            // the series
                            series: <LineSeries<ScoreModel, String>>[
                              LineSeries<ScoreModel, String>(
                                  // Bind data source
                                  dataSource: score1,
                                  xValueMapper: (ScoreModel score1, _) =>
                                      score1.dayNumber,
                                  yValueMapper: (ScoreModel score1, _) =>
                                      int.parse(score1.score!),
                                  name: userData1[0].usersName.toString()),
                              LineSeries<ScoreModel, String>(
                                  // Bind data source
                                  dataSource: score2,
                                  xValueMapper: (ScoreModel score2, _) =>
                                      score2.dayNumber,
                                  yValueMapper: (ScoreModel score2, _) =>
                                      int.parse(score2.score!),
                                  name: userData2[0].usersName.toString()),
                            ]),
                      ),
                      const SizedBox(height: 20),

                      // -- BUTTON
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => InitialScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text("عودة",
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
