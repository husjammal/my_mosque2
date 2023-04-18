import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/model/usermodel.dart';
import 'package:flutter/material.dart';

class CardUsers extends StatelessWidget {
  final void Function()? ontap;
  final UserModel? usermodel;
  final int? rank_index;
  final String? sortColumn;

  const CardUsers(
      {Key? key, this.ontap, this.usermodel, this.rank_index, this.sortColumn})
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
                        child: rank_index! <= 2
                            ? Stack(alignment: Alignment.center, children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.asset(
                                    'assets/images/badge.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 20,
                                  child: Text(
                                    (rank_index! + 1).toString(),
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ])
                            : Container(
                                // width: 30,
                                alignment: Alignment.center,
                                child: Text(
                                  (rank_index! + 1).toString(),
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.black),
                                ),
                              )),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: FadeInImage.assetNetwork(
                        image: "$linkImageRoot/${usermodel!.usersImage}",
                        placeholder: "assets/images/avatar.png",
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
                        "${usermodel!.usersName}",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Text("  "),
                      Text(
                        rank_index! <= 2 ? "الاوائل" : "",
                        style: TextStyle(fontSize: 8.0, color: textColor2),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    "المجموع الكلي ${usermodel!.userTotalScore} \n مسجد ${usermodel!.userMyGroup},حلقة ${usermodel!.userSubGroup}",
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
                        Text(
                            sortColumn == "finalScore"
                                ? "${usermodel!.userfinalScore}"
                                : sortColumn == "finalprayScore"
                                    ? "${usermodel!.userfinalprayScore}"
                                    : sortColumn == "finalsunahScore"
                                        ? "${usermodel!.userfinalsunahScore}"
                                        : sortColumn == "finalnuafelScore"
                                            ? "${usermodel!.userfinalnuafelScore}"
                                            : sortColumn == "finalquranScore"
                                                ? "${usermodel!.userfinalquranScore}"
                                                : "${usermodel!.userfinalactivityScore}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold)),

                        // Text((rank_index! + 1).toString(),
                        //     style: TextStyle(color: Colors.white)),
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
