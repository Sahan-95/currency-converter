import 'package:flutter/widgets.dart';

Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

/// Return screen width considering media query data.
double displayWidth(BuildContext context) {
  return displaySize(context).width;
}

/// Return screen height considering media query data.
double displayHeight(BuildContext context) {
  return displaySize(context).height;
}