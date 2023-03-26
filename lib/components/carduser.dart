import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'package:mymosque/model/usermodel.dart';
import 'package:flutter/material.dart';

class CardUsers extends StatelessWidget {
  final void Function()? ontap;
  final UserModel? usermodel;
  final void Function()? onDelete;
  const CardUsers({Key? key, this.ontap, this.usermodel, this.onDelete})
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
                  title: Text(
                    "${usermodel!.usersName}",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${usermodel!.usersEmail}"),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.deepPurple,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "score",
                          style: TextStyle(color: Colors.white),
                        ),
                        // Text(""),
                        Text("${usermodel!.userScore}",
                            style: TextStyle(color: Colors.white)),
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
