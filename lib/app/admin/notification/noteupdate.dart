import 'dart:convert';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';

class NoteUpdate extends StatefulWidget {
  final note;
  const NoteUpdate({Key? key, this.note}) : super(key: key);

  @override
  _NoteUpdateState createState() => _NoteUpdateState();
}

class _NoteUpdateState extends State<NoteUpdate> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  File? _image;
  bool ischangeimage = false;

  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _myGroup = TextEditingController();
  TextEditingController _subGroup = TextEditingController();
  TextEditingController _date = TextEditingController();

  bool isLoading = false;
  bool isLoading1 = false;
  bool isLoading2 = false;

  String? mosqueDropdownValue = 'الكل';
  List<String> mosquedropdownItems = <String>['الكل', 'مسجد 1'];
  String? dropdownValue = 'الكل';
  List<String> dropdownItems = <String>['الكل', 'حلقة 1', 'حلقة 2'];
  List<String> myGroup = <String>[];

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

  editNote(String noteId) async {
    //INSERT INTO `mosque_notes`(`id`, `title`, `description`, `image`,
    // `subGroup`, `myGroup`, `date`)

    if (formstate.currentState!.validate()) {
      print("formState ${formstate.currentState!.validate()}");
      isLoading = true;
      setState(() {});
      var response;
      if (_image == null) {
        print("POST without file");

        response = await postRequest(linkAdminEditNotes, {
          "id": noteId,
          "title": _title.text,
          "description": _description.text,
          "myGroup": _myGroup.text,
          "subGroup": _subGroup.text,
          "date": _date.text,
          "image": "note.png",
          "defualtimage": "note.png"
        });
      } else {
        print("POST with file");
        // print("image ${widget.group['image']}");
        if (_image == null) {
          response = await postRequestWithFile(
              linkAdminEditNotes,
              {
                "id": noteId,
                "title": _title.text,
                "description": _description.text,
                "myGroup": _myGroup.text,
                "subGroup": _subGroup.text,
                "date": _date.text,
                "image": "note.png",
                "defualtimage": "note.png"
              },
              _image!);
        }
      }
      print('linkAdminEditNotes $linkAdminEditNotes');
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
          desc: 'تم تعديل الاشعار بنجاح',
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
            'هل تريد بالفعل حذف هذه الاشعار ؟ \n انتبة ان يكون هناك مستخدمين لها!',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          var response = await postRequest(linkDeleteNotes, {
            "id": widget.note['id'],
            "image": widget.note['image'],
            "defualtimage": "note.png"
          });
          print('linkDeleteNotes $linkDeleteNotes');
          print("group.id ${widget.note['id']}");
          print("group.imageMosque ${widget.note['image']}");
          print(response);
          if (response['status'] == 'success') {
            Navigator.of(context).pushReplacementNamed("note");
          } else {
            //
          }
        })
      ..show();
  }

  @override
  void initState() {
    _title.text = widget.note["title"];
    _description.text = widget.note["description"];
    mosqueDropdownValue = widget.note["myGroup"];
    _myGroup.text = widget.note["myGroup"];
    dropdownValue = widget.note["subGroup"];
    _subGroup.text = widget.note["subGroup"];
    _date.text = widget.note["date"];

    // TODO: implement initState
    super.initState();
    getmyGroup();
    getsubGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: buttonColor,
          centerTitle: true,
          leadingWidth: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("note", (route) => false);
              },
              icon: Icon(Icons.exit_to_app),
              tooltip: 'رجوع',
            )
          ],
          title: Text(
            "تعديل اشعار",
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: Image.asset("assets/images/note.png")),
                Text("الرجاء ادخال تعديل الاشعار:", textAlign: TextAlign.right),
                SizedBox(
                  height: 5.0,
                ),
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Form(
                  key: formstate,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _title,
                        decoration: InputDecoration(
                          labelText: 'عنوان',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال عنوان';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _title.text = value!;
                        },
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        maxLines: 5,
                        controller: _description,
                        decoration: InputDecoration(
                          labelText: 'الوصف',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخل وصف';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _description.text = value!;
                        },
                      ),

                      TextFormField(
                        controller: _date,
                        decoration: InputDecoration(
                          labelText: 'تاريخ ',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال تاريخ ';
                          }
                          return null;
                        },
                        onTap: () async {
                          final DateTime? _date1 = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          String formattedDate =
                              formatDate(_date1!, [yyyy, '/', mm, '/', dd]);
                          setState(() {
                            _date.text = formattedDate;
                          });
                        },
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
                            child: isLoading1
                                ? Center(child: CircularProgressIndicator())
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
                                        subGroup = [""];
                                        mosqueDropdownValue = newValue;
                                        _myGroup.text = newValue!;
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
                                ? Center(child: CircularProgressIndicator())
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
                                        _subGroup.text = newValue!;
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

                      Stack(
                        children: [
                          SizedBox(
                              child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: ischangeimage
                                ? Image.file(
                                    _image!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.fill,
                                  )
                                :

                                ///
                                FadeInImage.assetNetwork(
                                    image:
                                        "$linkImageRoot/${widget.note['image'].toString()}",
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.fill,
                                    placeholder: 'assets/images/note.png',
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
                                              _image = File(xfile!.path);
                                              print("xfile $xfile");
                                              print("myyyfile $_image");
                                              ischangeimage = true;
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
                                              _image = File(xfile!.path);
                                              print("xfile $xfile");
                                              print("myyyfile $_image");
                                              ischangeimage = true;
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

                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                        child: Text('تعديل الاشعار'),
                        onPressed: () {
                          // TODO: Submit form data
                          if (formstate.currentState!.validate()) {
                            formstate.currentState!.save();
                            editNote(widget.note["id"]);
                            print("success");
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
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
                                    text: _date.text,
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
      ),
    );
  }
}
