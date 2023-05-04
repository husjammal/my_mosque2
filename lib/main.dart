import 'package:flutter/material.dart';

import 'package:mymosque/app/about.dart';
import 'package:mymosque/app/admin/adminhome.dart';
import 'package:mymosque/app/admin/groups/grouphome.dart';
import 'package:mymosque/app/admin/notification/notehome.dart';
import 'package:mymosque/app/admin/races/racehome.dart';
import 'package:mymosque/app/admin/users/initusers.dart';
import 'package:mymosque/app/auth/login.dart';
import 'package:mymosque/app/auth/signup.dart';
import 'package:mymosque/app/auth/success.dart';
import 'package:mymosque/app/boarding/boarding.dart';
import 'package:mymosque/app/home.dart';
import 'package:mymosque/app/inistialScreen.dart';
import 'package:mymosque/app/pages/quran/quran.dart';
import 'package:mymosque/app/setting.dart';
import 'package:mymosque/app/profilescreen.dart';
import 'package:mymosque/app/splash.dart';
import 'package:mymosque/app/version.dart';
import 'package:mymosque/app/weekresult.dart';
import 'package:mymosque/constant/colorConfig.dart';

import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Application name
      title: 'My Mosque',
      // Application theme data, you can set the colors for the application as
      // you want

      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: buttonColor,
        primarySwatch: Colors.green,
      ),
      // A widget which will be started on application startup
      initialRoute: sharedPref.getString("id") == null
          ? "login"
          : sharedPref.getString("userType") == "admin"
              ? "adminhome"
              : "splash",
      routes: {
        'login': (context) => const Login(),
        'signup': (context) => const SignUp(),
        'initialScreen': (context) => const InitialScreen(),
        'success': (context) => const Success(),
        'profilescreen': (context) => const ProfileScreen(),
        'splash': (context) => SplashPage(),
        'boarding': (context) => Boarding(),
        'about': (context) => AboutUsPage(),
        'quran': (context) => Quran(),
        'home': (context) => Home(),
        'setting': (context) => SettingPage(),
        'weekresult': (context) => WeekResult(),
        'version': (context) => Version(),
        'adminhome': (context) => AdminHome(),
        'group': (context) => Group(),
        "intiuser": (context) => InitUsers(),
        "race": (context) => Race(),
        "note": (context) => Note(),
      },
    );
  }
}
