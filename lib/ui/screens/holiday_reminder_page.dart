import 'dart:math';

import 'package:flutter/material.dart';

class HolidayReminderPage extends StatelessWidget {
  final String payload;

  const HolidayReminderPage({Key key, @required this.payload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Transform.rotate(
                    angle: 0.25 * pi,
                    child: Icon(
                      Icons.notifications,
                      size: 500.0,
                      color: Colors.grey.shade100,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        payload,
                        style: Theme.of(context).textTheme.display4.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "This is a reminder that today is ",
                          style: Theme.of(context).textTheme.display1.copyWith(
                              fontFamily: 'Josefin', color: Colors.black38),
                          children: <TextSpan>[
                            TextSpan(
                              text: payload,
                              style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
