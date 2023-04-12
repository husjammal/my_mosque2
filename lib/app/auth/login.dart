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

  String? mosqueDropdownValue = 'الكل';
  List<String> mosquedropdownItems = <String>[
    'الكل',
    'مسجد 1',
    'مسجد 2',
    'مسجد 3',
    'مسجد 4',
    'مسجد 5',
    'مسجد 6',
    'مسجد 7',
    'مسجد 8',
    'مسجد 9',
    'مسجد 10',
    'مسجد 11',
    'مسجد 12',
    'مسجد 13',
    'مسجد 14',
    'مسجد 15',
    'مسجد 16',
    'مسجد 17',
    'مسجد 18',
    'مسجد 19',
    'مسجد 20'
  ];
  String? dropdownValue = 'الكل';
  List<String> dropdownItems = <String>[
    'الكل',
    'حلقة 1',
    'حلقة 2',
    'حلقة 3',
    'حلقة 4',
    'حلقة 5',
    'حلقة 6',
    'حلقة 7',
    'حلقة 8',
    'حلقة 9',
    'حلقة 10',
    'حلقة 11',
    'حلقة 12',
    'حلقة 13',
    'حلقة 14',
    'حلقة 15',
    'حلقة 16',
    'حلقة 17',
    'حلقة 18',
    'حلقة 19',
    'حلقة 20'
  ];

  login() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await postRequest(linkLogin, {
        "email": email.text,
        "password": password.text,
        "subGroup": mosqueDropdownValue,
        "myGroup": dropdownValue,
      });
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
            body: const Text(
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
                body: InkWell(
                  onTap: () {
                    Login();
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
                      Row(
                        children: [
                          Icon(
                            LineAwesomeIcons.layer_group,
                            color: Colors.grey,
                            size: 36.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 61,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              focusColor: buttonColor,
                              value: mosqueDropdownValue,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              elevation: 10,
                              // style: TextStyle(color: textColor, fontSize: 36),
                              onChanged: (String? newValue) {
                                setState(() {
                                  mosqueDropdownValue = newValue;
                                });
                              },
                              items: mosquedropdownItems
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      ////
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Icon(
                            LineAwesomeIcons.object_group,
                            color: Colors.grey,
                            size: 36.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 61,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              focusColor: buttonColor,
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              elevation: 10,
                              // style: TextStyle(color: textColor, fontSize: 36),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: dropdownItems
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      ////
                      const SizedBox(
                        height: 30,
                      ),
                      MaterialButton(
                          color: buttonColor,
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 70),
                          onPressed: () async {
                            await login();
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
