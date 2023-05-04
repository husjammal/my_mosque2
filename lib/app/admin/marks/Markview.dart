import 'package:flutter/material.dart';
import 'package:mymosque/app/admin/marks/markupdate.dart';
import 'package:mymosque/components/crud.dart';
import 'package:mymosque/constant/linkapi.dart';

import 'package:mymosque/model/mosquemodel.dart';

//4. Create a GridView widget to display the data and allow the user to edit it:

class DataGrid extends StatefulWidget {
  final List<MosqueData>? dataList;
  DataGrid({this.dataList});

  @override
  _DataGridState createState() => _DataGridState();
}

class _DataGridState extends State<DataGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.dataList!.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        MosqueData data = widget.dataList![index];
        print(data);
        return GestureDetector(
          onTap: () {
// Navigate to the update form screen
            print(index);
            print(widget.dataList![index].subuh);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      UpdateForm(data: widget.dataList![index])),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('ID: ${data.id}'),
                Text('Subuh: ${data.subuh}'),
                Text('Zhur: ${data.zhur}'),
                Text('Asr: ${data.asr}'),
// Add more fields to display
              ],
            ),
          ),
        );
      },
    );
  }
}

//5. Finally, create the function to update the data in MySQL database:

Future updateData(
    String? id,
    String? subuh,
    String? zhur,
    String? asr,
    String? magrib,
    String? isyah,
    String? subuhsunah,
    String? zhursunah,
    String? asrsunah,
    String? magribsunah,
    String? isyahsunah,
    String? wattersunah,
    String? duhhanafel,
    String? tarawehnafel,
    String? keyamnafel,
    String? tahajoudnafel,
    String? quranread,
    String? quranlearn,
    String? quranlisten,
    String? actlist,
    String? duaascore,
    String? subgroup,
    String? mygroup) async {
  final response = await postRequest(linkAdminEditMark, {
    'id': id.toString(),
    'subuh': subuh.toString(),
    'zhur': zhur.toString(),
    'asr': asr.toString(),
    'magrib': magrib.toString(),
    'isyah': isyah.toString(),
    'subuhsunah': subuhsunah.toString(),
    'zhursunah': zhursunah.toString(),
    'asrsunah': asrsunah.toString(),
    'magribsunah': magribsunah.toString(),
    'isyahsunah': isyahsunah.toString(),
    'wattersunah': wattersunah.toString(),
    'duhhanafel': duhhanafel.toString(),
    'tarawehnafel': tarawehnafel.toString(),
    'keyamnafel': keyamnafel.toString(),
    'tahajoudnafel': tahajoudnafel.toString(),
    'quranread': quranread.toString(),
    'quranlearn': quranlearn.toString(),
    'quranlisten': quranlisten.toString(),
    'actlist': actlist.toString(),
    'duaascore': duaascore.toString(),
    'subgroup': subgroup.toString(),
    'mygroup': mygroup.toString(),
  });
  if (response.statusCode == 200) {
// Data updated successfully
    print('Data updated successfully');
  } else {
// Failed to update data
    print('Failed to update data');
  }
}
