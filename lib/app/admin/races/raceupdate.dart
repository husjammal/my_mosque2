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

class RaceUpdate extends StatefulWidget {
  final race;
  const RaceUpdate({Key? key, this.race}) : super(key: key);

  @override
  _RaceUpdateState createState() => _RaceUpdateState();
}

class _RaceUpdateState extends State<RaceUpdate> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  File? _image;
  bool ischangeimage = false;

  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _mark = TextEditingController();
  TextEditingController _startDate = TextEditingController();
  TextEditingController _endDate = TextEditingController();
  TextEditingController _myGroup = TextEditingController();
  TextEditingController _subGroup = TextEditingController();
  TextEditingController _createdBy = TextEditingController();

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

  editRace(String raceId) async {
    //INSERT INTO `mosque_races`(`id`, `title`, `description`, `mark`, `startDate`, `endDate`,
    // `myGroup`, `subGroup`, `image`, `createdby`)

    if (formstate.currentState!.validate()) {
      print("formState ${formstate.currentState!.validate()}");
      isLoading = true;
      setState(() {});
      var response;
      if (_image == null) {
        print("POST without file");

        response = await postRequest(linkAdminEditRaces, {
          "id": raceId,
          "title": _title.text,
          "description": _description.text,
          "mark": _mark.text,
          "startDate": _startDate.text,
          "endDate": _endDate.text,
          "myGroup": _myGroup.text,
          "subGroup": _subGroup.text,
          "createdby": _createdBy.text,
          "image": "races.png",
          "defualtimage": "races.png"
        });
      } else {
        print("POST with file");
        // print("image ${widget.group['image']}");
        if (_image == null) {
          response = await postRequestWithFile(
              linkAdminEditRaces,
              {
                "id": raceId,
                "title": _title.text,
                "description": _description.text,
                "mark": _mark.text,
                "startDate": _startDate.text,
                "endDate": _endDate.text,
                "myGroup": _myGroup.text,
                "subGroup": _subGroup.text,
                "createdby": _createdBy.text,
                "image": "races.png",
                "defualtimage": "races.png"
              },
              _image!);
        }
      }
      print('linkAddRace $linkAddRaces');
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
          desc: 'تم تعديل المسابقة بنجاح',
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
            'هل تريد بالفعل حذف هذه المسابقة ؟ \n انتبة ان يكون هناك مستخدمين لها!',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          var response = await postRequest(linkDeleteRaces, {
            "id": widget.race['id'],
            "image": widget.race['image'],
            "defualtimage": "races.png"
          });
          print('linkDeleteNotes $linkDeleteGroups');
          print("group.id ${widget.race['id']}");
          print("group.imageMosque ${widget.race['image']}");
          print(response);
          if (response['status'] == 'success') {
            Navigator.of(context).pushReplacementNamed("race");
          } else {
            //
          }
        })
      ..show();
  }

  @override
  void initState() {
    _title.text = widget.race["title"];
    _description.text = widget.race["description"];
    _mark.text = widget.race["mark"];
    _startDate.text = widget.race["startDate"];
    _endDate.text = widget.race["endDate"];
    mosqueDropdownValue = widget.race["myGroup"];
    _myGroup.text = widget.race["myGroup"];
    dropdownValue = widget.race["subGroup"];
    _subGroup.text = widget.race["subGroup"];
    _createdBy.text = widget.race["createdby"];
    // _image = widget.race["image"];

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
                    .pushNamedAndRemoveUntil("race", (route) => false);
              },
              icon: Icon(Icons.exit_to_app),
              tooltip: 'رجوع',
            )
          ],
          title: Text(
            "تعديل مسابقة",
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/races.png"),
                Text("الرجاء ادخال تعديل المسابقة:",
                    textAlign: TextAlign.right),
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
                        controller: _mark,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'علامة',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال علامة';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _mark.text = value!;
                        },
                      ),
                      TextFormField(
                        controller: _startDate,
                        decoration: InputDecoration(
                          labelText: 'تاريخ البدء',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال تاريخ البدء';
                          }
                          return null;
                        },
                        onTap: () async {
                          final DateTime? _date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          String formattedDate =
                              formatDate(_date!, [yyyy, '/', mm, '/', dd]);
                          setState(() {
                            _startDate.text = formattedDate;
                          });
                        },
                      ),
                      TextFormField(
                        controller: _endDate,
                        decoration: InputDecoration(
                          labelText: 'تاريخ الانتهاء',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال تاريخ الانتهاء';
                          }
                          return null;
                        },
                        onTap: () async {
                          final DateTime? _date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          String formattedDate =
                              formatDate(_date!, [yyyy, '/', mm, '/', dd]);
                          setState(() {
                            _endDate.text = formattedDate;
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
                                        "$linkImageRoot/${widget.race['image'].toString()}",
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.fill,
                                    placeholder: 'assets/images/races.png',
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

                      TextFormField(
                        controller: _createdBy,
                        decoration: InputDecoration(
                          labelText: 'انشات من قبل',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال اسم';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _createdBy.text = value!;
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
                        height: 10.0,
                      ),
                      ElevatedButton(
                        child: Text('تعديل المسابقة'),
                        onPressed: () {
                          // TODO: Submit form data
                          if (formstate.currentState!.validate()) {
                            formstate.currentState!.save();
                            editRace(widget.race["id"]);
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
                                    text: _startDate.text,
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
