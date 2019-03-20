import 'package:flutter/material.dart';
import 'package:world_holidays/resources/custom_expansion_panel.dart';
import 'package:world_holidays/models/holiday_data.dart';
import '../../resources/months_color.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MonthHolidayDetails extends StatefulWidget {
  final int monthIndex;
  // final String month;
  final List<List<Holiday>> listOfHolidayList;

  MonthHolidayDetails(
      {Key key,
      @required this.monthIndex,
      // @required this.month,
      @required this.listOfHolidayList})
      : super(key: key);

  @override
  MonthHolidayDetailsState createState() {
    return new MonthHolidayDetailsState();
  }
}

class MonthHolidayDetailsState extends State<MonthHolidayDetails>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  int initialMonthIndex;
  int currentMonthIndex;
  double screenWidth;
  List<List<Holiday>> listOfHolidayLists;
  List<Holiday> currentMonthHolidayList;
  Animation<double> dividerIndentAnimation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    initialMonthIndex = widget.monthIndex;
    currentMonthIndex = initialMonthIndex;
    listOfHolidayLists = widget.listOfHolidayList;
    currentMonthHolidayList = listOfHolidayLists[currentMonthIndex];

    _pageController = PageController(initialPage: initialMonthIndex);

    animationController =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);

    dividerIndentAnimation = Tween<double>(begin: 5000.0, end: 0.0)
        //Chose 5000.0 as arbitrary begin value
        .animate(animationController)
          ..addListener(() {
            setState(() {
              //This animates the divider indent by update its state
            });
          });

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context, currentMonthIndex);
              },
            ),
          ],
        ),
        body:
            // Container(child:
            PageView.builder(
          onPageChanged: (pageId) {
            print(pageId.toString());
            setState(() {
              currentMonthIndex = pageId;
              currentMonthHolidayList = listOfHolidayLists[currentMonthIndex];
            });

            print("current =>" + currentMonthIndex.toString());
          },
          physics: BouncingScrollPhysics(),
          controller: _pageController,
          itemCount: monthToColorMap.length,
          itemBuilder: (context, position) {
            return Column(children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                    // color: Colors.black,
                    ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                    // color: Colors.blue,
                    //   child: Row(
                    //     children: <Widget>[
                    //       Flexible(
                    //         child: Container(
                    //             // color: Colors.green,
                    //             ),
                    //       ),
                    //       Expanded(
                    //         flex: 4,
                    child: ListTile(
                  leading: Text(""),
                  title: Hero(
                    tag: "month-text" + position.toString(),
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        monthToColorMap.keys.toList()[position],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Text(
                        "${currentMonthHolidayList.length == 0 ? "No" : currentMonthHolidayList.length} ${currentMonthHolidayList.length == 1 ? "holiday" : "holidays"}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.black38),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      Divider(
                        indent: dividerIndentAnimation.value,
                        height: 2,
                        color: Colors.black38,
                      ),
                      Spacer(
                        flex: 2,
                      )
                    ],
                  ),

                  // ),
                )),
              ),
              Spacer(),
              Expanded(
                flex: 11,

                child: currentMonthHolidayList.isEmpty
                    ? Center(
                        child: Text("No holidays this month",
                            style: TextStyle(color: Colors.black)))
                    : SingleChildScrollView(
                        child: Container(
                          child: SafeArea(
                            child: Container(
                              child: CustomExpansionPanelList(
                                expansionCallback:
                                    (int index, bool isExpanded) {
                                  setState(() {
                                    currentMonthHolidayList[index].isExpanded =
                                        !currentMonthHolidayList[index]
                                            .isExpanded;
                                  });
                                },

                                children: currentMonthHolidayList
                                    .map((Holiday holiday) {
                                  int holidayIndex = currentMonthHolidayList.indexOf(holiday);

                                  return CustomExpansionPanel(
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return Container(
                                        // color: Colors.blue,
                                        child: ListTile(
                                          
                                          // dense: true,
                                          title: Text(
                                            holiday.name,
                                            style: TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                            // DateFormat
                                            DateFormat.EEEE()
                                                .format(DateTime.parse(
                                                    holiday.date.iso))
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black38,
                                            ),
                                          ),
                                          leading: Text(
                                              holiday.date.datetime.day
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w300)),
                                          trailing: IconButton(
                                            icon: Icon(
                                              Icons.alarm_on,
                                              color: monthToColorMap.values
                                                  .toList()[position],
                                            ),
                                            onPressed: null
                                              // _showNotificationWithSound
                                            ,
                                          ),
                                        ),
                                      );
                                    },
                                    body: Container(
                                      // color: Colors.green,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                                                              child: ListTile(
                                          // dense: true,
                                          leading: Text(""),
                                          title: Text(
                                            holiday.description ??
                                                "No description available",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    isExpanded: holiday.isExpanded,
                                  );
                                }).toList(),

                                //     //         return ListTile(
                                //     //           leading: IconButton(
                                //     //             onPressed: () {},
                                //     //             icon: Icon(Icons.alarm),
                                //     //           ),
                                //     //           title: Text("Broom day"),
                                //     //         );
                                //     //       },
                                //     //       body: Container(
                                //     //         color: Colors.white,
                                //     //         child: Align(
                                //     //           alignment: Alignment(0.5, 0.5),
                                //     //           child: ListTile(
                                //     //               title: Text(
                                //     //                 "Buhari's birthday",
                                //     //                 style: TextStyle(color: Colors.black54),
                                //     //               ),
                                //     //               trailing: IconButton(
                                //     //                 icon: Icon(Icons.alarm),
                                //     //               )),
                                //     //         ),
                                //     //       ),
                                //     //       // headerBuilder: (BuildContext context, bool isExpanded) {
                                //     //       //   return buildShopItemHeader(coinAsset, shopItems, i);
                                //     //       // },
                                //     //       isExpanded: false,
                                //     //       // isExpanded: true,
                                //     //     ),
                              ),
                            ),
                          ),
                        ),
                      ),
                // Expanded(
                //   flex: 1,
                //   child: Container(
                //     height: 2.0,
                //     color: monthToColorMap.values.toList()[position],
                //   ),
                // ),
                // Expanded(flex: 9, child: Container())
              ),
            ]);
          },
        ),
        bottomNavigationBar: Container(
          height: kBottomNavigationBarHeight,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: monthToColorMap.keys.map((String month) {
                int monthIndex = monthToColorMap.keys.toList().indexOf(month);
                return Hero(
                  tag: 'hero-tag' + month,
                  child: Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: MediaQuery.of(context).size.width / 32,
                        height: currentMonthIndex == monthIndex
                            ? kBottomNavigationBarHeight / 1.2
                            : kBottomNavigationBarHeight / 2.0,
                        color: monthToColorMap.values.toList()[monthIndex],
                        // child: Text("kk"),
                      ),
                    ),
                  ),
                );
              }).toList()),
        ), // ),
        resizeToAvoidBottomPadding: false,
      ),
    );
  }
}
