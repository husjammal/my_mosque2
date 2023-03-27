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
      // print("note.id ${widget.note['notes_id'].toString()}");
      // print("title ${title.text}");
      // print("content ${content.text}");
      print(response);
      isLoading = false;
      setState(() {});
      if (response['status'] == 'success') {
        Navigator.of(context).pushReplacementNamed("initialScreen");
      } else {
        // to Add code
      }
    }
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
                        child: Image.network(
                          "$linkImageRoot/${widget.user['image'].toString()}",
                          width: 120,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
                      )),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  color: backgroundColor,
                                  height: 130,
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
                                      InkWell(
                                        onTap: () async {
                                          XFile? xfile = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          Navigator.of(context).pop;
                                          myfile = File(xfile!.path);
                                          print("xfile $xfile");
                                          print("myyyfile $myfile");
                                          setState(() {});
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "من المعرض ",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: buttonColor),
                                            )),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          XFile? xfile = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.camera);
                                          Navigator.of(context).pop;
                                          myfile = File(xfile!.path);
                                          print("xfile $xfile");
                                          print("myyyfile $myfile");
                                          setState(() {});
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "من الكميرا ",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: buttonColor),
                                            )),
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
                            return validInput(val!, 1, 40);
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
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "initialScreen", (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                side: BorderSide.none,
                                shape: const StadiumBorder()),
                            child: const Text("تعديل معلوماتي",
                                style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // -- Created Date and Delete Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text.rich(
                              TextSpan(
                                text: "انضممت",
                                style: TextStyle(fontSize: 12),
                                children: [
                                  TextSpan(
                                      text: "في ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
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