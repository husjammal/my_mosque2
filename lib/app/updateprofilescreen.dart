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

class UpdateProfileScreen extends StatefulWidget {
  final user;
  const UpdateProfileScreen({Key? key, this.user}) : super(key: key);

  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? myfile;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
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
        response = await postRequest(linkEditUsers, {
          "id": sharedPref.getString("id"),
          "username": username.text,
          "email": email.text,
          "password": password.text,
          "phone": phone.text,
          "image": widget.user['image'],
        });
      } else {
        print("POST with file");
        print("image ${widget.user['image']}");
        response = await postRequestWithFile(
            linkEditUsers,
            {
              "id": sharedPref.getString("id"),
              "username": username.text,
              "email": email.text,
              "password": password.text,
              "phone": phone.text,
              "image": widget.user['image'],
            },
            myfile!);
      }
      print('linkEditUsers $linkEditUsers');
      print(response);
      isLoading = false;
      setState(() {});
      if (response['status'] == 'success') {
        sharedPref.setString("username", username.text);
        sharedPref.setString("email", email.text);
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

  @override
  void initState() {
    // title.text = widget.note['notes_title'];
    // content.text = widget.note['notes_content'];
    //
    username.text = widget.user['username'];
    email.text = widget.user['email'];
    password.text = widget.user['password'];
    phone.text = widget.user['phone'];
    joinedAt = widget.user['joinedAt'].toString();

    // userImage = widget.user['image'];

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
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      "initialScreen", (route) => false);
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
                                : const Text("تعديل معلوماتي",
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
                                text: "انضممت",
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
                              child: const Text("حذفي"),
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
