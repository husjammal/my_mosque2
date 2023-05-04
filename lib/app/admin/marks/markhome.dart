import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_table/json_table.dart';
import 'package:lottie/lottie.dart';
import 'package:mymosque/app/admin/marks/Markview.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';
import 'package:mymosque/model/mosquemodel.dart';

class SimpleTable extends StatefulWidget {
  @override
  _SimpleTableState createState() => _SimpleTableState();
}

class _SimpleTableState extends State<SimpleTable> {
  String jsonSample = "";
  List<MosqueData> mosqueDataList = [];

  ///
  bool isLoading = false;
  getMark() async {
    isLoading = true;
    setState(() {});
    var response = await postRequest(linkViewMarks, {
      "subGroup": "ALL",
      "myGroup": sharedPref.getString("myGroup"),
    });
    print(response['data']);
    final jsonSample1 =
        response['data'].map((item) => jsonEncode(item)).toList();
    print("jsonSample1 $jsonSample1");
    jsonSample = jsonSample1.toString();
    //json = jsonDecode(jsonSample);
    print("object");

    var userDataBadge1List = response['data'] as List;
    mosqueDataList = userDataBadge1List
        .map<MosqueData>((json) => MosqueData.fromJson(json))
        .toList();

    isLoading = false;
    setState(() {});
    return response;
  }

  bool toggle = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMark();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 160.0,
          backgroundColor: buttonColor2,
          centerTitle: true,
          leadingWidth: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("adminhome", (route) => false);
              },
              icon: Icon(Icons.exit_to_app),
              tooltip: 'رجوع',
            )
          ],
          title: Column(
            children: [
              Text(
                "قائمة بوزن النقاط",
                style: TextStyle(
                    color: textColor2,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // leadingWidth: 1.0,
        ),
        body: isLoading
            ? Center(
                child: Column(
                  children: [
                    Text("جاري التحميل ..."),
                    Lottie.asset(
                      'assets/lottie/93603-loading-lottie-animation.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.all(16.0),
                child: DataGrid(dataList: mosqueDataList),

                //  Container(
                //   child: toggle
                //       ? Column(
                //           children: [
                //             JsonTable(
                //               json,
                //               showColumnToggle: true,
                //               allowRowHighlight: true,
                //               rowHighlightColor:
                //                   Colors.yellow[500]!.withOpacity(0.7),
                //               paginationRowCount: 6,
                //               onRowSelect: (index, map) {
                //                 print(index);
                //                 print(map);
                //               },
                //             ),
                //             SizedBox(
                //               height: 40.0,
                //             ),
                //             Text(
                //                 "Simple table which creates table direclty from json")
                //           ],
                //         )
                //       : Center(
                //           child: Text(getPrettyJSONString(jsonSample)),
                //         ),
                // ),
              ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.grid_on),
            onPressed: () {
              setState(
                () {
                  toggle = !toggle;
                },
              );
            }),
      ),
    );
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(jsonDecode(jsonObject));
    return jsonString;
  }
}
