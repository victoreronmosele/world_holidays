import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:world_holidays/blocs/holiday_bloc.dart';

class CountryTitle extends StatelessWidget {
  const CountryTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                                  .copyWith(fontWeight: FontWeight.w300),
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
