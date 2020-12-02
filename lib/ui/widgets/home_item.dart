import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';

class HomeItem {
  final context;

  HomeItem({@required this.context});

  Widget item({
    String statistics,
    @required String title,
    String assetImage,
    @required String networkImage,
    backGround = Colors.black,
    Function onPressItem,
    Function onTapUpItem,
    Function onTapDownItem,
    Function onTapCancelItem,
    Function onPressIcon,
    Function onTapDownIcon,
    Function onTapUpIcon,
    Function onTapCancelIcon,
    topSpace,
    betweenSpace,
    @required selectionNo,
  }) {
    Dimensions _dimensions = Dimensions(context);
    TextStyles _textStyles = TextStyles(context: context);

    return GestureDetector(
      onTap: onPressIcon,
      onTapDown: onTapDownIcon,
      onTapUp: onTapUpIcon,
      onTapCancel: onTapCancelIcon,
      child: Badge(
        position: BadgePosition.topEnd(
            end: -_dimensions.heightPercent(0.1),
            top: -_dimensions.heightPercent(2)),
        padding: EdgeInsets.all(_dimensions.heightPercent(1.5)),
        badgeColor: Colors.red,
        badgeContent: Column(
          children: [
            SizedBox(
              height: _dimensions.heightPercent(0.5),
            ),
            Text(
              '-',
              style: _textStyles.itemBadgeStyle(),
            ),
          ],
        ),
        showBadge: selectionNo > 0,
        child: GestureDetector(
          onTapUp: onTapUpItem,
          onTapDown: onTapDownItem,
          onTapCancel: onTapCancelItem,
          onTap: onPressItem,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(_dimensions.heightPercent(1))),
            elevation: 5,
            color: networkImage == null ? backGround : Colors.black,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              alignment: AlignmentDirectional.center,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Opacity(
                  opacity: 0.4,
                  child: assetImage == null
                      ? Image.network(networkImage,
                          width: _dimensions.widthPercent(30),
                          height: _dimensions.heightPercent(34),
                          fit: BoxFit.fill)
                      : Image.asset(assetImage,
                      width: _dimensions.widthPercent(30),
                      height: _dimensions.heightPercent(34), fit: BoxFit.fill),
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
    TextStyles _textStyles = TextStyles(context: context);

    return Column(
      children: <Widget>[
        topSpace != null ? topSpace : SizedBox(),
        Text(
          statistics,
          style: _textStyles.itemImageStatistics(),
        ),
        betweenSpace != null ? betweenSpace : SizedBox(),
        Text(
          title,
          style: _textStyles.itemImageTitle(),
        ),
      ],
    );
  }

  titleOnly(title) {
    TextStyles _textStyles = TextStyles(context: context);

    return Text(
      title,
      style: _textStyles.itemImageTitle(),
    );
  }
}
