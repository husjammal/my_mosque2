/* **************
                 * START***
************** */

import 'package:flutter/material.dart';

import 'package:awesome_dialog/awesome_dialog.dart';

/// Sliver app bars are typically used as the first child of a CustomScrollView, which lets the app bar integrate
/// with the scroll view so that it can vary in height according to the scroll offset or float above the other
/// content in the scroll view.
class LSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            backgroundColor: Colors.blue,
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Demo Appbar'),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.lightBlue[100 * (index % 9)],
                  child: Text('List Item $index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* **************
***************
***************
              * END***
***************
***************
************** */
/* **************
                 * START***
************** */

class LDropDownButton extends StatefulWidget {
  const LDropDownButton({Key? key}) : super(key: key);

  @override
  _LDropDownButtonState createState() => _LDropDownButtonState();
}

class _LDropDownButtonState extends State<LDropDownButton> {
  String? dropdownValue = 'Green';
  List<String> dropdownItems = <String>[
    'Green',
    'Red',
    'Yellow',
    'Blue',
    "Pink",
    "Orange"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getColor(dropdownValue!),
      child: Center(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 36,
          elevation: 8,
          style: TextStyle(color: Colors.deepPurple, fontSize: 36),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getColor(String _color) {
    if (_color.compareTo("Green") == 0) {
      return Colors.green;
    } else if (_color.compareTo("Red") == 0) {
      return Colors.red;
    } else if (_color.compareTo("Yellow") == 0) {
      return Colors.yellow;
    } else if (_color.compareTo("Pink") == 0) {
      return Colors.pink;
    } else if (_color.compareTo("Orange") == 0) {
      return Colors.orange;
    } else if (_color.compareTo("Blue") == 0) {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  }
}

/* **************
***************
***************
              * END***
***************
***************
************** */

class AwesomeDialogDemo extends StatefulWidget {
  @override
  _AwesomeDialogDemoState createState() => _AwesomeDialogDemoState();
}

class _AwesomeDialogDemoState extends State<AwesomeDialogDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Awesome Dialog Demo'),
        ),
        body: Center(
            child: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AnimatedButton(
                  text: 'Info Dialog',
                  pressEvent: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'INFO',
                      desc: 'Dialog description here...',
                      showCloseIcon: true,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    )..show();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                AnimatedButton(
                  text: 'Warning Dialog',
                  color: Colors.orange,
                  pressEvent: () {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.WARNING,
                        headerAnimationLoop: false,
                        animType: AnimType.TOPSLIDE,
                        showCloseIcon: true,
                        closeIcon: Icon(Icons.close_fullscreen_outlined),
                        title: 'Warning',
                        desc: 'Dialog description here',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {})
                      ..show();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                AnimatedButton(
                  text: 'Error Dialog',
                  color: Colors.red,
                  pressEvent: () {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.RIGHSLIDE,
                        headerAnimationLoop: false,
                        title: 'Error',
                        desc: 'Dialog description here',
                        btnOkOnPress: () {},
                        btnOkIcon: Icons.cancel,
                        btnOkColor: Colors.red)
                      ..show();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                AnimatedButton(
                  text: 'Succes Dialog',
                  color: Colors.green,
                  pressEvent: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.LEFTSLIDE,
                      headerAnimationLoop: false,
                      dialogType: DialogType.SUCCES,
                      title: 'Succes',
                      desc: 'Dialog description here',
                      btnOkOnPress: () {
                        debugPrint('OnClcik');
                      },
                      btnOkIcon: Icons.check_circle,
                      // onDissmissCallback: () {
                      //   debugPrint('Dialog Dissmiss from callback');
                      // },
                    )..show();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                AnimatedButton(
                  text: 'No Header Dialog',
                  color: Colors.cyan,
                  pressEvent: () {
                    AwesomeDialog(
                      context: context,
                      headerAnimationLoop: false,
                      dialogType: DialogType.NO_HEADER,
                      title: 'No Header',
                      desc: 'Dialog description here',
                      btnOkOnPress: () {
                        debugPrint('OnClcik');
                      },
                      btnOkIcon: Icons.check_circle,
                    )..show();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                AnimatedButton(
                  text: 'Custom Body Dialog',
                  color: Colors.blueGrey,
                  pressEvent: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.SCALE,
                      dialogType: DialogType.INFO,
                      body: Center(
                        child: Text(
                          'If the body is specified, then title and description will be ignored, this allows to further customize the dialogue.',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      title: 'This is Ignored',
                      desc: 'This is also Ignored',
                    )..show();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                AnimatedButton(
                  text: 'Auto Hide Dialog',
                  color: Colors.purple,
                  pressEvent: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.SCALE,
                      title: 'Auto Hide Dialog',
                      desc: 'AutoHide after 2 seconds',
                      autoHide: Duration(seconds: 2),
                    )..show();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                AnimatedButton(
                  text: 'Body with Input',
                  color: Colors.blueGrey,
                  pressEvent: () {
                    AwesomeDialog dialog;
                    dialog = AwesomeDialog(
                      context: context,
                      animType: AnimType.SCALE,
                      dialogType: DialogType.INFO,
                      keyboardAware: true,
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Form Data',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Material(
                              elevation: 0,
                              color: Colors.blueGrey.withAlpha(40),
                              child: TextFormField(
                                autofocus: true,
                                minLines: 1,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Title',
                                  prefixIcon: Icon(Icons.text_fields),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Material(
                              elevation: 0,
                              color: Colors.blueGrey.withAlpha(40),
                              child: TextFormField(
                                autofocus: true,
                                keyboardType: TextInputType.multiline,
                                // maxLengthEnforced: true,
                                minLines: 2,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Description',
                                  prefixIcon: Icon(Icons.text_fields),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AnimatedButton(
                                text: 'Close',
                                pressEvent: () {
                                  // dialog.dissmiss();
                                })
                          ],
                        ),
                      ),
                    )..show();
                  },
                ),
              ],
            ),
          ),
        )));
  }
}

/* **************
                 * START***
************** */

class LSwitchListTile extends StatefulWidget {
  @override
  _LSwitchListTileState createState() => _LSwitchListTileState();
}

class _LSwitchListTileState extends State<LSwitchListTile> {
  bool _isSwitchedOn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isSwitchedOn ? Colors.amber : Colors.white,
      child: Center(
        child: SwitchListTile(
          title:
              Text(_isSwitchedOn ? 'Color Switched ON' : "Color Switched OFF"),
          value: _isSwitchedOn,
          onChanged: (bool value) {
            setState(() {
              _isSwitchedOn = value;
            });
          },
          subtitle: Text(_isSwitchedOn ? "Yellow Color" : "White Color"),
          secondary: const Icon(Icons.color_lens),
        ),
      ),
    );
  }
}

/* **************
***************
***************
              * END***
***************
***************
************** */
/* **************
                 * START***
************** */

class LRadio extends StatefulWidget {
  @override
  _LRadioState createState() => _LRadioState();
}

class _LRadioState extends State<LRadio> {
  String? _group1SelectedValue;
  String? _group2SelectedValue;

  @override
  void initState() {
    _group1SelectedValue = "1";
    _group2SelectedValue = "A";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Center(
                    child: RichText(
                        text: TextSpan(
                            text: "Selected Number: ",
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                      TextSpan(
                          text: '$_group1SelectedValue ',
                          style: TextStyle(fontSize: 24)),
                    ]))),
                ListTile(
                  title: Text("1"),
                  leading: Radio(
                      value: "1",
                      groupValue: _group1SelectedValue,
                      onChanged: _group1Changes),
                ),
                ListTile(
                  title: Text("2"),
                  leading: Radio(
                      value: "2",
                      groupValue: _group1SelectedValue,
                      onChanged: _group1Changes),
                ),
                ListTile(
                  title: Text("3"),
                  leading: Radio(
                      value: "3",
                      groupValue: _group1SelectedValue,
                      onChanged: _group1Changes),
                ),
                ListTile(
                  title: Text("4"),
                  leading: Radio(
                      value: "4",
                      groupValue: _group1SelectedValue,
                      onChanged: _group1Changes),
                ),
                ListTile(
                  title: Text("5"),
                  leading: Radio(
                      value: "5",
                      groupValue: _group1SelectedValue,
                      onChanged: _group1Changes),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Center(
                    child: RichText(
                        text: TextSpan(
                            text: "Selected Character: ",
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                      TextSpan(
                          text: '$_group2SelectedValue ',
                          style: TextStyle(fontSize: 24)),
                    ]))),
                ListTile(
                  title: Text("A"),
                  leading: Radio(
                      value: "A",
                      groupValue: _group2SelectedValue,
                      onChanged: _group2Changes),
                ),
                ListTile(
                  title: Text("B"),
                  leading: Radio(
                      value: "B",
                      groupValue: _group2SelectedValue,
                      onChanged: _group2Changes),
                ),
                ListTile(
                  title: Text("C"),
                  leading: Radio(
                      value: "C",
                      groupValue: _group2SelectedValue,
                      onChanged: _group2Changes),
                ),
                ListTile(
                  title: Text("D"),
                  leading: Radio(
                      value: "D",
                      groupValue: _group2SelectedValue,
                      onChanged: _group2Changes),
                ),
                ListTile(
                  title: Text("E"),
                  leading: Radio(
                      value: "E",
                      groupValue: _group2SelectedValue,
                      onChanged: _group2Changes),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _group1Changes(String? value) {
    setState(() {
      _group1SelectedValue = value;
    });
  }

  void _group2Changes(String? value) {
    setState(() {
      _group2SelectedValue = value;
    });
  }
}

/* **************
***************
***************
              * END***
***************
***************
************** */

//   List<String> myList = <String>[];
//   getUsers() async {
//     var response = await postRequest(linkmyGroups, {});

//     print("the lists");
//     var myList1 = response['data'];
//     print("myList1 $myList1");

//     ///
//     // convert each item to a string by using JSON encoding
//     final jsonList = myList1.map((item) => jsonEncode(item)).toList();
//     print("jsonList $jsonList");
//     // using toSet - toList strategy
//     final uniqueJsonList = jsonList.toSet().toList();
//     print("uniqueJsonList $uniqueJsonList");
//     // convert each item back to the original form using JSON decoding
//     final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();

//     print("result $result");

// //////

// // use forEach()
//     print(" use forEach()");
//     result.forEach((item) => print(item));
// // or
//     result.forEach(print);

// // use iterator
//     print(" use iterator");
//     var listIterator = result.iterator;
//     while (listIterator.moveNext()) {
//       print(listIterator.current);
//     }

// // use every()
//     print(" use every()");
//     result.every((item) {
//       print(item);
//       return true;
//     });

// // simple for-each
//     print(" use simple for-each");
//     for (var item in result) {
//       print(item);
//     }

// // for loop with item index
//     print(" use for loop with item index");
//     for (var i = 0; i < result.length; i++) {
//       print(result[i]);
//       print(result[i]["myGroup"]);
//       myList.add(result[i]["myGroup"].toString());
//     }

//     //
//     // List myList = jsonList.values;
//     // print("myList $myList");

//     print("myList ${myList.length}");
//     print("myList $myList");

//     mosquedropdownItems = myList;
//     setState(() {});
//     return response;
//   }