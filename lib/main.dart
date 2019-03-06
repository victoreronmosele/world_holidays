import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Holidays',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    
    
    return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: Icon(Icons.settings, color: Colors.black,), onPressed: () {print("settings pressed");},),
            ),
        body: Container(
          color: Colors.white,
        ), 
      ),
    );
  }
}
