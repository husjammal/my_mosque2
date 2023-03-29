import 'package:flutter/material.dart';
import 'package:mymosque/app/pages/pray/pray.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/main.dart';

import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant//linkapi.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mymosque/constant/colorConfig.dart';

// Creating a stateful widget to manage
// the state of the app
class InitialPray extends StatefulWidget {
  const InitialPray({super.key});

  @override
  _InitialPrayState createState() => _InitialPrayState();
}

class _InitialPrayState extends State<InitialPray> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('جدول صلاتي'),
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
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("initialScreen", (route) => false);
              },
              icon: Icon(Icons.exit_to_app),
              tooltip: 'رجوع',
            )
          ], //IconButton
        ), //AppBar
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: <Widget>[
              Container(
                color: backgroundColor,
                constraints: BoxConstraints.expand(height: 50),
                child: TabBar(tabs: [
                  Tab(text: "الفروض"),
                  Tab(text: "النوافل"),
                  Tab(text: "أخرى"),
                ]),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(children: [
                    Pray(),
                    Container(
                      child: Text("النوافل"),
                    ),
                    Container(
                      child: Text("اخرى"),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    ); //MaterialApp
  }
}
