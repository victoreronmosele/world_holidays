import 'package:flutter/material.dart';

class CountryTitle extends StatelessWidget {
  const CountryTitle({
    Key key,
    @required String selectedCountry,
  })  : _selectedCountry = selectedCountry,
        super(key: key);

  final String _selectedCountry;

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
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Holidays in \n",
                        style: Theme.of(context).textTheme.display1.copyWith(
                              fontWeight: FontWeight.w300
                            ),
                        children: <TextSpan>[
                          TextSpan(
                            text: _selectedCountry,
                            style: Theme.of(context).textTheme.headline.copyWith(
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ])),
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
