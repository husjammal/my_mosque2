import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_table/json_table.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/main.dart';

class SimpleTable extends StatefulWidget {
  @override
  _SimpleTableState createState() => _SimpleTableState();
}

class _SimpleTableState extends State<SimpleTable> {
  String jsonSample = "";
  List<dynamic> json = [];

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
    json = jsonDecode(jsonSample);
    print("object");
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
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Container(
                child: toggle
                    ? Column(
                        children: [
                          JsonTable(
                            json,
                            showColumnToggle: true,
                            allowRowHighlight: true,
                            rowHighlightColor:
                                Colors.yellow[500]!.withOpacity(0.7),
                            paginationRowCount: 6,
                            onRowSelect: (index, map) {
                              print(index);
                              print(map);
                            },
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Text(
                              "Simple table which creates table direclty from json")
                        ],
                      )
                    : Center(
                        child: Text(getPrettyJSONString(jsonSample)),
                      ),
              ),
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
          );
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(jsonDecode(jsonObject));
    return jsonString;
  }
}
