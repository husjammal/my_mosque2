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
