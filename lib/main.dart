import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Holidays',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  var monthToColorMap = {
    'January':Color(0xff3fa7d6),
    'February':Color(0xffee6352),
    'March':Color(0xff4d4730),
    'April':Color(0xff902d41),
    'May':Color(0xfff79d84),
    'June':Color(0xff331e36),
    'July':Color(0xff41337a),
    'August':Color(0xff050505),
    'September':Color(0xff004fff),
    'October':Color(0xff59cd90),
    'November':Color(0xfffac05e),
    'December':Color(0xffed6a5a),
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              print("settings pressed");
            },
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                child: Align(
                  alignment: Alignment(0.0, 0.5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RotatedBox(
                            quarterTurns: 2,
                            child: Divider(
                              indent: 30,
                              color: Colors.black38,
                            )),
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Holidays in ",
                              style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w300),
                              children: <TextSpan>[
                            TextSpan(
                              text: "Nigeria",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          ])),
                      Expanded(
                        child: Divider(
                          indent: 30,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                        child: Icon(
                          Icons.flag,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                          color: Colors.black12,
                        )),
                        elevation: 2.0,
                        backgroundColor: Colors.white,
                      ),
                      Text(
                        'Select Country',
                        style: TextStyle(color: Colors.black38),
                      ),
                    ]),
              ),
            ),
            Expanded(
              child: Container(),
              flex: 1,
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: GridView.count(
                  mainAxisSpacing: 2,
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 1,
                  padding: EdgeInsets.only(left: kFloatingActionButtonMargin),
                  childAspectRatio: 1.5,
                  children: months.map((String month) {
                    return Card(
                            margin: EdgeInsets.only(right: 10),
                            color: monthToColorMap[month],
                            child: Column(
                              children: <Widget>[
                               Expanded(
                                 flex: 2,
                                 child: 
                                 Align(
                                   alignment: Alignment(-1.0, 0.5),
                                   child: Padding(
                                     padding: const EdgeInsets.only(left: 16.0),
                                     child: Text(month,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                   ))),
                                 Divider(
                                   indent: 16,
                                   color: Colors.white54,

                                 ),
                                Expanded(
                                  flex: 7,
                                  child: Container(

                                  ),
                                )

                              ],
                            ),
                          );
                  }).toList(),

                  // itemBuilder: (BuildContext context, int index) {
                  //   return
                  //   index == 0
                  //   ?
                  //   Card(
                  //       margin: EdgeInsets.only(left: 30.0, right: 10.0),
                  //       color: Colors.red,
                  //       child: Container(
                  //         width: 30.0,
                  //       ),
                  //     )
                  //   :
                  //   Card(
                  //     margin: EdgeInsets.only(right: 10.0),
                  //     color: Colors.blue,
                  //   );
                  // },
                ),
              ),
            ),
            Expanded(
              child: Container(),
              flex: 1,
            ),
          ]),
        ),
        bottomNavigationBar: BottomAppBar(
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
        ),
      ),
    );
  }
}
