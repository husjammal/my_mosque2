import 'package:flutter/material.dart';
import 'package:mymosque/constant/colorConfig.dart';

class Success extends StatefulWidget {
  const Success({Key? key}) : super(key: key);
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "تم انشاء الحساب بنجاح الان يمكنك تسجيل الدخول",
              style: TextStyle(fontSize: 20),
            ),
          ),
          MaterialButton(
              textColor: Colors.white,
              color: buttonColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              child: Text("تسجيل الدخول"))
        ],
      ),
    );
  }
}
