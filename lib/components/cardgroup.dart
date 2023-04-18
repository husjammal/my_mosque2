import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/model/groupmodel.dart';
import 'package:flutter/material.dart';

class CardGroup extends StatelessWidget {
  final void Function()? ontap;
  final GroupModel? groupmodel;
  final int? rank_index;
  final String? sortColumn;

  const CardGroup(
      {Key? key, this.ontap, this.groupmodel, this.rank_index, this.sortColumn})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
        color: backgroundColor,
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    SizedBox(
                        width: 50.0,
                        child: Container(
                          // width: 30,
                          alignment: Alignment.center,
                          child: Text(
                            (rank_index! + 1).toString(),
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.black),
                          ),
                        )),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.network(
                        "$linkImageRoot/${groupmodel!.imageMosque}",
                        width: 60,
                        height: 60,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                )),
            Expanded(
              flex: 2,
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      "${groupmodel!.myGroup}",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    Text("  "),
                  ],
                ),
                subtitle: Text(
                  "الحلقة ${groupmodel!.subGroup} \n هي  ${groupmodel!.description}",
                  style: TextStyle(fontSize: 10.0),
                ),
                isThreeLine: true,
                trailing: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: backgroundColor,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 35.0,
                        width: 35.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35.0),
                          child: Image.network(
                            "$linkImageRoot/${groupmodel!.imagesubGroup}",
                            width: 30,
                            height: 30,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
