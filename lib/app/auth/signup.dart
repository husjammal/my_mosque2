import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/components/crud.dart';
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

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  String weekNumber = "0";
  final now = DateTime.now();

  signUp() async {
    final firstJan = DateTime(now.year, 1, 1);
    weekNumber = (weeksBetween(firstJan, now)).toString();

    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await postRequest(linkSignUp, {
        "username": username.text,
        "email": email.text,
        "password": password.text,
        "week": weekNumber,
        "subGroup": mosqueDropdownValue,
        "myGroup": dropdownValue,
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
        await ini_weekly(user_id);
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
      "activityScore": "0"
    });
    print("init result ${response['status']}");
    isLoading = false;
    setState(() {});
    if (response['status'] == "success") {
      // close sign up
      print("init success");
    } else {
      print("init Fail");
    }
  }

  ini_weekly(String user_id) async {
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkIniWeekly, {"user_id": user_id});
    print("init result ${response['status']}");
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
                  body: InkWell(
                    onTap: () {
                      signUp();
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
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: [
                      Form(
                        key: formstate,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            Image.asset(
                              "assets/images/Login.png",
                              width: 140,
                              height: 140,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            TextFormField(
                              validator: (val) {
                                return validInput(val!, 1, 10);
                              },
                              controller: username,
                              decoration: const InputDecoration(
                                  label: Text('اسم المستخدم'),
                                  prefixIcon: Icon(LineAwesomeIcons.user)),
                            ),
                            SizedBox(
                              height: 15,
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
                              height: 15,
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
                            const SizedBox(
                              height: 20,
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
                              height: 20,
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

                            const SizedBox(height: 20),
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
