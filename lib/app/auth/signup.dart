import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/components/customtextform.dart';
import 'package:mymosque/components/valid.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formstate = GlobalKey();
  String? user_id;
  bool isLoading = false;
  bool pinWasObscured = true;

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signUp() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await postRequest(linkSignUp, {
        "username": username.text,
        "email": email.text,
        "password": password.text
      });
      isLoading = false;
      print('isLoading $isLoading');

      setState(() {});

      if (response['status'] == "success") {
        var response2 = await postRequest(
            linkLogin, {"email": email.text, "password": password.text});
        String user_id = response2['data']['id'].toString();
        print(response2['status']);
        print(response2);
        print('user id for ini_val $user_id');
        print("set ini");
        await ini_val(user_id);
        // close sign up
        Navigator.of(context)
            .pushNamedAndRemoveUntil("success", (route) => false);
      } else {
        print("SignUp Fail");
      }
    }
  }

  ini_val(String user_id) async {
    isLoading = true;
    setState(() {});

    var response = await postRequest(linkInitual, {
      "user_id": user_id,
      "score": "0",
      "subuh": "0",
      "zhur": "0",
      "asr": "0",
      "magrib": "0",
      "isyah": "0",
      "quranRead": "0",
      "quranLearn": "0",
      "quranListen": "0",
      "duaaScore": "0",
      "prayScore": "0",
      "quranScore": "0",
    });
    isLoading = false;
    setState(() {});
    if (response['status'] == "success") {
      // close sign up
      print("init success");
    } else {
      print("init Fail");
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
                  child: ListView(
                    children: [
                      Form(
                        key: formstate,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Image.asset(
                              "images/Login.png",
                              width: 200,
                              height: 200,
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                              validator: (val) {
                                return validInput(val!, 1, 40);
                              },
                              controller: username,
                              decoration: const InputDecoration(
                                  label: Text('اسم المستخدم'),
                                  prefixIcon: Icon(LineAwesomeIcons.user)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (val) {
                                return validInput(val!, 1, 250);
                              },
                              controller: email,
                              decoration: const InputDecoration(
                                  label: Text("الايميل"),
                                  prefixIcon:
                                      Icon(LineAwesomeIcons.envelope_1)),
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
                            const SizedBox(height: 30),
                            MaterialButton(
                              color: buttonColor,
                              textColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 15),
                              onPressed: () async {
                                await signUp();
                              },
                              child: Text("انشاء حساب",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0)),
                            ),
                            Container(height: 10),
                            InkWell(
                              child: Text("تسجيل دخول",
                                  style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("login");
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}
