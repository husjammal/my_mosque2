import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/components/customtextform.dart';
import 'package:mymosque/components/valid.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mymosque/constant/colorConfig.dart';

import 'package:mymosque/main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool pinWasObscured = true;
  login() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await postRequest(
          linkLogin, {"email": email.text, "password": password.text});
      isLoading = false;
      setState(() {});
      if (response['status'] == "success") {
        sharedPref.setString("id", response['data']['id'].toString());
        sharedPref.setString("username", response['data']['username']);
        sharedPref.setString("email", response['data']['email']);
        Navigator.of(context)
            .pushNamedAndRemoveUntil("initialScreen", (route) => false);
        print('logged in');
      } else {
        AwesomeDialog(
            context: context,
            title: "تنبيه",
            body: Text(
                "البريد الالكتروني او كلمة المرور خطأ او الحساب غير موجود"))
          ..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: isLoading == true
            ? Scaffold(
                backgroundColor: backgroundColor,
                body: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: backgroundColor,
                  color: buttonColor,
                )))
            : Container(
                color: backgroundColor,
                padding: EdgeInsets.all(10),
                child: ListView(children: [
                  Form(
                    key: formstate,
                    child: Column(children: [
                      SizedBox(
                        height: 50,
                      ),
                      Image.asset(
                        'images/Login.png',
                        width: 200,
                        height: 200,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        validator: (val) {
                          return validInput(val!, 1, 250);
                        },
                        controller: email,
                        decoration: const InputDecoration(
                            label: Text("الايميل"),
                            prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (val) {
                          return validInput(val!, 1, 250);
                        },
                        controller: password,
                        obscureText: pinWasObscured,
                        decoration: InputDecoration(
                          label: const Text("كلمة السر"),
                          prefixIcon: const Icon(Icons.fingerprint),
                          suffixIcon: IconButton(
                            icon: pinWasObscured
                                ? Icon(Icons.visibility_off_outlined)
                                : Icon(Icons.visibility_outlined),
                            onPressed: () {
                              setState(() {
                                pinWasObscured = !pinWasObscured;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      MaterialButton(
                          color: buttonColor,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 70),
                          onPressed: () async {
                            await login();
                          },
                          child: Text("تسجيل دخول",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0))),
                      Container(
                        height: 10,
                      ),
                      InkWell(
                        child: Text("انشاء حساب",
                            style: TextStyle(color: Colors.black)),
                        onTap: () {
                          Navigator.of(context).pushNamed("signup");
                        },
                      )
                    ]),
                  ),
                ]),
              ),
      ),
    );
  }
}
