import 'package:flutter/material.dart';
import 'package:mymosque/app/inistialScreen.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';

class Version extends StatefulWidget {
  const Version({Key? key}) : super(key: key);
  _VersionState createState() => _VersionState();
}

class _VersionState extends State<Version> {
  //////////////////////////////////////////////////////////////////
  // please set the version of the software you want to puplished //
  String? software_version = '0'; //
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
              body: Center(
                  child: CircularProgressIndicator(
                backgroundColor: backgroundColor,
                color: buttonColor,
              )))
          : status == "success"
              ? double.parse(versionDataList[0]["version"]) >
                      double.parse(software_version!)
                  ? Scaffold(
                      backgroundColor: backgroundColor,
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.update_outlined,
                              size: 70,
                              color: Colors.redAccent,
                            ),
                            Container(
                              child: Image.asset(
                                'images/logo.png',
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
                                color: buttonColor,
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
                                  children: <Widget>[
                                    Text(
                                      "هناك تحديث!!!",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(""),
                                    Text("الرابط هو : "),
                                    InkWell(
                                      onTap: () {},
                                      child: Text(
                                        " ${versionDataList[0]['link']}",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
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
                                            fontSize: 10.0,
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
