import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import '../../resources/months_color.dart';
import 'bottom_navigation_bar.dart';
import 'country_title.dart';

class WorldHolidays extends StatefulWidget {
  WorldHolidays({
    Key key,
  }) : super(key: key);

  @override
  _WorldHolidaysState createState() => _WorldHolidaysState();
}

class _WorldHolidaysState extends State<WorldHolidays> {
  String _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = "Nigeria";
  }

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
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
            CountryTitle(selectedCountry: _selectedCountry),
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CountryCodePicker(
                        onChanged: (countryCode) {
                          print(countryCode.toCountryCode());
                          setState(() {
                            _selectedCountry = countryCode.toCountryString();
                          });
                        },
                      ),
                      Text(
                        'Select Country',
                        style: TextStyle(color: Colors.black38),
                      ),
                    ]),
              ),
            ),
            Flexible(
              child: Container(),
            ),
            MonthCards(),
            Expanded(
              child: Container(),
              flex: 1,
            ),
          ]),
        ),
        bottomNavigationBar:  BottomNavigationBarWidget(),
      ),
    );
  }
}

class MonthCards extends StatelessWidget {
  const MonthCards({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        child: GridView.count(
          mainAxisSpacing: 2,
          scrollDirection: Axis.horizontal,
          crossAxisCount: 1,
          padding: EdgeInsets.only(left: kFloatingActionButtonMargin),
          childAspectRatio: 1.5,
          children: monthToColorMap.keys.map((String month) {
            return Card(
              margin: EdgeInsets.only(right: 10),
              color: monthToColorMap[month],
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Align(
                          alignment: Alignment(-1.0, 0.5),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(month,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ))),
                  Divider(
                    indent: 16,
                    color: Colors.white54,
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(),
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}



