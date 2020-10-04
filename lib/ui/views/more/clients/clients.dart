import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/views/more/more.dart';

class Clients extends StatelessWidget {
  // final String branchName;
  //
  // Clients({this.branchName});
  //
  // static List<String> args = List(2);
  final Dimensions _dimensions = Dimensions();
  final More more = More();

  @override
  Widget build(BuildContext context) {
    // print(branchName + " :mozafeen page");
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
              more.card(
                  onPress: () {
                    print("dsaddsddsadasdsadasdasds");
                    Navigator.pushNamed(
                      context,
                      '/all_clients',
                    );
                    // arguments: branchName);
                  },
                  title: "كل العملاء"),
              more.card(
                  onPress: () {
                    // args = [branchName, "type", "دائن"];
                    Navigator.pushNamed(
                      context,
                      '/filtered_clients',
                    );
                    // arguments: args);
                  },
                  title: "دائن"),
              more.card(
                  onPress: () {
                    // args = [branchName, "type", "مدين"];
                    Navigator.pushNamed(
                      context,
                      '/filtered_clients',
                    );
                    // arguments: args);
                  },
                  title: "مدين"),
            ],
          ),
        ));
  }
}
// Scaffold(
// appBar: AppBar(
// title: Text("العملاء"),
// ),
// body: GestureDetector(
// onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
// child: ListView(
// children: <Widget>[
// Container(
// padding:
// const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
// child: item(
// title: "كل العملاء",
// statistics: '155',
// assetImage: "assets/images/products.jpg",

// ),
// ),
// Container(
// padding:
// const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
// child: item(
// title: "دائن",
// statistics: '155',
// assetImage: "assets/images/clients.jpeg",

// ),
// ),
// Container(
// padding:
// const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
// child: item(
// title: "مدين",
// statistics: '155',
// assetImage: "assets/images/employers.jpg",

// ),
// ),
// ],
// ),
// ),
// );
