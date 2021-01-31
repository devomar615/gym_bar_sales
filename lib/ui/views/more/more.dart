import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/view_models/transaction_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/widgets/general_item.dart';
import 'package:provider/provider.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  var branch = "بيفرلي";
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<TransactionModel>(context)
          .fetchTransaction(branchName: branch)
          .then((_) {
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Dimensions _dimensions = Dimensions(context);
    GeneralItem _homeItem = GeneralItem(context: context);
    double itemHeight = _dimensions.heightPercent(3);
    double itemWidth = _dimensions.widthPercent(3);

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
              _homeItem.uiCard(
                  onPress: () => Navigator.pushNamed(context, '/clients'),
                  title: "العملاء"),
              _homeItem.uiCard(
                  onPress: () => Navigator.pushNamed(context, '/add_product'),
                  title: "اضافة كميه"),
              _homeItem.uiCard(
                  onPress: () => Navigator.pushNamed(context, '/report'),
                  title: "البلاغات"),
              _homeItem.uiCard(
                  onPress: () => Navigator.pushNamed(context, '/logout'),
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
