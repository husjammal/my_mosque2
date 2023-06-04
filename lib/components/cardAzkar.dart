import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/model/azkarModel.dart';
import 'package:flutter/material.dart';

class CardAzkar extends StatelessWidget {
  final void Function()? ontap;
  final AzkarModel? azkarModel;
  final int? rank_index;

  const CardAzkar({Key? key, this.ontap, this.azkarModel, this.rank_index})
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
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(100.0),
                    //   child: Image.network(
                    //     "$linkImageRoot/${azkarModel!.image}",
                    //     width: 60,
                    //     height: 60,
                    //     fit: BoxFit.fill,
                    //   ),
                    // ),
                  ],
                )),
            Expanded(
                flex: 2,
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        "${azkarModel!.text}",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    "رقم ${azkarModel!.id},حلقة ${azkarModel!.filename}",
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
                      color: buttonColor,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "مجموع",
                          style: TextStyle(color: Colors.white, fontSize: 8.0),
                        ),
                        // Text(""),
                        Text("",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
