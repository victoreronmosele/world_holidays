import 'dart:math';

import 'package:flutter/material.dart';
import 'package:world_holidays/ui/home.dart';

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
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Transform.rotate(
                    angle: 0.25 * pi,
                    child: Opacity(
                      opacity: 0.3,
                                          child: Icon(
                        Icons.notifications,
                        size: 500.0,
                        
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).iconTheme.color
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => Home()),
                                (Route<dynamic> route) => false);
                          },
                        )
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              payload,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline
                                  .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                                height:
                                    0.3 * MediaQuery.of(context).size.height),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "This is a reminder that today is ",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .copyWith(
                                      fontFamily: 'Josefin',
                                    ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: payload,
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
