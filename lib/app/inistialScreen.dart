import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mymosque/app/home.dart';
import 'package:mymosque/app/pages/duaa/duaa.dart';
import 'package:mymosque/app/pages/pray/pray.dart';
import 'package:mymosque/app/pages/quran/quran.dart';
import 'package:mymosque/app/profilescreen.dart';
import 'package:mymosque/app/rank.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';

import 'package:url_launcher/url_launcher.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  String? user_name = sharedPref.getString("username");
  String? user_id = sharedPref.getString("id");

  String? software_version = '1';

  /// bottom navigation tool bar
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool isLoading = false;
  List versionDataList = [];

  void getVersion() async {
    isLoading = true;
    var response = await postRequest(linkVersion, {
      "state": "true",
    });
    print(response);
    if (response['status'] == "success") {
      versionDataList = response['data'] as List;
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        borderSide: BorderSide(color: Colors.green, width: 2),
        buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
        headerAnimationLoop: false,
        animType: AnimType.BOTTOMSLIDE,
        title: 'معلومات',
        desc: 'هناك مشكلة في الاتصال بالسيرفر ...',
        showCloseIcon: true,
        btnCancelOnPress: () {
          sharedPref.clear();
          Navigator.of(context)
              .pushNamedAndRemoveUntil("login", (route) => false);
        },
        btnOkOnPress: () {
          getVersion();
        },
      )..show();
    }
    isLoading = false;
    setState(() {});
    print("versionData List $versionDataList");
  }

  @override
  void initState() {
    // TODO: implement initState
    print("the version check");
    super.initState();

    getVersion();
  }

  static const List<Widget> _pages = <Widget>[
    Home(),
    Rank(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: backgroundColor,
            child: Center(child: CircularProgressIndicator()),
          )
        : double.parse(versionDataList[0]["version"]) >
                double.parse(software_version!)
            ? Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                    backgroundColor: backgroundColor,
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.update_outlined,
                            size: 70,
                            color: Colors.redAccent,
                          ),
                          Container(
                            child: Image.asset(
                              'images/logo.png',
                              width: 300,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 200,
                            width: 300,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: buttonColor,
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
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "هناك تحديث!!!",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(""),
                                  Text("الرابط هو : "),
                                  InkWell(
                                    onTap: () {},
                                    child: Text(
                                      " ${versionDataList[0]['link']}",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(""),
                                  InkWell(
                                    onTap: () {
                                      software_version =
                                          versionDataList[0]["version"];
                                      setState(() {});
                                    },
                                    child: Text(
                                      "لا شكرا",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )))
            : Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  backgroundColor: backgroundColor,
                  appBar: AppBar(
                    backgroundColor: buttonColor,
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(Icons.menu),
                      tooltip: 'القائمة',
                      onPressed: () {},
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          sharedPref.clear();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "login", (route) => false);
                        },
                        icon: Icon(Icons.exit_to_app),
                        tooltip: 'تسجيل خروج',
                      ),
                    ],
                    title: Text(
                      "جامعي",
                    ),
                  ),
                  body: _pages.elementAt(_selectedIndex),
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: backgroundColor,
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                    elevation: 0,
                    iconSize: 20,
                    mouseCursor: SystemMouseCursors.grab,
                    selectedFontSize: 12,
                    selectedIconTheme:
                        IconThemeData(color: Colors.amberAccent, size: 24),
                    selectedItemColor: Colors.amberAccent,
                    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                    unselectedIconTheme: IconThemeData(
                      color: Colors.deepPurpleAccent,
                    ),
                    unselectedItemColor: Colors.deepPurpleAccent,
                    showSelectedLabels: true,
                    showUnselectedLabels: false,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'الرئيسية',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.score),
                        label: 'التصنيف',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'معلوماتي',
                      ),
                    ],
                  ),
                ),
              );
  }
}
