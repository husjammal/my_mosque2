import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/app/inistialScreen.dart';
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
    // isLoading = false;
    // setState(() {});
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
    // isLoading = false;
    // setState(() {});
    print("userOneData2 $userData2");
  }

  void getScore1() async {
    // isLoading = true;
    // setState(() {});
    print("getScore 1");
    print("the id is ${sharedPref.get("id").toString()}");
    var response = await postRequest(linkViewActions,
        {"user_id": sharedPref.get("id").toString(), "day_number": "ALL"});
    print("getScore response:  $response");

    var scorelist1 = response['data'] as List;
    print("scorelist $scorelist1");
    score1 = scorelist1
        .map<ScoreModel>((json) => ScoreModel.fromJson(json))
        .toList();
    // isLoading = false;
    // setState(() {});

    print("List1 Size: ${score1.length}");
    print("score1");
    print("score1 $score1");
  }

  void getScore2() async {
    // isLoading = true;
    // setState(() {});
    print("getScore");
    var response = await postRequest(linkViewActions,
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
                body: InkWell(
                  onTap: () {
                    getOneUser1();
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
                                  "$linkImageRoot/${userData1[0].usersImage.toString()}",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              )),
                              const SizedBox(height: 10),
                              Text(userData1[0].usersName.toString(),
                                  style: Theme.of(context).textTheme.headline4),
                              Divider(
                                thickness: 1.0,
                                height: 1.0,
                                color: textColor2,
                              ),
                              Text("الاوسمة"),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                alignment: Alignment.centerRight,
                                width: 120.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: buttonColor2,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.electric_bolt,
                                      color: buttonColor,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData1[0]
                                              .userTotalScore
                                              .toString(),
                                        ),
                                        Text(
                                          "المجموع الكلي",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: 120.0,
                                height: 50.0,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: buttonColor2,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LineAwesomeIcons.first_order,
                                      color: buttonColor,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData1[0].usernumBadge.toString(),
                                        ),
                                        Text(
                                          "المراكز الثالثة الاولى",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                alignment: Alignment.centerRight,
                                width: 120.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: buttonColor2,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LineAwesomeIcons.pray,
                                      color: buttonColor,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData1[0]
                                              .usernumprayBadge
                                              .toString(),
                                        ),
                                        Text(
                                          "اولي الصلاة",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: 120.0,
                                height: 50.0,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: buttonColor2,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LineAwesomeIcons.quran,
                                      color: buttonColor,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData1[0]
                                              .usernumquranBadge
                                              .toString(),
                                        ),
                                        Text(
                                          "اولى القران",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
                              Divider(
                                thickness: 1.0,
                                height: 1.0,
                                color: textColor2,
                              ),
                              Text("الاوسمة"),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                alignment: Alignment.centerRight,
                                width: 120.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: buttonColor2,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.electric_bolt,
                                      color: buttonColor,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData2[0]
                                              .userTotalScore
                                              .toString(),
                                        ),
                                        Text(
                                          "المجموع الكلي",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: 120.0,
                                height: 50.0,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: buttonColor2,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LineAwesomeIcons.first_order,
                                      color: buttonColor,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData2[0].usernumBadge.toString(),
                                        ),
                                        Text(
                                          "المراكز الثالثة الاولى",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                alignment: Alignment.centerRight,
                                width: 120.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: buttonColor2,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LineAwesomeIcons.pray,
                                      color: buttonColor,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData2[0]
                                              .usernumprayBadge
                                              .toString(),
                                        ),
                                        Text(
                                          "اولي الصلاة",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: 120.0,
                                height: 50.0,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: buttonColor2,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LineAwesomeIcons.quran,
                                      color: buttonColor,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData2[0]
                                              .usernumquranBadge
                                              .toString(),
                                        ),
                                        Text(
                                          "اولى القران",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(
                        thickness: 1.0,
                        height: 1.0,
                        color: textColor2,
                      ),
                      const SizedBox(height: 10),
                      Text("الاحصائيات",
                          style: TextStyle(
                              fontSize: 10.0,
                              color: textColor2,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10.0,
                      ),

                      /// -- MENU
                      Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
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
                                  xValueMapper: (ScoreModel score, _) => score
                                              .dayNumber ==
                                          "1"
                                      ? "اث"
                                      : score.dayNumber == "2"
                                          ? "ثلا"
                                          : score.dayNumber == "3"
                                              ? "ارب"
                                              : score.dayNumber == "4"
                                                  ? "خمي"
                                                  : score.dayNumber == "5"
                                                      ? "جمع"
                                                      : score.dayNumber == "6"
                                                          ? "سبت"
                                                          : score.dayNumber ==
                                                                  "7"
                                                              ? "احد"
                                                              : "",
                                  yValueMapper: (ScoreModel score1, _) =>
                                      int.parse(score1.score!),
                                  name: userData1[0].usersName.toString()),
                              LineSeries<ScoreModel, String>(
                                  // Bind data source
                                  dataSource: score2,
                                  xValueMapper: (ScoreModel score, _) => score
                                              .dayNumber ==
                                          "1"
                                      ? "اث"
                                      : score.dayNumber == "2"
                                          ? "ثلا"
                                          : score.dayNumber == "3"
                                              ? "ارب"
                                              : score.dayNumber == "4"
                                                  ? "خمي"
                                                  : score.dayNumber == "5"
                                                      ? "جمع"
                                                      : score.dayNumber == "6"
                                                          ? "سبت"
                                                          : score.dayNumber ==
                                                                  "7"
                                                              ? "احد"
                                                              : "",
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
                              style: TextStyle(color: Colors.white)),
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
