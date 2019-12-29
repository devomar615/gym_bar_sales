import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';

item({String statistics, String title, String image, Function onPress}) {
  return GestureDetector(
    onTap: onPress,
    child: Card(
      color: Colors.black,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            child: Opacity(
              opacity: 0.4,
              child:
                  Image.asset(image, width: 320, height: 300, fit: BoxFit.fill),
            ),
          ),
          statistics == null
              ? titleOnly(title)
              : titleStatistics(title: title, statistics: statistics)
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(20),
    ),
  );
}

titleStatistics({title, statistics}) {
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 110, right: 20),
        child: Text(
          statistics,
          style: imageStatistics,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 110, right: 20),
        child: Text(
          title,
          style: imageTitle,
        ),
      ),
    ],
  );
}

titleOnly(title) {
  return Padding(
    padding: const EdgeInsets.only(top: 110, right: 20),
    child: Text(
      title,
      style: imageTitle,
    ),
  );
}
