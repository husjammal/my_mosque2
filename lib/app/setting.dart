import 'package:flutter/material.dart';
import 'package:mymosque/constant/colorConfig.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text("اعدادات التطبيق"),
          backgroundColor: buttonColor,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("initialScreen", (route) => false);
              },
              icon: Icon(Icons.exit_to_app),
              tooltip: 'رجوع',
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
            ),
            Text(
              'اعدادات عامة',
              style: TextStyle(
                  color: textColor2,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              title: Text('الللغة'),
              subtitle: Text('العربية'),
              leading: Icon(Icons.language),
              onTap: () {},
            ),
            SwitchListTile(
              title: Text('اللون الداكن'),
              secondary: Icon(Icons.phone_android),
              value: isSwitched,
              activeColor: buttonColor,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
              },
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
            ),
            Text(
              'اعدادات الامان',
              style: TextStyle(
                  color: textColor2,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              title: Text('الامان'),
              subtitle: Text('كلمة سر'),
              leading: Icon(Icons.lock),
              onTap: () {},
            ),
            SwitchListTile(
              title: Text('استخدام البصمة'),
              secondary: Icon(Icons.fingerprint),
              value: false,
              activeColor: buttonColor,
              onChanged: (value) {},
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
