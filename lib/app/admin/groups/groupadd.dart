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

class GroupAdd extends StatefulWidget {
  const GroupAdd({Key? key}) : super(key: key);

  _GroupAddState createState() => _GroupAddState();
}

class _GroupAddState extends State<GroupAdd> {
  //
  //UPDATE `mosque_lists` SET `id`=[value-1],
  //`myGroup`=[value-2],`subGroup`=[value-3],`description`=[value-4],
  //`imageMosque`=[value-5],`imagesubGroup`=[value-6],`date`=[value-7]
  //

  File? _imageMosque;
  File? _imagesubGroup;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController myGroup = TextEditingController();
  TextEditingController subGroup = TextEditingController();
  TextEditingController description = TextEditingController();

  String _date = "";
  bool ischangedmyGroup = false;
  bool ischangedsubGroup = false;
  bool isLoading = false;
  List groupData = [];

  addGroup() async {
    if (formstate.currentState!.validate()) {
      print("formState ${formstate.currentState!.validate()}");
      isLoading = true;
      setState(() {});
      var response;
      if (_imageMosque == null && _imagesubGroup == null) {
        print("POST without file");

        response = await postRequest(linkAddGroups, {
          "myGroup": myGroup.text,
          "subGroup": subGroup.text,
          "description": description.text,
          "imageMosque": "mosque.png",
          "imagesubGroup": "subGroup.png"
        });
      } else {
        print("POST with file");
        // print("image ${widget.group['image']}");
        if (_imageMosque == null) {
          response = await postRequestWithFile(
              linkAddGroups,
              {
                "myGroup": myGroup.text,
                "subGroup": subGroup.text,
                "description": description.text,
                "imagesubGroup": "subGroup.png",
                "defualtimage": "subGroup.png"
              },
              _imagesubGroup!);
        } else {
          response = await postRequestWithFile(
              linkAddGroups,
              {
                "myGroup": myGroup.text,
                "subGroup": subGroup.text,
                "description": description.text,
                "imageMosque": "mosque.png",
                "defualtimage": "mosque.png"
              },
              _imageMosque!);
        }
      }
      print('linkEditUsers $linkAddGroups');
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
          desc: 'تم انشاء المجموعة بنجاح',
          btnOkOnPress: () {
            debugPrint('OnClcik');
          },
          btnOkIcon: Icons.check_circle,
          // onDissmissCallback: () {
          //   debugPrint('Dialog Dissmiss from callback');
          // },
        )..show();
        markAdd();
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

  markAdd() async {
    isLoading = true;
    setState(() {});
    var response1 = await postRequest(linkAddMark, {
      "myGroup": myGroup.text,
      "subGroup": subGroup.text,
    });
    isLoading = false;
    setState(() {});
    if (response1['status'] == 'success') {
      print("ADD MARK SUCCESS");
    } else {
      print("ADD MARK FAIL");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('اضافة مجموعة'),
            centerTitle: true,
            backgroundColor: buttonColor,
            leadingWidth: 0.0,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("group", (route) => false);
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
                  SizedBox(height: 50.0),
                  // -- IMAGE with ICON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                              child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: ischangedmyGroup
                                ? Image.file(
                                    _imageMosque!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.fill,
                                  )
                                : FadeInImage.assetNetwork(
                                    image: "$linkImageRoot/mosque.png",
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.fill,
                                    placeholder: 'assets/images/mosque.png',
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
                                                  fontSize: 22,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          ListTile(
                                            leading: new Icon(Icons.photo),
                                            title: new Text('من المعرض'),
                                            onTap: () async {
                                              XFile? xfile = await ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              Navigator.pop(context);
                                              _imageMosque = File(xfile!.path);
                                              print("xfile $xfile");
                                              print("myyyfile $_imageMosque");
                                              ischangedmyGroup = true;
                                              setState(() {});
                                            },
                                          ),
                                          ListTile(
                                            leading: new Icon(Icons.camera),
                                            title: new Text('من الكميرا'),
                                            onTap: () async {
                                              XFile? xfile = await ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              Navigator.pop(context);
                                              _imageMosque = File(xfile!.path);
                                              print("xfile $xfile");
                                              print("myyyfile $_imageMosque");
                                              ischangedmyGroup = true;
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

                      const SizedBox(width: 20),

                      ///
                      /// the subgroup picture
                      ///
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          SizedBox(
                              child: ClipRRect(
                            borderRadius: BorderRadius.circular(70.0),
                            child: ischangedsubGroup
                                ? Image.file(
                                    _imagesubGroup!,
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.fill,
                                  )
                                : FadeInImage.assetNetwork(
                                    image: "$linkImageRoot/subGroup.png",
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.fill,
                                    placeholder: 'assets/images/subGroup.png',
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
                                                  fontSize: 22,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          ListTile(
                                            leading: new Icon(Icons.photo),
                                            title: new Text('من المعرض'),
                                            onTap: () async {
                                              XFile? xfile = await ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              Navigator.pop(context);
                                              _imagesubGroup =
                                                  File(xfile!.path);
                                              print("xfile $xfile");
                                              print("myyyfile $_imagesubGroup");
                                              ischangedsubGroup = true;
                                              setState(() {});
                                            },
                                          ),
                                          ListTile(
                                            leading: new Icon(Icons.camera),
                                            title: new Text('من الكميرا'),
                                            onTap: () async {
                                              XFile? xfile = await ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              Navigator.pop(context);
                                              _imagesubGroup =
                                                  File(xfile!.path);
                                              print("xfile $xfile");
                                              print("myyyfile $_imagesubGroup");
                                              ischangedsubGroup = true;
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
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: buttonColor),
                                child: const Icon(LineAwesomeIcons.camera,
                                    color: Colors.black, size: 15),
                              ),
                            ),
                          ),
                        ],
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
                            return validInput(val!, 1, 15);
                          },
                          controller: myGroup,
                          // initialValue:
                          //     sharedPref.getString("myGroup").toString(),
                          decoration: const InputDecoration(
                              label: Text('اسم المسجد'),
                              prefixIcon: Icon(LineAwesomeIcons.user)),
                        ),
                        const SizedBox(height: 30 - 20),
                        TextFormField(
                          validator: (val) {
                            return validInput(val!, 1, 15);
                          },
                          controller: subGroup,
                          decoration: const InputDecoration(
                              label: Text("اسم الحلقة"),
                              prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
                        ),
                        const SizedBox(height: 30 - 20),
                        TextFormField(
                          validator: (val) {
                            return validInput(val!, 1, 250);
                          },
                          controller: description,
                          decoration: const InputDecoration(
                              label: Text("الوصف"),
                              prefixIcon: Icon(LineAwesomeIcons.phone)),
                        ),
                        const SizedBox(height: 30),

                        // -- Form Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              print("edit user");
                              print("myfile1 $_imageMosque");
                              print("myfile2 $_imagesubGroup");

                              await addGroup();
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
                                : const Text("انشاء المجموعة",
                                    style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ));
  }
}
