import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/model/usermodel.dart';
import 'package:flutter/material.dart';

class CardUsers extends StatelessWidget {
  final void Function()? ontap;
  final UserModel? usermodel;
  final int? rank_index;

  const CardUsers({Key? key, this.ontap, this.usermodel, this.rank_index})
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network(
                    "$linkImageRoot/${usermodel!.usersImage}",
                    width: 70,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                )),
            Expanded(
                flex: 2,
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        "${usermodel!.usersName}",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      ),
                      Text("  "),
                      Text(
                        rank_index! <= 2 ? " ترتيب " : "",
                        style: TextStyle(fontSize: 20.0, color: Colors.yellow),
                      ),
                      Text(
                        rank_index! <= 2 ? (rank_index! + 1).toString() : "",
                        style: TextStyle(fontSize: 20.0, color: Colors.yellow),
                      ),
                    ],
                  ),
                  subtitle: Text("المجموع الكلي ${usermodel!.userTotalScore}"),
                  trailing: Container(
                    height: 150,
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.deepPurple,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "مجموع",
                          style: TextStyle(color: Colors.white, fontSize: 10.0),
                        ),
                        // Text(""),
                        Text("${usermodel!.userFinalScore}",
                            style: TextStyle(color: Colors.white)),

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
