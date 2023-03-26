import 'package:flutter/material.dart';
import 'package:mymosque/app/auth/login.dart';
import 'package:mymosque/app/auth/signup.dart';
import 'package:mymosque/app/auth/success.dart';
import 'package:mymosque/app/inistialScreen.dart';
import 'package:mymosque/app/profilescreen.dart';
import 'package:mymosque/app/splash.dart';
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
        primaryColor: Color(0xff9a55f4),
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.purple)),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.yellowAccent),
        errorColor: Colors.yellow,
      ),
      // A widget which will be started on application startup
      initialRoute: sharedPref.getString("id") == null ? "login" : "splash",
      routes: {
        'login': (context) => Login(),
        'signup': (context) => SignUp(),
        'initialScreen': (context) => InitialScreen(),
        'success': (context) => Success(),
        'profilescreen': (context) => ProfileScreen(),
        'splash': (context) => SplashPage(),

        // 'addnotes': (context) => AddNotes(),
        // 'editnotes': (context) => EditNotes(),
      },
    );
  }
}
