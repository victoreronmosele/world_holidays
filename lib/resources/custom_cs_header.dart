import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

import 'package:flutter/material.dart';

/// This widgets is used as a grouping separator.
/// The [title] attribute is optional.
class CustomCSHeader extends StatelessWidget {
  final String title;
  final Color backgroundColorDark;

  CustomCSHeader(
    this.title, {
    this.backgroundColorDark = Colors.black12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
      child: Text(title.toUpperCase(),
          style: TextStyle(
              color: Theme.of(context).textTheme.display2.color,
              fontSize: CS_HEADER_FONT_SIZE)),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? backgroundColorDark
              : CS_HEADER_COLOR,
          border:
              Border(bottom: BorderSide(color: CS_BORDER_COLOR, width: 1.0))),
    );
  }
}
