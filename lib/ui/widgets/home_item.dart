import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';

Widget item({
  String statistics,
  @required String title,
  String assetImage,
  @required String networkImage,
  backGround = Colors.black,
  Function onPress,
  Function onPressIcon,
  Function onTapDownIcon,
  Function onTapUpIcon,
  Function onTapCancelIcon,
  topSpace,
  betweenSpace,
  @required selectionNo,
}) {
  return GestureDetector(
    onTap: onPressIcon,
    onTapDown: onTapDownIcon,
    onTapUp: onTapUpIcon,
    onTapCancel: onTapCancelIcon,
    child: Badge(
      position: BadgePosition.topEnd(end: -1, top: -15),
      padding: EdgeInsets.all(12),
      badgeColor: Colors.red,
      badgeContent: Column(
        children: [
          SizedBox(
            height: 3,
          ),
          Text(
            '-',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ],
      ),
      showBadge: selectionNo > 0,
      child: GestureDetector(
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
                      ? Image.network(networkImage, width: 400, height: 300, fit: BoxFit.fill)
                      : Image.asset(assetImage, width: 400, height: 300, fit: BoxFit.fill),
                ),
              ),
              statistics == null
                  ? titleOnly(title)
                  : titleStatistics(
                      title: title,
                      statistics: statistics,
                      topSpace: topSpace,
                      betweenSpace: betweenSpace),
            ],
          ),
        ),
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
