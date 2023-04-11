/* **************
                 * START***
************** */

import 'package:flutter/material.dart';

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
