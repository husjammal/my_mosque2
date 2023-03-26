import 'package:flutter/material.dart';

class CustomTextFormSign extends StatelessWidget {
  final String hint;
  final String? Function(String?) valid;
  final TextEditingController mycontroller;
  const CustomTextFormSign(
      {Key? key,
      required this.hint,
      required this.mycontroller,
      required this.valid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: valid,
        controller: mycontroller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          labelText: hint,
          labelStyle: TextStyle(color: Colors.deepPurple),
          hintText: hint,
          errorStyle: TextStyle(color: Colors.amber),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.purpleAccent, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }
}
