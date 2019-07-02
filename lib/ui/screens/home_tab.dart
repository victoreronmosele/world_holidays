import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:world_holidays/blocs/app_bloc.dart';
import 'package:world_holidays/blocs/holiday_bloc.dart';
import 'package:world_holidays/helpers/bloc_provider.dart';
import 'package:world_holidays/models/holiday_data.dart';
import 'package:world_holidays/resources/custom_country_code_picker/custom_country_code_picker.dart';
import 'package:world_holidays/resources/months_color.dart';
import 'package:world_holidays/ui/screens/holiday_details_page.dart';

class CountryTitle extends StatelessWidget {
  const CountryTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HolidayBloc holidayBloc = BlocProvider.of<AppBloc>(context).holidayBloc;

    return Expanded(
      flex: 6,
      child: Container(
        // color: Colors.blue,
        width: double.infinity,
        child: Align(
          alignment: Alignment(0.0, 0.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: RotatedBox(
                    quarterTurns: 2,
                    child: Divider(
                      indent: 30,
                      color: Theme.of(context).dividerColor,
                    )),
              ),
              Expanded(
                flex: 3,
                child: StreamBuilder<String>(
                    stream: holidayBloc.currentSelectedCountryNameValue,
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: SpinKitThreeBounce(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                            size: 20.0,
                          ),
                        );
                      }

                      String selectedCountry = snapshot.data;
                      return RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "Holidays in \n",
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: Theme.of(context)
                                          .textTheme
                                          .display2
                                          .color),
                              children: <TextSpan>[
                                TextSpan(
                                  text: selectedCountry,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline
                                      .copyWith(fontWeight: FontWeight.bold),
                                )
                              ]));
                    }),
              ),
              Expanded(
                flex: 1,
                child: Divider(
                  indent: 30,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HolidayBloc holidayBloc = BlocProvider.of<AppBloc>(context).holidayBloc;

    return Container(
      key: ValueKey(1),
      child: Column(children: <Widget>[
        CountryTitle(),
        Expanded(
          flex: 4,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CountryCodePicker(
                  initialSelection:
                      holidayBloc.currentSelectedCountryCodeValue.value,
                  onChanged: (countryCode) async {
                    if (countryCode != null) {
                      holidayBloc.setCurrentCountryDetails(
                        countryCode: countryCode.toCountryCode(),
                        countryName: countryCode.toCountryString(),
                      );
                    }
                  },
                ),
                Text(
                  'Select Country',
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Theme.of(context).textTheme.display2.color),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(),
          flex: 1,
        ),
        MonthCards(
          countryCode: holidayBloc.currentSelectedCountryCodeValue.value,
          countryName: holidayBloc.currentSelectedCountryNameValue.value,
        ),
        Expanded(
          child: Container(),
          flex: 1,
        ),
      ]),
    );
  }
}

class MonthCards extends StatefulWidget {
  final String countryCode;
  final String countryName;

  const MonthCards({
    this.countryCode,
    this.countryName,
    Key key,
  }) : super(key: key);

  @override
  MonthCardsState createState() {
    return new MonthCardsState();
  }
}

class MonthCardsState extends State<MonthCards> {
  ScrollController controller = ScrollController();

  HolidayBloc holidayBloc;

  @override
  Widget build(BuildContext context) {
    holidayBloc = BlocProvider.of<AppBloc>(context).holidayBloc;
    return Expanded(
      flex: 10,
      child: Container(
        child: StreamBuilder(
          stream: holidayBloc.holidaysValue,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Map<String, List<Holiday>> monthToHolidayListMap =
                holidayBloc.getMapOfMonthToHolidayList(snapshot);

            return GridView.count(
              mainAxisSpacing: 2,
              controller: controller,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              crossAxisCount: 1,
              padding: EdgeInsets.only(left: kFloatingActionButtonMargin),
              childAspectRatio: 1.5,
              children: monthToColorMap.keys.map(
                (String month) {
                  int monthIndex = monthToColorMap.keys.toList().indexOf(month);

                  return Hero(
                    tag: 'hero-tag' + month,
                    child: Material(
                      color: Colors.transparent,
                      child: Card(
                        color: Colors.transparent,
                        margin: EdgeInsets.only(right: 10),
                        child: Material(
                          color: monthToColorMap[month],
                          child: InkWell(
                            onTap: () async {
                              if (snapshot.hasData) {
                                List<List<Holiday>> listOfHolidayLists =
                                    monthToHolidayListMap.values.toList();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HolidayDetailsPage(
                                          monthIndex: monthIndex,
                                          listOfHolidayList: listOfHolidayLists,
                                          countryName: widget.countryName,
                                        ),
                                  ),
                                );
                              }
                            },
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment(-1.0, 0.5),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(month,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  indent: 16,
                                  color: Colors.white54,
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                      child: Align(
                                          alignment: Alignment(0.0, -0.4),
                                          child: getMonthCard(snapshot,
                                              monthToHolidayListMap, month))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget getMonthCard(
    AsyncSnapshot snapshot,
    Map<String, List<Holiday>> monthToHolidayListMap,
    String month,
  ) {

    int monthIndex = monthToColorMap.keys.toList().indexOf(month);

    if (snapshot.hasData) {
      var listOfHolidayLists = monthToHolidayListMap.values.toList();
      List<Holiday> holidayList = listOfHolidayLists[monthIndex];

      if (holidayList.isEmpty) {
        return Align(
          alignment: Alignment(0.0, 0.0),
          child: Text(
            "No holidays \nfor this month",
            style: TextStyle(color: Colors.white, fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                holidayList.isEmpty ? "N/A" : holidayList.elementAt(0).name,
                style: TextStyle(color: Colors.white, fontSize: 12.0),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                holidayList.length < 2 ? "" : holidayList.elementAt(1).name,
                style: TextStyle(color: Colors.white, fontSize: 12.0),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                holidayList.length < 3 ? "" : holidayList.elementAt(2).name,
                style: TextStyle(color: Colors.white, fontSize: 12.0),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text('${holidayList.length >= 3 ? "..." : ""}',
                    style: TextStyle(color: Colors.white70))),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: holidayList.length.toString(),
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            '${holidayList.length == 1 ? ' holiday' : " holidays"}',
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.normal))
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (snapshot.hasError) {
      return Align(
        alignment: Alignment(0.0, 0.0),
        child: Text(
          "Not available",
          style: TextStyle(color: Colors.white, fontSize: 12.0),
          textAlign: TextAlign.center,
        ),
      );
    }
// By default, show a loading spinner
    return Align(
      alignment: Alignment(0.0, 0.0),
      child: SpinKitThreeBounce(
        color: Colors.white,
        size: 20.0,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
