import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';

class GridItem extends StatefulWidget {
  final Key key;
  final ValueChanged<bool> isSelected;
  final String statistics;
  final String title;
  final String assetImage;
  final String networkImage;
  final backGround;
  final topSpace;
  final betweenSpace;

  GridItem({
      this.key,
      this.isSelected,
      this.statistics,
      this.title,
      this.assetImage,
      this.networkImage,
      this.backGround,
      this.topSpace,
      this.betweenSpace});

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
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

    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        color: widget.backGround,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          alignment: AlignmentDirectional.center,
          textDirection: TextDirection.rtl,
          children: <Widget>[
            ClipRRect(
              child: Opacity(
                opacity: 0.4,
                child: widget.assetImage == null
                    ? Image.network(widget.networkImage,
                        width: 400, height: 300, fit: BoxFit.fill)
                    : Image.asset(widget.assetImage,
                        width: 400, height: 300, fit: BoxFit.fill),
              ),
            ),
            widget.statistics == null
                ? titleOnly(widget.title)
                : titleStatistics(
                    title: widget.title,
                    statistics: widget.statistics,
                    topSpace: widget.topSpace,
                    betweenSpace: widget.betweenSpace),
            isSelected
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
