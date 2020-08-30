import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';

Widget item({
  String statistics,
  String title,
  String assetImage,
  String networkImage,
  backGround = Colors.black,
  Function onPress,
  Function onPressIcon,
  topSpace,
  betweenSpace,
  selectionNo,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      color: backGround,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        alignment: AlignmentDirectional.center,
        textDirection: TextDirection.rtl,
        children: <Widget>[
          ClipRRect(
            child: Opacity(
              opacity: 0.4,
              child: assetImage == null
                  ? Image.network(networkImage,
                      width: 400, height: 300, fit: BoxFit.fill)
                  : Image.asset(assetImage,
                      width: 400, height: 300, fit: BoxFit.fill),
            ),
          ),
          statistics == null
              ? titleOnly(title)
              : titleStatistics(
                  title: title,
                  statistics: statistics,
                  topSpace: topSpace,
                  betweenSpace: betweenSpace),
          selectionNo > 0
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: onPressIcon,
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        ),
                        Container(
                          color: Colors.blue,
                          child: Text(selectionNo.toString()),
                        ),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    ),
  );
}

titleStatistics({title, statistics, topSpace, betweenSpace}) {
  return Column(
    children: <Widget>[
      topSpace != null ? topSpace : SizedBox(),
      Text(
        statistics,
        style: imageStatistics,
      ),
      betweenSpace != null ? betweenSpace : SizedBox(),
      Text(
        title,
        style: imageTitle,
      ),
    ],
  );
}

titleOnly(title) {
  return Text(
    title,
    style: imageTitle,
  );
}
