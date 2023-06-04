import 'package:flutter/material.dart';
import 'package:mymosque/app/pages/duaa/azkar2.dart';
import 'package:mymosque/app/pages/duaa/duaa.dart';
import 'package:mymosque/app/pages/duaa/otherDuaa.dart';
import 'package:mymosque/constant/colorConfig.dart';

// Creating a stateful widget to manage
// the state of the app
class InitialDuaa extends StatefulWidget {
  @override
  _InitialDuaaState createState() => _InitialDuaaState();
}

class _InitialDuaaState extends State<InitialDuaa> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('قائمة الادعية'),
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
                color: buttonColor2,
                constraints: BoxConstraints.expand(height: 50),
                child: TabBar(tabs: [
                  Tab(text: "ادعية"),
                  Tab(text: "اذكار"),
                  Tab(text: "اخرى"),
                ]),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(children: [
                    Duaa(),
                    AzkarPage(),
                    // Azkar(),
                    OtherDuaa(),
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
