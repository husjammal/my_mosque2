import 'package:flutter/material.dart';
import 'package:mymosque/app/admin/users/teacheredit.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';

class TeacherView extends StatefulWidget {
  final admin;
  const TeacherView({Key? key, this.admin}) : super(key: key);
  _TeacherViewState createState() => _TeacherViewState();
}

class _TeacherViewState extends State<TeacherView> {
  bool isLoading = false;

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
          backgroundColor: buttonColor,
          centerTitle: true,
          leadingWidth: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("intiuser", (route) => false);
              },
              icon: Icon(Icons.exit_to_app),
              tooltip: 'رجوع',
            )
          ],
          title: Text(
            "معلومات المشرف",
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: backgroundColor,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// -- IMAGE
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: FadeInImage.assetNetwork(
                    image: "$linkImageRoot/${widget.admin['image']}",
                    placeholder: "assets/images/avatar.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 10),
                Text(widget.admin['username'].toString(),
                    style: Theme.of(context).textTheme.headline4),
                Text(widget.admin['email'].toString(),
                    style: Theme.of(context).textTheme.bodyText2),
                Text(
                    "مسجد ${widget.admin['myGroup']},حلقة ${widget.admin['subGroup']}",
                    style: Theme.of(context).textTheme.bodyText2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("أنشئ الحساب في",
                        style: Theme.of(context).textTheme.bodyText1),
                    Text(widget.admin['date'].toString(),
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
                const SizedBox(height: 20),

                /// -- BUTTON
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      // print("admin: ${adminDataList[0]}");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              TeacherEdit(admin: widget.admin)));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: const Text("تعديل معلومات",
                        style: TextStyle(color: backgroundColor)),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
