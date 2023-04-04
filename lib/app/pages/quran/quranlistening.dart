import 'package:flutter/material.dart';
import 'package:mymosque/constant/colorConfig.dart';

class QuranListening extends StatefulWidget {
  const QuranListening({Key? key}) : super(key: key);
  _QuranListeningState createState() => _QuranListeningState();
}

class _QuranListeningState extends State<QuranListening> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('متابعة الاستماع'),
          centerTitle: true,
          backgroundColor: buttonColor,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'قائمة',
            onPressed: () {},
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("quran", (route) => false);
              },
              icon: const Icon(Icons.exit_to_app),
              tooltip: 'رجوع',
            )
          ], //IconButton
        ),
        body: SingleChildScrollView(
          child: Container(
            color: backgroundColor,
            child: Text(
              'الاستماع',
            ),
          ),
        ),
      ),
    );
  }
}
