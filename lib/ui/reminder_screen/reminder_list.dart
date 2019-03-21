import 'package:flutter/material.dart';

class ReminderList extends StatelessWidget {
  const ReminderList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child:
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.hourglass_empty, size: 72.0,
              color: Colors.black38,
              ),
              SizedBox(height: 24.0,),
              Text("Your reminder list \nis empty",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black)),
            ],  
      )      
      ,),
    );
  }
}
