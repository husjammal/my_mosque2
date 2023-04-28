import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/components/valid.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/model/usermodel.dart';

class GroupUpdate extends StatefulWidget {
  final group;
  const GroupUpdate({Key? key, this.group}) : super(key: key);

  _GroupUpdateState createState() => _GroupUpdateState();
}

class _GroupUpdateState extends State<GroupUpdate> {
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

  editGroup() async {
    if (formstate.currentState!.validate()) {
      print("formState ${formstate.currentState!.validate()}");
      isLoading = true;
      setState(() {});
      var response;
      if (_imageMosque == null && _imagesubGroup == null) {
        print("POST without file");

        response = await postRequest(linkEditGroups, {
          "id": widget.group['id'],
          "myGroup": myGroup.text,
          "subGroup": subGroup.text,
          "description": description.text,
          "imageMosque": widget.group['imageMosque'],
          "imagesubGroup": widget.group['imagesubGroup'],
        });
      } else {
        print("POST with file");
        // print("image ${widget.group['image']}");
        if (_imageMosque == null) {
          response = await postRequestWithFile(
              linkEditGroups,
              {
                "id": widget.group['id'],
                "myGroup": myGroup.text,
                "subGroup": subGroup.text,
                "description": description.text,
                "imagesubGroup": widget.group['imagesubGroup'],
                "defualtimage": "subGroup.png"
              },
              _imagesubGroup!);
        } else {
          response = await postRequestWithFile(
              linkEditGroups,
              {
                "id": widget.group['id'],
                "myGroup": myGroup.text,
                "subGroup": subGroup.text,
                "description": description.text,
                "imageMosque": widget.group['imageMosque'],
                "defualtimage": "mosque.png"
              },
              _imageMosque!);
        }
      }
      print('linkEditUsers $linkEditGroups');
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
          desc: 'تم تعديل المجموعة بنجاح',
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
        desc:
            'هل تريد بالفعل حذف هذه المجموعة ؟ \n انتبة ان يكون هناك مستخدمين فيها!',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          var response = await postRequest(linkDeleteGroups, {
            "id": widget.group['id'],
            "image": widget.group['imageMosque'],
            "defualtimage": "mosque.png"
          });
          print('linkDeleteNotes $linkDeleteGroups');
          print("group.id ${widget.group['id']}");
          print("group.imageMosque ${widget.group['imageMosque']}");
          print(response);
          if (response['status'] == 'success') {
            Navigator.of(context).pushReplacementNamed("group");
          } else {
            //
          }
        })
      ..show();
  }

  @override
  void initState() {
    myGroup.text = widget.group['myGroup'];
    subGroup.text = widget.group['subGroup'];
    description.text = widget.group['description'];
    _date = widget.group['date'];
    // imageMosque = widget.group['imageMosque'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(ProfileController());
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('تعديل معلومات المجموعة'),
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
                  const SizedBox(height: 50),
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
                                :

                                ///
                                FadeInImage.assetNetwork(
                                    image:
                                        "$linkImageRoot/${widget.group['imageMosque'].toString()}",
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
                  const SizedBox(height: 30),
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
                              print("myfile $_imageMosque");
                              await editGroup();
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
                                : const Text("تعديل معلوماتي",
                                    style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(height: 50),

                        // -- Created Date and Delete Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "انشات",
                                style: TextStyle(fontSize: 12),
                                children: [
                                  TextSpan(
                                      text: "في ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                  TextSpan(
                                      text: _date,
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
                        const SizedBox(height: 100),
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
