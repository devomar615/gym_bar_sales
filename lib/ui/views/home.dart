import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/category.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:gym_bar_sales/ui/widgets/general_item.dart';
import 'package:provider/provider.dart';

String branch = "بيفرلي";
Timer timer;
File file;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyles _textStyles = TextStyles(context: context);
    GeneralItem _generalItem = GeneralItem(context: context);
    FormWidget _formWidget = FormWidget(context: context);
    Dimensions _dimensions = Dimensions(context);

    CategoryModel categoryModel = Provider.of<CategoryModel>(context);
    ProductModel productModel = Provider.of<ProductModel>(context);

    String selectedCategory = categoryModel.selectedCategory;
    List<Category> categories = categoryModel.categories;
    List<Product> products = productModel.filterProduct(selectedCategory);

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

    appBar() {
      return Column(
        children: [
          SizedBox(height: _dimensions.heightPercent(4)),
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
              //   style:
              //       _textStyles.appBarCalculationsStyle(1.0),
              // ),
              // SizedBox(width: _dimensions.widthPercent(2)),
              // Text(
              //   ':الخزينه',
              //   style:
              //       _textStyles.appBarCalculationsStyle(1.0),
              // ),
              SizedBox(width: _dimensions.widthPercent(2)),
              IconButton(
                icon: Icon(Icons.menu),
                iconSize: _dimensions.widthPercent(4),
                onPressed: () {
                  Navigator.pushNamed(context, '/more',);
                },
              ),
              SizedBox(width: _dimensions.widthPercent(2)),
            ],
          ),
          SizedBox(height: _dimensions.heightPercent(1)),
        ],
      );
    }

    sliver() {
      return SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return products.isEmpty
              ? Center(child: Text('لا يوجد منتجات هنا'))
              : Padding(
                  padding: EdgeInsets.only(
                      left: _dimensions.widthPercent(1),
                      top: _dimensions.heightPercent(3),
                      right: _dimensions.widthPercent(1)),
                  child: double.parse(products[index].netTotalQuantity) <= 0
                      ? _generalItem.item(
                          selectionNo: null,
                          networkImage:
                              "https://cdn.mos.cms.futurecdn.net/42E9as7NaTaAi4A6JcuFwG-1200-80.jpg",
                          title: products[index].name,
                          backGround: Colors.grey)
                      : _generalItem.item(
                          backGround: Colors.blue,
                          onTapDownItem: (_) {},
                          onTapDownIcon: (_) {
                            print('down');
                            timer = Timer.periodic(Duration(milliseconds: 200),
                                (_) {
                              if (products[index].selectionNo > 0) {
                                productModel.removeProductSelectionById(
                                    products[index].id);
                              }
                              // calculateTheTotalBillPerProduct();
                              // calculateTheTotalBill();
                              // if (selectedBuyerType == "House") {
                              //   calculateOnlyForHouseType();
                              // }
                            });
                          },
                          onPressItem: () {
                            if (double.parse(products[index].netTotalQuantity) <
                                    0 ||
                                products[index].selectionNo >=
                                    double.parse(
                                        products[index].netTotalQuantity)) {
                              print('product needed');
                            }

                            if (double.parse(products[index].netTotalQuantity) >
                                    0 &&
                                products[index].selectionNo <
                                    double.parse(
                                        products[index].netTotalQuantity)) {
                              productModel
                                  .addProductSelectionById(products[index].id);
                            }
                          },
                          onPressIcon: () {
                            if (products[index].selectionNo > 0) {
                              productModel.removeProductSelectionById(
                                  products[index].id);
                            }
                            // calculateTheTotalBillPerProduct();
                            // calculateTheTotalBill();
                            // if (selectedBuyerType == "House") {
                            //   calculateOnlyForHouseType();
                            // }
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
                            height: _dimensions.heightPercent(3),
                          ),
                          title: products[index].name,
                          assetImage: null,
                          networkImage:
                              "https://cdn.mos.cms.futurecdn.net/42E9as7NaTaAi4A6JcuFwG-1200-80.jpg",
                        ),
                );
        },
        childCount: products.length,
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate(
              [appBar()],
            )),
            SliverToBoxAdapter(
              child: Container(
                height: _dimensions.heightPercent(10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _buildCategoryList(),
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              delegate: sliver(),
            )
          ],
        ),
      ),
    );
  }
}
