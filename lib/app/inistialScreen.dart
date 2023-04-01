import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mymosque/app/about.dart';
import 'package:mymosque/app/boarding/boarding.dart';
import 'package:mymosque/app/home.dart';
import 'package:mymosque/app/profilescreen.dart';
import 'package:mymosque/app/rank.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  String? user_name = sharedPref.getString("username");
  String? user_id = sharedPref.getString("id");

  /// bottom navigation tool bar
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  static const List<Widget> _pages = <Widget>[
    Home(),
    Rank(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: buttonColor,
            centerTitle: true,
            // leading: IconButton(
            //   icon: Icon(Icons.menu),
            //   tooltip: 'القائمة',
            //   onPressed: () {

            //   },
            // ),
            actions: [
              IconButton(
                onPressed: () {
                  sharedPref.clear();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("login", (route) => false);
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
          drawer: Drawer(
            backgroundColor: backgroundColor,

            // width: MediaQuery.of(context).size.width * 0.5,
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: const Color(0xff764abc)),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        maxRadius: 40.0,
                        backgroundColor: backgroundColor,
                        backgroundImage: AssetImage(
                          'images/ramadan.png',
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            sharedPref.getString("username").toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          Text(
                            sharedPref.getString("email").toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: const Text('الرئسية'),
                  onTap: () {
                    _selectedIndex = 0;
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.score),
                  title: const Text('التصنيف'),
                  onTap: () {
                    _selectedIndex = 1;
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: const Text('معلوماتي'),
                  onTap: () {
                    _selectedIndex = 2;
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: const Text('حول التطبيق'),
                  onTap: () {
                    // Navigator.pop(context);
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("boarding", (route) => false);
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: const Text('من نحن'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("about", (route) => false);
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: const Text('تسجيل خروج'),
                  onTap: () {
                    sharedPref.clear();
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("login", (route) => false);
                  },
                ),
              ],
            ),
          )),
    );
  }
}
