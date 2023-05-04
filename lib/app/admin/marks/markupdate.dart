//3. Create a form widget to get the user input:

import 'package:flutter/material.dart';
import 'package:mymosque/app/admin/marks/Markview.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/model/mosquemodel.dart';

class UpdateForm extends StatefulWidget {
  final MosqueData? data;
  UpdateForm({this.data});

  @override
  _UpdateFormState createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  String? subuh;
  String? zhur;
  String? asr;
  String? magrib;
  String? isyah;
  String? subuhsunah;
  String? zhursunah;
  String? asrsunah;
  String? magribsunah;
  String? isyahsunah;
  String? wattersunah;
  String? duhhanafel;
  String? tarawehnafel;
  String? keyamnafel;
  String? tahajoudnafel;
  String? quranread;
  String? quranlearn;
  String? quranlisten;
  String? actlist;
  String? duaascore;
  String? subgroup;
  String? mygroup;

  @override
  void initState() {
    super.initState();
    subuh = widget.data!.subuh;
    zhur = widget.data!.zhur;
    asr = widget.data!.asr;
    magrib = widget.data!.magrib;
    isyah = widget.data!.isyah;
    subuhsunah = widget.data!.subuhsunah;
    zhursunah = widget.data!.zhursunah;
    asrsunah = widget.data!.asrsunah;
    magribsunah = widget.data!.magribsunah;
    isyahsunah = widget.data!.isyahsunah;
    wattersunah = widget.data!.wattersunah;
    duhhanafel = widget.data!.duhhanafel;
    tarawehnafel = widget.data!.tarawehnafel;
    keyamnafel = widget.data!.keyamnafel;
    tahajoudnafel = widget.data!.tahajoudnafel;
    quranread = widget.data!.quranread;
    quranlearn = widget.data!.quranlearn;
    quranlisten = widget.data!.quranlisten;
    actlist = widget.data!.actlist;
    duaascore = widget.data!.duaascore;
    subgroup = widget.data!.subgroup;
    mygroup = widget.data!.mygroup;
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
                Navigator.pop(context);
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
        body: Column(
          children: [
            Form(
              key: formstate,
              child: Column(
                children: [
// Add text form fields for each data field
                  TextFormField(
                    initialValue: subuh.toString(),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      subuh = value;
                    },
                  ),
                  TextFormField(
                    initialValue: zhur.toString(),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      zhur = value;
                    },
                  ),
// Add more text form fields for each data field
                  ElevatedButton(
                    onPressed: () {
                      if (formstate.currentState!.validate()) {
// Save user input
                        formstate.currentState!.save();
// Update data in MySQL database
                        updateData(
                            widget.data!.id,
                            subuh,
                            zhur,
                            asr,
                            magrib,
                            isyah,
                            subuhsunah,
                            zhursunah,
                            asrsunah,
                            magribsunah,
                            isyahsunah,
                            wattersunah,
                            duhhanafel,
                            tarawehnafel,
                            keyamnafel,
                            tahajoudnafel,
                            quranread,
                            quranlearn,
                            quranlisten,
                            actlist,
                            duaascore,
                            subgroup,
                            mygroup);
// Navigate back to the previous screen
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
