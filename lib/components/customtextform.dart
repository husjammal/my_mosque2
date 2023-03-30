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
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: valid,
        controller: mycontroller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          labelText: hint,
          labelStyle: const TextStyle(color: Colors.deepPurple),
          hintText: hint,
          errorStyle: const TextStyle(color: Colors.amber),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.purpleAccent, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }
}
