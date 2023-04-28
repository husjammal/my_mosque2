import 'package:flutter/material.dart';
import 'package:mymosque/app/pages/pray/nuafel.dart';
import 'package:mymosque/app/pages/pray/pray.dart';
import 'package:mymosque/app/pages/pray/sunah.dart';
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
          leadingWidth: 0.0,
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
                color: buttonColor2,
                constraints: BoxConstraints.expand(height: 50),
                child: TabBar(indicatorColor: textColor2, tabs: [
                  Tab(text: "الفروض"),
                  Tab(text: "السنن"),
                  Tab(text: "النوافل"),
                ]),
              ),
              Expanded(
                child: Container(
                  color: backgroundColor,
                  child: TabBarView(children: [
                    Pray(),
                    Sunah(),
                    Nuafel(),
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
