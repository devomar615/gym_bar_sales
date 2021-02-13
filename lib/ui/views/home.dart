import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/category.dart';
import 'package:gym_bar_sales/core/services/bill_services.dart';
import 'package:gym_bar_sales/core/services/home_services.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/core/view_models/total_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:provider/provider.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/ui/widgets/general_item.dart';

File file;
Timer timer;
const List<String> choices = <String>[
  "العملاء",
  "البلاغات",
  "الاعدادات",
  "تسجيل الخروج",
];

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyles _textStyles = TextStyles(context: context);
    FormWidget _formWidget = FormWidget(context: context);
    Dimensions _dimensions = Dimensions(context);
    GeneralItem _generalItem = GeneralItem(context: context);
    CategoryModel categoryModel = Provider.of<CategoryModel>(context);
    ProductModel productModel = Provider.of<ProductModel>(context);
    TotalModel totalModel = Provider.of<TotalModel>(context);
    HomeServices homeServices = Provider.of<HomeServices>(context);
    BillServices billServices = Provider.of<BillServices>(context);
    String selectedCategory = categoryModel.selectedCategory;
    List<Category> categories = categoryModel.categories;
    String transactionType = homeServices.transactionType;
    bool switcherOpen = homeServices.switcherOpen;
    List<Product> products = productModel.filterProduct(selectedCategory);
    var selectedList = productModel.getSelectedProducts();
    Widget addPhoto() {
      if (file == null) {
        return _formWidget.logo(
            imageContent:
                Image.asset("assets/images/myprofile.jpg", fit: BoxFit.cover),
            backgroundColor: Colors.white);
      } else
        return _formWidget.logo(
            imageContent: Image.file(file, fit: BoxFit.cover));
    }

    _buildCategoryList() {
      List<Widget> choices = List();
      choices.add(Container(
          padding: EdgeInsets.only(left: _dimensions.heightPercent(2)),
          child: ChoiceChip(
            labelStyle: _textStyles.chipLabelStyleLight(),
            selectedColor: Colors.green,
            backgroundColor: Colors.white,
            shape: StadiumBorder(
              side: BorderSide(color: Colors.green),
            ),
            label: Text("All"),
            selected: selectedCategory == "All",
            onSelected: (selected) {
              categoryModel.selectedCategory = "All";
            },
          )));

      for (int i = 0; i < categories.length; i++) {
        choices.add(Container(
          padding: EdgeInsets.only(left: _dimensions.heightPercent(2)),
          child: ChoiceChip(
            labelStyle: _textStyles.chipLabelStyleLight(),
            selectedColor: Colors.orange,
            backgroundColor: Colors.white,
            shape: StadiumBorder(side: BorderSide(color: Colors.orange)),
            label: Text(categories[i].name),
            selected: selectedCategory == categories[i].name,
            onSelected: (selected) {
              categoryModel.selectedCategory = categories[i].name;
              // filteredProducts = products
              //     .where((product) => product.category == selectedCategory)
              //     .toList();
            },
          ),
        ));
      }
      return choices;
    }

    onSelected(choice) {
      if (choice == "العملاء") {
        Navigator.pushNamed(context, '/clients');
      }
      if (choice == "البلاغات") {
        // Navigator.pushNamed(context, '/report');
      }
      if (choice == "تسجيل الخروج") {
        // Navigator.pushNamed(context, '/logout');
      }
      if (choice == "الاعدادات") {
        // Navigator.pushNamed(context, '/settings');
      }
    }

    Widget more() {
      return PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Container(
                height: _dimensions.heightPercent(6),
                child: Text(
                  choice,
                  style: _textStyles.popupMenuButtonStyle(),
                ),
              ),
            );
          }).toList();
        },
        onSelected: (choice) {
          onSelected(choice);
        },
        icon: Icon(Icons.more_vert_rounded, size: _dimensions.widthPercent(4)),
      );
    }

    appBar() {
      return Column(
        children: [
          SizedBox(height: _dimensions.heightPercent(2)),
          Row(
            children: <Widget>[
              SizedBox(width: _dimensions.widthPercent(1)),
              Container(
                  height: _dimensions.heightPercent(15),
                  width: _dimensions.widthPercent(15),
                  child: addPhoto()),
              SizedBox(width: _dimensions.widthPercent(1)),
              Text(
                "عمر خالد",
                style: _textStyles.profileNameTitleStyle(),
              ),
              Expanded(child: SizedBox()),
              // Text(
              //   "model.total[0].cash",
              //   style: _textStyles.appBarCalculationsStyle(),
              // ),
              StreamBuilder<QuerySnapshot>(
                stream: totalModel.fetchTotalStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("Loading");
                  }
                  totalModel.fetchTotal();
                  return Text(
                    snapshot.data.docs.map((DocumentSnapshot document) {
                      return document.data()['cash'];
                    }).toString(),
                    style: _textStyles.profileNameTitleStyle(),
                  );
                },
              ),
              SizedBox(width: _dimensions.widthPercent(2)),
              Text(
                ':الخزينه',
                style: _textStyles.profileNameTitleStyle(),
              ),
              SizedBox(width: _dimensions.widthPercent(2)),
              more(),
              SizedBox(width: _dimensions.widthPercent(2)),
            ],
          ),
          SizedBox(height: _dimensions.heightPercent(1)),
        ],
      );
    }

    Widget transactionTypeSwitcher() {
      return Row(
        children: [
          SizedBox(width: _dimensions.widthPercent(1)),
          Container(
            width: _dimensions.widthPercent(6),
            padding: EdgeInsets.only(left: _dimensions.heightPercent(2)),
            child: Transform.scale(
              scale: 1.5,
              child: Switch(
                value: switcherOpen,
                onChanged: (_) {
                  homeServices.changeSwitchSide();
                  productModel.cleanProductSelection();
                  billServices.totalBill = 0;
                },
              ),
            ),
          ),
          SizedBox(width: _dimensions.widthPercent(1)),
          Text(
            transactionType,
            style: _textStyles.appBarTextStyle(),
          ),
        ],
      );
    }

    return StreamBuilder(
      stream: productModel.fetchProductStream("بيفرلي"),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Product> liveProducts = snapshot.data.docs
            .map<Product>((DocumentSnapshot document) =>
                Product.fromMap(document.data(), document.id))
            .toList();
        // List <Product> selectedList = productModel.getSelectedProducts(products);

        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              collapsedHeight: _dimensions.heightPercent(32.25),
              // expandedHeight: _dimensions.heightPercent(30),
              flexibleSpace: FlexibleSpaceBar(
                  title: Column(
                children: [
                  appBar(),
                  SizedBox(height: _dimensions.heightPercent(1)),
                  transactionTypeSwitcher(),
                  Container(
                    height: _dimensions.heightPercent(7),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _buildCategoryList(),
                    ),
                  ),
                ],
              )),
              floating: true,
              pinned: true,
            ),
            SliverGrid(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return products.isEmpty
                      ? Center(child: Text('لا يوجد منتجات هنا'))
                      : Padding(
                          padding: EdgeInsets.only(
                              left: _dimensions.widthPercent(1),
                              top: _dimensions.heightPercent(3),
                              right: _dimensions.widthPercent(1)),
                          child: double.parse(liveProducts
                                          .firstWhere((element) =>
                                              element.id == products[index].id)
                                          .netTotalQuantity) <=
                                      0 ||
                                  double.parse(liveProducts
                                          .firstWhere((element) =>
                                              element.id == products[index].id)
                                          .netTotalQuantity) ==
                                      null
                              ? _generalItem.customCard(
                                  selectionNo: 0,
                                  networkImage:
                                      "https://i.ytimg.com/vi/ANRZ_ZRHJEw/hqdefault.jpg",
                                  title: products[index].name,
                                  backGround: Colors.grey)
                              : _generalItem.customCard(
                                  backGround: Colors.blue,
                                  onTapDownItem: (_) {},
                                  onTapDownIcon: (_) {
                                    print('down');
                                    timer = Timer.periodic(
                                        Duration(milliseconds: 200), (_) {
                                      if (products[index].selectionNo > 0) {
                                        productModel.removeProductSelectionById(
                                            products[index].id);
                                      }
                                      if (homeServices.transactionType ==
                                          "بيع") {
                                        productModel
                                            .calculateTheTotalPerProduct(
                                                billServices.selectedBuyerType);
                                        billServices.calculateTheTotalBill(
                                            selectedList);
                                        billServices.calculateChange();
                                        if (billServices.selectedBuyerType ==
                                            "House") {
                                          billServices
                                              .calculateOnlyForHouseType();
                                        }
                                      }

                                      if (homeServices.transactionType ==
                                          "شراء") {
                                        print("yes شراء");
                                        billServices.calculateTheTotalBill(
                                            selectedList);
                                        billServices
                                            .calculateOnlyForHouseType();
                                      }
                                    });
                                  },
                                  onPressItem: () {
                                    if (double.parse(liveProducts
                                                .firstWhere((element) =>
                                                    element.id ==
                                                    products[index].id)
                                                .netTotalQuantity) <
                                            0 ||
                                        products[index].selectionNo >=
                                            double.parse(liveProducts
                                                .firstWhere((element) =>
                                                    element.id ==
                                                    products[index].id)
                                                .netTotalQuantity)) {
                                      print('product needed');
                                    }

                                    if (double.parse(liveProducts
                                                .firstWhere((element) =>
                                                    element.id ==
                                                    products[index].id)
                                                .netTotalQuantity) >
                                            0 &&
                                        products[index].selectionNo <
                                            double.parse(liveProducts
                                                .firstWhere((element) =>
                                                    element.id ==
                                                    products[index].id)
                                                .netTotalQuantity)) {
                                      productModel.addProductSelectionById(
                                          products[index].id);
                                    }

                                    if (homeServices.transactionType == "بيع") {
                                      productModel.calculateTheTotalPerProduct(
                                          billServices.selectedBuyerType);
                                      billServices
                                          .calculateTheTotalBill(selectedList);
                                      billServices.calculateChange();
                                      if (billServices.selectedBuyerType ==
                                          "House") {
                                        billServices
                                            .calculateOnlyForHouseType();
                                      }
                                    }

                                    if (homeServices.transactionType ==
                                        "شراء") {
                                      print("yes شراء");
                                      billServices
                                          .calculateTheTotalBill(selectedList);
                                      billServices.calculateOnlyForHouseType();
                                    }
                                  },
                                  onPressIcon: () {
                                    if (products[index].selectionNo > 0) {
                                      productModel.removeProductSelectionById(
                                          products[index].id);
                                    }
                                    if (homeServices.transactionType == "بيع") {
                                      productModel.calculateTheTotalPerProduct(
                                          billServices.selectedBuyerType);
                                      billServices
                                          .calculateTheTotalBill(selectedList);
                                      billServices.calculateChange();
                                      if (billServices.selectedBuyerType ==
                                          "House") {
                                        billServices
                                            .calculateOnlyForHouseType();
                                      }
                                      // calculateTheTotalBillPerProduct();
                                      // calculateTheTotalBill();
                                    }

                                    if (homeServices.transactionType ==
                                        "شراء") {
                                      print("yes شراء");
                                      billServices
                                          .calculateTheTotalBill(selectedList);
                                      billServices.calculateOnlyForHouseType();
                                    }
                                  },
                                  onTapUpIcon: (_) {
                                    print('cancel');
                                    timer.cancel();
                                  },
                                  onTapCancelIcon: () {
                                    print('cancel');
                                    timer.cancel();
                                  },
                                  selectionNo: products[index].selectionNo,
                                  statistics: products[index].selectionNo > 0
                                      ? products[index].selectionNo.toString()
                                      : "",
                                  topSpace: SizedBox(
                                    height: _dimensions.heightPercent(9),
                                  ),
                                  betweenSpace: SizedBox(
                                      height: _dimensions.heightPercent(3)),
                                  title: products[index].name,
                                  assetImage: null,
                                  networkImage:
                                      "https://cdn.mos.cms.futurecdn.net/42E9as7NaTaAi4A6JcuFwG-1200-80.jpg",
                                ),
                        );
                },
                childCount: productModel.filterProduct(selectedCategory).length,
              ),
            ),
          ],
        );
      },
    );
  }
}
