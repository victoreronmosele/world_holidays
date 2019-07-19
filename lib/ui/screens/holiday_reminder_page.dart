import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:world_holidays/ui/home.dart';

class HolidayReminderPage extends StatelessWidget {
  final String payload;

  const HolidayReminderPage({Key key, @required this.payload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(payload,
                    style: Theme.of(context).textTheme.headline.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center),
                Center(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Today is ",
                          style: Theme.of(context)
                              .textTheme
                              .headline
                              .copyWith(fontFamily: 'Josefin'),
                          children: <TextSpan>[
                            TextSpan(text: payload, style: TextStyle())
                          ])),
                ),
                RaisedButton(
                  onPressed: () => goToHome(context),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    width: double.infinity,
                    height: 48.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF9a8478),
                          Color(0xFF1e130c),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: const Text('Go to holidays',
                          style: TextStyle(
                              // fontSize: 20
                              )),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  void goToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false);
  }
}
