import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/components/valid.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/usermodel.dart';
import 'dart:convert';

class StudentEdit extends StatefulWidget {
  final user;
  const StudentEdit({Key? key, this.user}) : super(key: key);

  _StudentEditState createState() => _StudentEditState();
}

class _StudentEditState extends State<StudentEdit> {
  ///UPDATE `mosque_user` SET `id`=[value-1],`username`=[value-2],`email`=[value-3],`password`=[value-4],`phone`=[value-5],
  ///`image`=[value-6],`joinedAt`=[value-7],`finalScore`=[value-8],`finalprayScore`=[value-9],`finalsunahScore`=[value-10],
  ///`finalnuafelScore`=[value-11],`finalquranScore`=[value-12],`finalactivityScore`=[value-13],`week`=[value-14],
  ///`isWeekChange`=[value-15],`totalScore`=[value-16],`badge`=[value-17],`praybadge`=[value-18],`quranbadge`=[value-19],
  ///`numBadge`=[value-20],`numprayBadge`=[value-21],`numquranBadge`=[value-22],`subGroup`=[value-23],`myGroup`=[value-24] WHERE 1
  ///
  File? myfile;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  // TextEditingController subGroup = TextEditingController();
  // TextEditingController myGroup = TextEditingController();

  String joinedAt = "";
  bool ischanged = false;
  bool isLoading = false;
  List<UserModel> userData = [];

  bool pinWasObscured = true;

  editUser() async {
    if (formstate.currentState!.validate()) {
      print("formState ${formstate.currentState!.validate()}");
      isLoading = true;
      setState(() {});
      var response;
      if (myfile == null) {
        print("POST without file");
        print("image ${widget.user['image']}");
        response = await postRequest(linkAdminEditUsers, {
          "id": widget.user['id'],
          "username": username.text,
          "email": email.text,
          "password": password.text,
          "phone": phone.text,
          "subGroup": dropdownValue,
          "myGroup": mosqueDropdownValue,
          "image": widget.user['image'],
        });
      } else {
        print("POST with file");
        print("image ${widget.user['image']}");
        response = await postRequestWithFile(
            linkAdminEditUsers,
            {
              "id": widget.user['id'],
              "username": username.text,
              "email": email.text,
              "password": password.text,
              "phone": phone.text,
              "subGroup": dropdownValue,
              "myGroup": mosqueDropdownValue,
              "image": widget.user['image'],
            },
            myfile!);
      }
      print('linkEditUsers $linkEditUsers');
      print(response);
      isLoading = false;
      setState(() {});
      if (response['status'] == 'success') {
        AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.SUCCES,
          title: 'تم',
          desc: 'تم تحديث البيانات بنجاح',
          btnOkOnPress: () {
            debugPrint('OnClcik');
          },
          btnOkIcon: Icons.check_circle,
          // onDissmissCallback: () {
          //   debugPrint('Dialog Dissmiss from callback');
          // },
        )..show();
      } else {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: false,
            title: 'خطأ',
            desc: 'يوجد خطأ بتحديث المعلومات',
            btnOkOnPress: () {},
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red)
          ..show();
      }
    }
  }

  onDelete() async {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        headerAnimationLoop: false,
        animType: AnimType.TOPSLIDE,
        showCloseIcon: true,
        closeIcon: Icon(Icons.close_fullscreen_outlined),
        title: 'تنبية',
        desc: 'هل تريد بالفعل حذف حسابك ؟ \n سوف تخسر جميع نقاطك!',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          var response = await postRequest(linkDeleteUsers, {
            "userid": sharedPref.getString("id"),
            "image": sharedPref.getString("image"),
            "defualtimage": "user.png"
          });
          print('linkDeleteNotes $linkDeleteUsers');
          print("user.id ${sharedPref.getString("id")}");
          print("user.image ${sharedPref.getString("image")}");
          print(response);
          if (response['status'] == 'success') {
            sharedPref.clear();
            Navigator.of(context).pushReplacementNamed("login");
          } else {
            //
          }
        })
      ..show();
  }

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
  List<String> myGroup = <String>[];
  bool isLoading1 = true;
  getmyGroup() async {
    isLoading1 = true;
    setState(() {});
    var response = await postRequest(linkmyGroups, {});
    if (response['status'] == "success") {
      // convert each item to a string by using JSON encoding
      final jsonList =
          response['data'].map((item) => jsonEncode(item)).toList();
      // using toSet - toList strategy
      final uniqueJsonList = jsonList.toSet().toList();
      // convert each item back to the original form using JSON decoding
      final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
      // for loop with item index
      for (var i = 0; i < result.length; i++) {
        myGroup.add(result[i]["myGroup"].toString());
      }
      mosquedropdownItems = myGroup;
      isLoading1 = false;
      setState(() {});
      return response;
    } else {
      isLoading1 = false;
      setState(() {});
      return response;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.SCALE,
        title: 'خطأ',
        desc: 'هناك خطأ في التحميل',
        autoHide: Duration(seconds: 2),
      )..show();
    }
  }

  List<String> subGroup = <String>[];
  bool isLoading2 = false;
  getsubGroup() async {
    isLoading2 = true;
    setState(() {});
    var response2 =
        await postRequest(linksubGroups, {"myGroup": mosqueDropdownValue});
    if (response2['status'] == "success") {
      // convert each item to a string by using JSON encoding
      final jsonList2 =
          response2['data'].map((item) => jsonEncode(item)).toList();
      // using toSet - toList strategy
      final uniqueJsonList2 = jsonList2.toSet().toList();
      // convert each item back to the original form using JSON decoding
      final result2 = uniqueJsonList2.map((item) => jsonDecode(item)).toList();
      // for loop with item index
      for (var i = 0; i < result2.length; i++) {
        subGroup.add(result2[i]["subGroup"].toString());
      }
      dropdownItems = subGroup;
      isLoading2 = false;
      setState(() {});
      return response2;
    } else {
      isLoading2 = false;
      setState(() {});
      return response2;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.SCALE,
        title: 'خطأ',
        desc: 'هناك خطأ في التحميل',
        autoHide: Duration(seconds: 2),
      )..show();
    }
  }

  @override
  void initState() {
    username.text = widget.user['username'];
    email.text = widget.user['email'];
    password.text = widget.user['password'];
    phone.text = widget.user['phone'];
    dropdownValue = widget.user['subGroup'];
    mosqueDropdownValue = widget.user['myGroup'];
    joinedAt = widget.user['joinedAt'].toString();

    getmyGroup();
    getsubGroup();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(ProfileController());
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('معلوماتي'),
            centerTitle: true,
            backgroundColor: buttonColor,
            leading: IconButton(
              icon: Icon(Icons.menu),
              tooltip: 'قائمة',
              onPressed: () {},
            ),
            actions: [
              IconButton(
                onPressed: () {
                  int _selectedIndex = 3;
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("intiuser", (route) => false);
                },
                icon: Icon(Icons.exit_to_app),
                tooltip: 'رجوع',
              )
            ], //IconButton
          ),
          body: SingleChildScrollView(
            child: Container(
              color: backgroundColor,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // -- IMAGE with ICON
                  Stack(
                    children: [
                      SizedBox(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child:
                            /////
                            ischanged
                                ? Image.file(
                                    myfile!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.fill,
                                  )
                                :

                                ///
                                FadeInImage.assetNetwork(
                                    image:
                                        "$linkImageRoot/${widget.user['image'].toString()}",
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.fill,
                                    placeholder: 'assets/images/avatar.png',
                                  ),
                      )),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              // elevation: 100.0,
                              context: context,
                              builder: (context) => Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  color: backgroundColor,
                                  height: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "الرجاء اختيار صورة :",
                                          style: TextStyle(
                                              fontSize: 22, color: Colors.grey),
                                        ),
                                      ),
                                      ListTile(
                                        leading: new Icon(Icons.photo),
                                        title: new Text('من المعرض'),
                                        onTap: () async {
                                          XFile? xfile = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          Navigator.pop(context);
                                          myfile = File(xfile!.path);
                                          print("xfile $xfile");
                                          print("myyyfile $myfile");
                                          ischanged = true;
                                          setState(() {});
                                        },
                                      ),
                                      ListTile(
                                        leading: new Icon(Icons.camera),
                                        title: new Text('من الكميرا'),
                                        onTap: () async {
                                          XFile? xfile = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.camera);
                                          Navigator.pop(context);
                                          myfile = File(xfile!.path);
                                          print("xfile $xfile");
                                          print("myyyfile $myfile");
                                          ischanged = true;
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: buttonColor),
                            child: const Icon(LineAwesomeIcons.camera,
                                color: Colors.black, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),

                  // -- Form Fields
                  Form(
                    key: formstate,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) {
                            return validInput(val!, 1, 10);
                          },
                          controller: username,
                          decoration: const InputDecoration(
                              label: Text('اسم المستخدم'),
                              prefixIcon: Icon(LineAwesomeIcons.user)),
                        ),
                        const SizedBox(height: 30 - 20),
                        TextFormField(
                          validator: (val) {
                            return validInput(val!, 1, 250);
                          },
                          controller: email,
                          decoration: const InputDecoration(
                              label: Text("الايميل"),
                              prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
                        ),
                        const SizedBox(height: 30 - 20),
                        TextFormField(
                          validator: (val) {
                            return validInput(val!, 1, 250);
                          },
                          controller: phone,
                          decoration: const InputDecoration(
                              label: Text("رقم الهاتف"),
                              prefixIcon: Icon(LineAwesomeIcons.phone)),
                        ),
                        const SizedBox(height: 30 - 20),
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
                        const SizedBox(height: 30 - 20),
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
                              child: isLoading1
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : DropdownButton<String>(
                                      isExpanded: true,
                                      focusColor: buttonColor,
                                      value: mosqueDropdownValue,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 36,
                                      elevation: 10,
                                      // style: TextStyle(color: textColor, fontSize: 36),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          // To Do
                                          subGroup = [""];
                                          mosqueDropdownValue = newValue;
                                          getsubGroup();
                                          dropdownValue = "";
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
                              child: isLoading2
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : DropdownButton<String>(
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
                        const SizedBox(height: 30),

                        // -- Form Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              print("edit user");
                              print("myfile $myfile");
                              await editUser();
                              // Navigator.of(context).pushNamedAndRemoveUntil(
                              //     "initialScreen", (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                side: BorderSide.none,
                                shape: const StadiumBorder()),
                            child: isLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : const Text("تعديل معلومات",
                                    style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // -- Created Date and Delete Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "انضم ",
                                style: TextStyle(fontSize: 12),
                                children: [
                                  TextSpan(
                                      text: "في ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                  TextSpan(
                                      text: joinedAt,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await onDelete();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.redAccent.withOpacity(0.1),
                                  elevation: 0,
                                  foregroundColor: Colors.red,
                                  shape: const StadiumBorder(),
                                  side: BorderSide.none),
                              child: const Text("حذف"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
