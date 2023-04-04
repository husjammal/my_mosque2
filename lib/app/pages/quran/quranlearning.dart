import 'package:flutter/material.dart';
import 'package:mymosque/constant/colorConfig.dart';

class QuranLearning extends StatefulWidget {
  const QuranLearning({Key? key}) : super(key: key);
  _QuranLearningState createState() => _QuranLearningState();
}

class _QuranLearningState extends State<QuranLearning> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('متابعة الحفظ'),
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
              'حفظ',
            ),
          ),
        ),
      ),
    );
  }
}
