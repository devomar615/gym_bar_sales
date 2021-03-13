import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/category.dart';
import 'package:gym_bar_sales/core/services/bill_services.dart';
import 'package:gym_bar_sales/core/services/home_services.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/core/view_models/total_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/views/more/clients.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:gym_bar_sales/ui/widgets/products_grid.dart';
import 'package:provider/provider.dart';
import 'package:gym_bar_sales/core/models/product.dart';

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
    CategoryModel categoryModel = Provider.of<CategoryModel>(context);
    ProductModel productModel = Provider.of<ProductModel>(context);
    TotalModel totalModel = Provider.of<TotalModel>(context, listen: false);
    HomeServices homeServices = Provider.of<HomeServices>(context);
    BillServices billServices = Provider.of<BillServices>(context);
    String selectedCategory = categoryModel.selectedCategory;
    List<Category> categories = categoryModel.categories;
    String transactionType = homeServices.transactionType;
    bool switcherOpen = homeServices.switcherOpen;

    Widget addPhoto() {
      if (file == null) {
        return _formWidget.logo(
            imageContent: Image.asset("assets/images/myprofile.jpg", fit: BoxFit.cover), backgroundColor: Colors.white);
      } else
        return _formWidget.logo(imageContent: Image.file(file, fit: BoxFit.cover));
    }

    _buildCategoryList() {
      List<Widget> choices = [];
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
        child: Icon(Icons.more_vert_rounded, size: _dimensions.widthPercent(4)),
      );
    }

    appBar() {
      return Column(
        children: [
          SizedBox(height: _dimensions.heightPercent(2)),
          Row(
            children: <Widget>[
              SizedBox(width: _dimensions.widthPercent(1)),
              Container(height: _dimensions.heightPercent(15), width: _dimensions.widthPercent(15), child: addPhoto()),
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
              StreamBuilder<DocumentSnapshot>(
                stream: totalModel.fetchTotalStream(branch),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {}
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data['cash'],
                      style: _textStyles.profileNameTitleStyle(),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              SizedBox(width: _dimensions.widthPercent(2)),
              Text(
                ':الخزنه',
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

    return categoryModel.status == Status.Busy
        ? Center(child: CircularProgressIndicator())
        : Container(
            color: Colors.transparent,
            child: Column(
              children: [
                appBar(),
                transactionTypeSwitcher(),
                Container(
                  height: _dimensions.heightPercent(7),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _buildCategoryList(),
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: productModel.fetchProductStream("بيفرلي"),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {}
                    List<Product> liveProducts;

                    if (snapshot.hasData) {
                      liveProducts = snapshot.data.docs
                          .map<Product>((DocumentSnapshot document) => Product.fromMap(document.data(), document.id))
                          .toList();
                    }

                    return snapshot.hasData
                        ? ProductsGrid(liveProducts: liveProducts)
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ],
            ),
          );
  }
}
