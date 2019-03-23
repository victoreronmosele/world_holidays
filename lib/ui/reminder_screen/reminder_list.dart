import 'package:flutter/material.dart';

class ReminderList extends StatefulWidget {
  final Function switchTab;

  const ReminderList({
    Key key, this.switchTab,
  }) : super(key: key);

  @override
  ReminderListState createState() {
    return new ReminderListState();
  }
}

class ReminderListState extends State<ReminderList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

             Text(
                "Your reminder list is empty",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline.copyWith(
                  fontSize: 16
                ),
              ),
            SizedBox(
              height: 24.0,
            ),
            RaisedButton(
              color: Color(0xff3fa7d6),
              // padding: EdgeInsets.all(16.0),
              child: Text("BACK TO HOLIDAYS",
              style: TextStyle(color: Colors.white),
              ),
              onPressed: (){
                widget.switchTab(0);
              },
            )
          ],
        ),
      ),
    );
  }
}
