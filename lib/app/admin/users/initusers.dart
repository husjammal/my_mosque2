import 'package:flutter/material.dart';
import 'package:mymosque/app/admin/users/student.dart';
import 'package:mymosque/app/admin/users/studentAddCSV2.dart';
import 'package:mymosque/app/admin/users/studentaddCSV.dart';
import 'package:mymosque/app/admin/users/teachers.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';

class InitUsers extends StatefulWidget {
  const InitUsers({Key? key}) : super(key: key);
  _InitUsersState createState() => _InitUsersState();
}

class _InitUsersState extends State<InitUsers> {
  String? user_name = sharedPref.getString("username");
  String? user_id = sharedPref.getString("id");

  /// bottom navigation tool bar
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  static const List<Widget> _pages = <Widget>[
    Student(),
    Teacher(),
    // CSVUploader(),
    CSVImportScreen(),
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
          leadingWidth: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("adminhome", (route) => false);
              },
              icon: Icon(Icons.exit_to_app),
              tooltip: 'رجوع',
            )
          ],
          title: Text(
            "ادارة المستخدمين",
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
          selectedIconTheme: IconThemeData(color: textColor, size: 24),
          selectedItemColor: textColor,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedIconTheme: IconThemeData(
            color: buttonColor2,
          ),
          unselectedItemColor: buttonColor2,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'المستخدمين',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.score),
              label: 'المشرفين',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_copy),
              label: 'استيراد',
            ),
          ],
        ),
      ),
    );
  }
}
