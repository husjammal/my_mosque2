import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/app/inistialScreen.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:url_launcher/url_launcher.dart';

class Version extends StatefulWidget {
  const Version({Key? key}) : super(key: key);
  _VersionState createState() => _VersionState();
}

class _VersionState extends State<Version> {
  //////////////////////////////////////////////////////////////////
  // please set the version of the software you want to puplished //
  String? software_version = '3'; //
  //////////////////////////////////////////////////////////////////

  List versionDataList = [];
  bool isLoading = false;
  String status = "Error";
  bool isLoading2 = false;

  getVersion() async {
    isLoading = true;
    var response = await postRequest(linkVersion, {
      "state": "true",
    });
    if (response['status'] == "success") {
      status = "success";
      versionDataList = response['data'] as List;
    } else {
      status = "fail";
      versionDataList = [];
    }
    isLoading = false;
    setState(() {});
    return response;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersion();
    // getVersion2();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: isLoading == true
          ? Scaffold(
              backgroundColor: backgroundColor,
              body: InkWell(
                onTap: () {
                  getVersion();
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
          : status == "success"
              ? double.parse(versionDataList[0]["version"]) >
                      double.parse(software_version!)
                  ? Scaffold(
                      backgroundColor: backgroundColor,
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/lottie/128834-info.json',
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                            Container(
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 300,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 200,
                              width: 300,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: buttonColor2,
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: const Offset(
                                      3.0,
                                      3.0,
                                    ), //Offset
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "هناك تحديث للنسخة رقم ${versionDataList[0]["version"]} !!!",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " النسخة الحالية $software_version",
                                      style: TextStyle(
                                          color: textColor2,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("الرابط  : "),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.link),
                                        InkWell(
                                          child: Text(
                                            'اضغط هنا',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onTap: () => launchUrl(Uri.parse(
                                              '${versionDataList[0]['link']}')),
                                        ),
                                      ],
                                    ),
                                    Text(""),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                "initialScreen",
                                                (route) => false);
                                      },
                                      child: Text(
                                        "لا شكرا",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  : InitialScreen()
              : Scaffold(
                  body: Text("fail"),
                ),
    );
  }
}
