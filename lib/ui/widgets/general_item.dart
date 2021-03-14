import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';

class GeneralItem {
  final context;

  GeneralItem({@required this.context});

  Widget customCard({
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
    bool bigTitle = false,
    @required selectionNo,
  }) {
    Dimensions _dimensions = Dimensions(context);
    return GestureDetector(
      onTap: onPressIcon,
      onTapDown: onTapDownIcon,
      onTapUp: onTapUpIcon,
      onTapCancel: onTapCancelIcon,
      child: GestureDetector(
        onTapUp: onTapUpItem,
        onTapDown: onTapDownItem,
        onTapCancel: onTapCancelItem,
        onTap: onPressItem,
        child: Stack(
          children: [
            Container(
              width: _dimensions.widthPercent(70),
              height: _dimensions.widthPercent(70),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_dimensions.heightPercent(1))),
                elevation: 5,
                color: networkImage == null ? backGround : Colors.black,
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Opacity(
                        opacity: 0.4,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: assetImage == null
                              ? CachedNetworkImage(
                                  imageUrl: networkImage,
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => new Icon(Icons.error),
                                )
                              : Image.asset(assetImage),
                        ),
                      ),
                    ),
                    if (statistics == null)
                      titleOnly(bigTitle: bigTitle, title: title)
                    else
                      titleStatistics(
                          bigTitle: bigTitle,
                          title: title,
                          statistics: statistics,
                          topSpace: topSpace,
                          betweenSpace: betweenSpace)
                  ],
                ),
              ),
            ),
            if (selectionNo > 0)
              Positioned(
                top: 0.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: onPressIcon,
                  onTapDown: onTapDownIcon,
                  onTapUp: onTapUpIcon,
                  onTapCancel: onTapCancelIcon,
                  child: Container(
                    // height: _dimensions.heightPercent(2.),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(_dimensions.widthPercent(30)),
                    ),
                    constraints: BoxConstraints(
                      minWidth: _dimensions.widthPercent(2.5),
                      maxWidth: _dimensions.widthPercent(10),
                      minHeight: _dimensions.widthPercent(2.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              )
            else
              Container()
          ],
        ),
      ),
    );
  }

  titleStatistics({bool bigTitle, title, statistics, topSpace, betweenSpace}) {
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
          style: bigTitle ? _textStyles.itemImageTitle() : _textStyles.itemImageTitleSmall(),
        ),
      ],
    );
  }

  titleOnly({bool bigTitle, title}) {
    TextStyles _textStyles = TextStyles(context: context);

    return Text(
      title,
      style: bigTitle ? _textStyles.itemImageTitle() : _textStyles.itemImageTitleSmall(),
    );
  }
}
