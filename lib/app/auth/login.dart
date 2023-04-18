import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/components/valid.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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
  bool _isSwitchedOn = false;

  login() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await postRequest(linkLogin, {
        "email": email.text,
        "password": password.text,
      });
      isLoading = false;
      setState(() {});
      if (response['status'] == "success") {
        sharedPref.setString("id", response['data']['id'].toString());
        _isSwitchedOn
            ? sharedPref.setString("userType", "admin")
            : sharedPref.setString("userType", "user");
        sharedPref.setString("username", response['data']['username']);
        sharedPref.setString("email", response['data']['email']);
        sharedPref.setString("image", response['data']['image']);
        sharedPref.setString("subGroup", response['data']['subGroup']);
        sharedPref.setString("myGroup", response['data']['myGroup']);

        Navigator.of(context)
            .pushNamedAndRemoveUntil("initialScreen", (route) => false);
        print('logged in');
      } else {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            headerAnimationLoop: false,
            animType: AnimType.TOPSLIDE,
            showCloseIcon: true,
            closeIcon: Icon(Icons.close_fullscreen_outlined),
            title: 'تنبيه',
            desc: 'البريد الالكتروني او كلمة المرور خطأ او الحساب غير موجود',
            // btnCancelOnPress: () {},
            btnOkOnPress: () {})
          ..show();
      }
    }
  }

  adminlogin() async {
    print("admin logging in");
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await postRequest(linkAdminLogin, {
        "email": email.text,
        "password": password.text,
      });
      isLoading = false;
      setState(() {});
      if (response['status'] == "success") {
        sharedPref.setString("id", response['data']['id'].toString());
        _isSwitchedOn
            ? sharedPref.setString("userType", "admin")
            : sharedPref.setString("userType", "user");
        sharedPref.setString("username", response['data']['username']);
        sharedPref.setString("email", response['data']['email']);
        sharedPref.setString("image", response['data']['image']);
        sharedPref.setString("subGroup", response['data']['subGroup']);
        sharedPref.setString("myGroup", response['data']['myGroup']);

        Navigator.of(context)
            .pushNamedAndRemoveUntil("adminhome", (route) => false);
        print('logged in');
      } else {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            headerAnimationLoop: false,
            animType: AnimType.TOPSLIDE,
            showCloseIcon: true,
            closeIcon: Icon(Icons.close_fullscreen_outlined),
            title: 'تنبيه',
            desc: 'البريد الالكتروني او كلمة المرور خطأ او الحساب غير موجود',
            // btnCancelOnPress: () {},
            btnOkOnPress: () {})
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
                body: InkWell(
                  onTap: () {
                    _isSwitchedOn ? login() : adminlogin();
                  },
                  child: Center(
                    child: Lottie.asset(
                      'assets/lottie/60089-eid-mubarak.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )
            : Container(
                color: backgroundColor,
                padding: const EdgeInsets.all(10),
                child: ListView(children: [
                  Form(
                    key: formstate,
                    child: Column(children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Image.asset(
                        'assets/images/Login.png',
                        width: 170,
                        height: 170,
                      ),
                      const SizedBox(
                        height: 30,
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
                      const SizedBox(
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
                                ? const Icon(Icons.visibility_off_outlined)
                                : const Icon(Icons.visibility_outlined),
                            onPressed: () {
                              setState(() {
                                pinWasObscured = !pinWasObscured;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 150.0,
                        child: SwitchListTile(
                          title: Text(_isSwitchedOn ? 'مشرف' : "مستخدم",
                              style: TextStyle(
                                  color: buttonColor, fontSize: 12.0)),
                          value: _isSwitchedOn,
                          onChanged: (bool value) {
                            setState(() {
                              print("_isSwitchedOn $_isSwitchedOn");
                              _isSwitchedOn = value;
                            });
                          },
                          // subtitle: Text(_isSwitchedOn ? "مسجدي" : "حلقتي"),
                          // secondary: const Icon(Icons.filter),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      MaterialButton(
                          color: buttonColor,
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 70),
                          onPressed: () async {
                            _isSwitchedOn == false
                                ? await login()
                                : await adminlogin();
                          },
                          child: const Text("تسجيل دخول",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0))),
                      Container(
                        height: 10,
                      ),
                      InkWell(
                        child: const Text("انشاء حساب",
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
