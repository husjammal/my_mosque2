import 'package:flutter/material.dart';
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
          leading: IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'القائمة',
            onPressed: () {},
          ),
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
          selectedIconTheme: IconThemeData(color: Colors.amberAccent, size: 24),
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
