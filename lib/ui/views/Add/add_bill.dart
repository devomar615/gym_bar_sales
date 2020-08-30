import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/category.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/ui/views/Add/sliding_app_panel.dart';
import 'package:gym_bar_sales/ui/views/base_view.dart';
import 'package:gym_bar_sales/ui/widgets/home_item.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AddBill extends StatefulWidget {
  @override
  _AddBillState createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {
  String selectedCategory = "All";
  List<Product> filteredProduct;
  List<Product> selectedList = List<Product>();
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  var branch = "بيفرلي";

  appBar() {
    return Row(
      children: <Widget>[
        RaisedButton(
          child: Text("profile"),
          onPressed: () {},
        ),
        RaisedButton(
          child: Text("treasury"),
          onPressed: () {},
        ),
        RaisedButton(
          child: Text("menu"),
          onPressed: () {},
        )
      ],
    );
  }

  _buildCategoryList({List<Category> category, List<Product> products}) {
    List<Widget> choices = List();
    if (selectedCategory == "All") {
      filteredProduct = products;
    }
    choices.add(Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: ChoiceChip(
          label: Text("All"),
          selected: selectedCategory == "All",
          onSelected: (selected) {
            setState(() {
              selectedCategory = "All";
              filteredProduct = products;
            });
          },
        )));
    for (int i = 0; i < category.length; i++) {
      choices.add(Container(
        padding: const EdgeInsets.only(left: 50.0),
        child: ChoiceChip(
          label: Text(category[i].name),
          selected: selectedCategory == category[i].name,
          onSelected: (selected) {
            setState(() {
              selectedCategory = category[i].name;
              filteredProduct = products
                  .where((product) => product.category == selectedCategory)
                  .toList();
            });
          },
        ),
      ));
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CategoryModel>(
        onModelReady: (model) =>
            model.fetchCategoriesAndProducts(branchName: branch),
        builder: (context, model, child) => SafeArea(
              child: Scaffold(
                body: SlidingUpPanel(
                  parallaxEnabled: true,
                  backdropEnabled: true,
                  backdropOpacity: 0.3,
                  maxHeight: 630,
                  borderRadius: radius,
                  panel: SlidingUpPanelWidget(
                    billProducts: selectedList,
                  ),
                  collapsed: Container(
                    decoration: BoxDecoration(
                        color: Colors.blueGrey, borderRadius: radius),
                    child: Center(
                      child: Text(
                        "This is the collapsed Widget",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  body: model.state == ViewState.Busy
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          child: CustomScrollView(
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    appBar(),
                                    Wrap(
                                      children: _buildCategoryList(
                                          category: model.categories,
                                          products: model.products),
                                    )
                                  ],
                                ),
                              ),
                              SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return item(
                                        onPressIcon: () {
                                          if (filteredProduct[index]
                                                  .selectionNo >
                                              0) {
                                            setState(() {
                                              filteredProduct[index]
                                                      .selectionNo =
                                                  filteredProduct[index]
                                                          .selectionNo -
                                                      1;
                                            });
                                          }
                                        },
                                        selectionNo:
                                            filteredProduct[index].selectionNo,
                                        topSpace: SizedBox(height: 50),
                                        betweenSpace: SizedBox(height: 20),
                                        title: filteredProduct[index].name,
                                        statistics:
                                            "${filteredProduct[index].netTotalQuantity}"
                                            "${filteredProduct[index].unit} ",
                                        assetImage: "",
                                        backGround: Colors.black,
                                        onPress: () {
                                          setState(() {
                                            filteredProduct[index].selectionNo =
                                                filteredProduct[index]
                                                        .selectionNo +
                                                    1;
                                          });
                                          if (!selectedList.contains(
                                              filteredProduct[index])) {
                                            selectedList
                                                .add(filteredProduct[index]);
                                          }
                                          print(
                                              "i will print new productNo. in the next line!");
                                          print(filteredProduct[index]
                                              .selectionNo);
                                        });
                                  },
                                  childCount: filteredProduct.length,
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ));
  }
}
