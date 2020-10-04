import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';

class More extends StatelessWidget {
  final Dimensions _dimensions = Dimensions();

  Widget card({title, onPress}) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // elevation: 5,
        color: Colors.black,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          alignment: AlignmentDirectional.center,
          textDirection: TextDirection.rtl,
          children: <Widget>[
            ClipRRect(
              child: Opacity(
                opacity: 0.4,
                child: Image.asset("assets/images/clients.jpeg",
                    width: double.infinity, height: double.infinity, fit: BoxFit.fill),
              ),
            ),
            Text(
              title,
              style: imageTitle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double itemHeight = _dimensions.heightPercent(3, context);
    double itemWidth = _dimensions.widthPercent(3, context);

    return Scaffold(
        appBar: AppBar(
          title: Text("المزيد"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 50),
          child: GridView(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 50,
              crossAxisSpacing: 50,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            children: <Widget>[
              card(
                  onPress: () {
                    Navigator.pushNamed(context, '/clients');
                  },
                  title: "العملاء"),
              card(
                  onPress: () {
                    Navigator.pushNamed(context, '/add_product');
                  },
                  title: "اضافة كميه"),
              card(
                  onPress: () {
                    Navigator.pushNamed(context, '/report');
                  },
                  title: "البلاغات"),
              card(
                  onPress: () {
                    Navigator.pushNamed(context, '/logout');
                  },
                  title: "تسجيل الخروج"),
            ],
          ),
        ));
  }
}

// Container(
// color: Colors.white30,
// child: GridView.count(
//
// crossAxisCount: 2,
// childAspectRatio: 1.0,
// padding: const EdgeInsets.all(2.0),
// mainAxisSpacing: 2.0,
// crossAxisSpacing: 2.0,
// children: [
// item(title: 'Text', networkImage: "", selectionNo: 0),
// item(title: 'Text', networkImage: "", selectionNo: 0),
// item(title: 'Text', networkImage: "", selectionNo: 0),
// item(title: 'Text', networkImage: "", selectionNo: 0),
// ]),
// )
