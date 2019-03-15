import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 60.0,
              child: Material(
                color: Colors.amber,
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () => null,
                  child: Icon(Icons.home, size: 24.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 60.0,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () => null,
                  child:
                      // Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      Icon(Icons.alarm, size: 24.0),

                  // ],
                  // ),
                ),
              ),
            ),
          ),
        ],
      ),
      // color: Colors.blueGrey,
    );
  }
}
