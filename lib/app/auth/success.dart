import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
          SizedBox(
            width: 100,
            height: 150,
            child: Lottie.asset(
              'assets/lottie/141356-man-goes-to-the-mosque-on-ramadan.json',
              width: 100,
              height: 150,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: Text(
              "تم انشاء الحساب بنجاح الان يمكنك تسجيل الدخول",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 20.0,
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
