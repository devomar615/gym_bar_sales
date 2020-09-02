import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/category.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/shared/ui_helpers.dart';
import 'package:gym_bar_sales/ui/views/base_view.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:gym_bar_sales/ui/widgets/home_item.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;

class AddBill extends StatefulWidget {
  @override
  _AddBillState createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {
  final TextEditingController name = TextEditingController();
  String selectedCategory = "All";
  List<Product> filteredProduct;
  List<Product> selectedList = List<Product>();
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(28.0),
    topRight: Radius.circular(28.0),
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
          labelStyle: chipLabelStyleLight,
          selectedColor: Colors.green,
          backgroundColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.green),
          ),
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
        padding: const EdgeInsets.only(left: 30.0),
        child: ChoiceChip(
          labelStyle: chipLabelStyleLight,
          selectedColor: Colors.orange,
          backgroundColor: Colors.white,
          shape: StadiumBorder(side: BorderSide(color: Colors.orange)),
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

  billHeader() {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Text(
          "الفاتوره",
          style: headerStyle,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: formTextFieldTemplate(
                width: 400,
                controller: name,
                hint: "hint here",
                onChanged: (data) {},
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text('اسم المشتري2'),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text("موظف"),
              color: Colors.black12,
              onPressed: () {},
            ),
            UIHelper.horizontalSpaceLarge(),
            RaisedButton(
              child: Text("عامل"),
              color: Colors.blue,
              onPressed: () {},
            ),
            UIHelper.horizontalSpaceLarge(),
            RaisedButton(
              child: Text("عميل"),
              color: Colors.black12,
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  tableHead() {
    return Container(
      height: 60,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("سعر القطعه", style: tableTitleStyle),
              SizedBox(width: 10),
            ],
          )),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("العدد", style: tableTitleStyle),
              SizedBox(width: 10),
            ],
          )),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("اسم المنتج", style: tableTitleStyle),
              SizedBox(width: 10),
            ],
          )),
        ],
      ),
    );
  }

  tableBuilder() {
    return ListView.builder(
        itemCount: selectedList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                  minHeight: 15.0,
                  maxHeight: 200,
                ),
                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(width: 200),
                    Container(
                      child: Text(selectedList[index].customerPrice,
                          style: tableContentStyle),
                      constraints: BoxConstraints(
                        maxWidth: 100.0,
                        minWidth: 100,
                      ),
                    ),
                    SizedBox(width: 200),
                    Row(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 100.0,
                            minWidth: 100,
                          ),
                          child: IconButton(
                            color: Colors.red,
                            iconSize: 50,
                            icon: Icon(Icons.remove_circle),
                            onPressed: () {
                              if (selectedList[index].selectionNo > 0) {
                                setState(() {
                                  selectedList[index].selectionNo =
                                      selectedList[index].selectionNo - 1;
                                });
                              }
                              if (selectedList[index].selectionNo == 0) {
                                selectedList.removeAt(index);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 50),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 100.0,
                            minWidth: 50,
                          ),
                          child: Text(
                              selectedList[index].selectionNo.toString(),
                              style: tableContentStyle),
                        ),
                        SizedBox(width: 10),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 100.0,
                            minWidth: 100,
                          ),
                          child: IconButton(
                              color: Colors.green,
                              iconSize: 50,
                              icon: Icon(Icons.add_circle),
                              onPressed: () {
                                setState(() {
                                  selectedList[index].selectionNo =
                                      selectedList[index].selectionNo + 1;
                                });
                              }),
                        ),
                        SizedBox(width: 180),
                      ],
                    ),

                    //todo: change customerPrice to the selected one in the slidingUpPanel.
                    Container(
                        constraints: BoxConstraints(
                          maxWidth: 100.0,
                          minWidth: 100,
                        ),
                        child: Text(selectedList[index].name,
                            style: tableContentStyle))
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.black),
              Divider(height: 1, color: Colors.black),
            ],
          );
        });
  }

  billFooter(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '500',
              style: formTitleStyle,
            ),
            SizedBox(
              width: 80,
            ),
            Text(
              'الاجمالي',
              style: formTitleStyle,
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        SizedBox(height: 20),
        Divider(height: 1, color: Colors.black),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('500', style: formTitleStyle),
            SizedBox(width: 80),
            Text('المدفوع', style: formTitleStyle),
            SizedBox(width: 20),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                constraints: BoxConstraints(
                  minWidth: 110,
                  minHeight: 50,
                  maxWidth: 500,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text('الباقي: 12', style: formTitleStyle),
                  ],
                )),
            SizedBox(width: 15),
          ],
        ),
        SizedBox(height: 15),
        Center(
            child: ButtonTheme(
          minWidth: 200.0,
          height: 40,
          child: RaisedButton(
            color: Colors.blueAccent,
            child: Text(
              "إتمام العمليه",
              style: formButtonStyle,
            ),
            onPressed: () {},
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        )),
        SizedBox(height: 20),
      ],
    );
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
                  maxHeight: 800,
                  borderRadius: radius,
                  panel: Column(
                    children: [
                      billHeader(),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            tableHead(),
                            Expanded(child: tableBuilder()),
                          ],
                        ),
                      ),
                      billFooter(context),
                    ],
                  ),
                  collapsed: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: radius),
                    child: Center(
                      child: Text("الفاتوره", style: headerStyle),
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
                                  ],
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  height: 50.0,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: _buildCategoryList(
                                        category: model.categories,
                                        products: model.products),
                                  ),
                                ),
                              ),
                              SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0, top: 20.0, right: 20),
                                      child: item(
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
                                          if (selectedList[index].selectionNo ==
                                              0) {
                                            selectedList.removeAt(index);
                                          }
                                        },
                                        selectionNo:
                                            filteredProduct[index].selectionNo,
                                        statistics:
                                            filteredProduct[index].selectionNo >
                                                    0
                                                ? filteredProduct[index]
                                                    .selectionNo
                                                    .toString()
                                                : "",
                                        topSpace: SizedBox(height: 50),
                                        betweenSpace: SizedBox(height: 20),
                                        title: filteredProduct[index].name,
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
                                        },
                                      ),
                                    );
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
//todo: make one list only for bill table by filtering ther filterd product where selectionNo > 0;