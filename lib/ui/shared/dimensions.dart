import 'package:flutter/material.dart';

class Dimensions {
  double height(context) => MediaQuery.of(context).size.height;

  double width(context) => MediaQuery.of(context).size.width;

  heightPercent(percent, context) {
    return (percent / 100) * height(context);
  }

  widthPercent(percent, context) {
    return (percent / 100) * width(context);
  }
}
