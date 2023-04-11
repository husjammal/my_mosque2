import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/app/updateprofilescreen.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/scoremodel.dart';
import 'package:mymosque/model/usermodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

  String? _group1SelectedValue;

  void getOneUser(String userID) async {
    isLoading = true;
    var response = await postRequest(linkViewOneUser, {
      "id": userID,
    });
    userDataList = response['data'] as List;
    userData = userDataList
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
    // userData = response['data'];
    isLoading = false;
    setState(() {});
    // print("userOneData $userData");
  }

  void getScore(String userID) async {
    isLoading = true;
    setState(() {});
    // print("getScore");
    var response = await postRequest(
        linkViewNotes, {"user_id": userID, "day_number": "ALL"});
    // print("getScore response:  $response");

    var scorelist = response['data'] as List;
    // print("scorelist $scorelist");
    score =
        scorelist.map<ScoreModel>((json) => ScoreModel.fromJson(json)).toList();
    isLoading = false;
    setState(() {});

    // print("List Size: ${score.length}");
    // print("score");
    // print("score $score");
  }

  @override
  void initState() {
    super.initState();
    // print('profile initState');
    dt = DateTime.now();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _group1SelectedValue = "1";

    getOneUser(sharedPref.getString("id").toString());
    getScore(sharedPref.getString("id").toString());
    // print("List Size: ${score.length}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? Scaffold(
              backgroundColor: backgroundColor,
              body: InkWell(
                onTap: () {
                  getOneUser(sharedPref.getString("id").toString());
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.network(
                        "$linkImageRoot/${userData[0].usersImage}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
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
                          // print("user: ${userDataList[0]}");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UpdateProfileScreen(user: userDataList[0])));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("تعديل معلوماتك",
                            style: TextStyle(color: backgroundColor)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(
                      thickness: 1.0,
                      height: 1.0,
                    ),
                    const SizedBox(height: 10),

                    /// -- MENU
                    SizedBox(
                      height: 100.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(children: [
                            Text("اليومي"),
                            Radio(
                                value: "1",
                                groupValue: _group1SelectedValue,
                                onChanged: _group1Changes),
                          ]),
                          Column(children: [
                            Text("الاسبوعي"),
                            Radio(
                                value: "2",
                                groupValue: _group1SelectedValue,
                                onChanged: _group1Changes),
                          ]),
                          Column(children: [
                            Text("نسبي"),
                            Radio(
                                value: "3",
                                groupValue: _group1SelectedValue,
                                onChanged: _group1Changes),
                          ]),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(
                              3.0,
                              3.0,
                            ), //Offset
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],
                      ),
                      child: _group1SelectedValue == "1"
                          ? SfCartesianChart(
                              // Initialize category axis
                              primaryXAxis: CategoryAxis(),
                              // Chart title
                              title:
                                  ChartTitle(text: 'مجموعي اليومي هذا الاسبوع'),
                              // Enable legend
                              // legend: Legend(isVisible: true),
                              // Enable tooltip
                              tooltipBehavior: _tooltipBehavior,
                              series: <LineSeries<ScoreModel, String>>[
                                  LineSeries<ScoreModel, String>(
                                    // Bind data source
                                    dataSource: score,
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

                                    yValueMapper: (ScoreModel score, _) =>
                                        int.parse(score.score!),
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true),
                                  ),
                                ])
                          : _group1SelectedValue == "2"
                              ? SfCartesianChart(
                                  // Initialize category axis
                                  primaryXAxis: CategoryAxis(),
                                  // Chart title
                                  title: ChartTitle(text: 'مجموعي الاسبوعي'),
                                  // Enable legend
                                  // legend: Legend(isVisible: true),
                                  // Enable tooltip
                                  tooltipBehavior: _tooltipBehavior,
                                  series: <AreaSeries<ScoreModel, String>>[
                                      AreaSeries<ScoreModel, String>(
                                          // Bind data source
                                          dataSource: score,
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
                                                          : score.dayNumber ==
                                                                  "5"
                                                              ? "جمع"
                                                              : score.dayNumber ==
                                                                      "6"
                                                                  ? "سبت"
                                                                  : score.dayNumber ==
                                                                          "7"
                                                                      ? "احد"
                                                                      : "",
                                          yValueMapper: (ScoreModel score, _) =>
                                              int.parse(score.score!),
                                          dataLabelSettings: DataLabelSettings(
                                              isVisible: true)),
                                    ])
                              : SfCartesianChart(
                                  // Initialize category axis
                                  primaryXAxis: CategoryAxis(),
                                  // Chart title
                                  title: ChartTitle(text: 'مجموعي النسبي'),
                                  // Enable legend
                                  legend: Legend(
                                      isVisible: true,
                                      position: LegendPosition.bottom),
                                  // Enable tooltip
                                  tooltipBehavior: _tooltipBehavior,
                                  series: <ColumnSeries<ScoreModel, String>>[
                                      ColumnSeries<ScoreModel, String>(
                                          // Bind data source
                                          dataSource: score,
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
                                                          : score.dayNumber ==
                                                                  "5"
                                                              ? "جمع"
                                                              : score.dayNumber ==
                                                                      "6"
                                                                  ? "سبت"
                                                                  : score.dayNumber ==
                                                                          "7"
                                                                      ? "احد"
                                                                      : "",
                                          yValueMapper: (ScoreModel score, _) =>
                                              int.parse(score.prayScore!),
                                          name: "صلاة",
                                          dataLabelSettings: DataLabelSettings(
                                              isVisible: true)),
                                      ColumnSeries<ScoreModel, String>(
                                          // Bind data source
                                          dataSource: score,
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
                                                          : score.dayNumber ==
                                                                  "5"
                                                              ? "جمع"
                                                              : score.dayNumber ==
                                                                      "6"
                                                                  ? "سبت"
                                                                  : score.dayNumber ==
                                                                          "7"
                                                                      ? "احد"
                                                                      : "",
                                          yValueMapper: (ScoreModel score, _) =>
                                              int.parse(score.quranScore!),
                                          name: "قران",
                                          dataLabelSettings: DataLabelSettings(
                                              isVisible: true)),
                                      ColumnSeries<ScoreModel, String>(
                                          // Bind data source
                                          dataSource: score,
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
                                                          : score.dayNumber ==
                                                                  "5"
                                                              ? "جمع"
                                                              : score.dayNumber ==
                                                                      "6"
                                                                  ? "سبت"
                                                                  : score.dayNumber ==
                                                                          "7"
                                                                      ? "احد"
                                                                      : "",
                                          yValueMapper: (ScoreModel score, _) =>
                                              int.parse(score.duaaScore!),
                                          name: "دعاء",
                                          dataLabelSettings: DataLabelSettings(
                                              isVisible: true)),
                                      ColumnSeries<ScoreModel, String>(
                                          // Bind data source
                                          dataSource: score,
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
                                                          : score.dayNumber ==
                                                                  "5"
                                                              ? "جمع"
                                                              : score.dayNumber ==
                                                                      "6"
                                                                  ? "سبت"
                                                                  : score.dayNumber ==
                                                                          "7"
                                                                      ? "احد"
                                                                      : "",
                                          yValueMapper: (ScoreModel score, _) =>
                                              int.parse(score.sunahScore!),
                                          name: "سنن",
                                          dataLabelSettings: DataLabelSettings(
                                              isVisible: true)),
                                      ColumnSeries<ScoreModel, String>(
                                          // Bind data source
                                          dataSource: score,
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
                                                          : score.dayNumber ==
                                                                  "5"
                                                              ? "جمع"
                                                              : score.dayNumber ==
                                                                      "6"
                                                                  ? "سبت"
                                                                  : score.dayNumber ==
                                                                          "7"
                                                                      ? "احد"
                                                                      : "",
                                          yValueMapper: (ScoreModel score, _) =>
                                              int.parse(score.nuafelScore!),
                                          name: "نوافل",
                                          dataLabelSettings: DataLabelSettings(
                                              isVisible: true)),
                                      ColumnSeries<ScoreModel, String>(
                                          // Bind data source
                                          dataSource: score,
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
                                                          : score.dayNumber ==
                                                                  "5"
                                                              ? "جمع"
                                                              : score.dayNumber ==
                                                                      "6"
                                                                  ? "سبت"
                                                                  : score.dayNumber ==
                                                                          "7"
                                                                      ? "احد"
                                                                      : "",
                                          yValueMapper: (ScoreModel score, _) =>
                                              int.parse(score.activityScore!),
                                          name: "نشاط",
                                          dataLabelSettings: DataLabelSettings(
                                              isVisible: true)),
                                    ]),
                    ),

                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }

  void _group1Changes(String? value) {
    setState(() {
      _group1SelectedValue = value;
    });
  }
}
