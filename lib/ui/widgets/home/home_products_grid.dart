import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/services/bill_services.dart';
import 'package:gym_bar_sales/core/services/home_services.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/widgets/general_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Timer timer;

class ProductsGrid extends StatelessWidget {
  final liveProducts;

  const ProductsGrid({Key key, this.liveProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GeneralItem _generalItem = GeneralItem(context: context);
    Dimensions _dimensions = Dimensions(context);

    CategoryModel categoryModel = Provider.of<CategoryModel>(context);
    ProductModel productModel = Provider.of<ProductModel>(context);
    BillServices billServices = Provider.of<BillServices>(context);
    HomeServices homeServices = Provider.of<HomeServices>(context);

    String selectedCategory = categoryModel.selectedCategory;
    List<Product> products = productModel.filterProduct(selectedCategory);
    List<Product> selectedList = productModel.getSelectedProducts();

    bool switcherOpen = homeServices.switcherOpen;

    onMinusItem(index) {
      if (products[index].selectionNo > 0) {
        productModel.removeProductSelectionById(products[index].id);
      }
      if (homeServices.transactionType == "بيع") {
        productModel.calculateTheTotalPerProduct(billServices.selectedBuyerType);
        billServices.calculateTheTotalBill(selectedList);
        billServices.calculateChange();
        if (billServices.selectedBuyerType == "House") {
          billServices.calculateOnlyForHouseType();
        }
        // calculateTheTotalBillPerProduct();
        // calculateTheTotalBill();
      }

      if (homeServices.transactionType == "شراء") {
        print("yes شراء");
        billServices.calculateTheTotalBill(selectedList);
        billServices.calculateOnlyForHouseType();
      }
    }

    onPlusItem(index) {
      if (double.parse(liveProducts
                  .firstWhere((element) => element.id == products[index].id)
                  .netTotalQuantity) <
              0 ||
          products[index].selectionNo >=
              double.parse(liveProducts
                  .firstWhere((element) => element.id == products[index].id)
                  .netTotalQuantity)) {
        print('product needed');
      }

      if (!switcherOpen) {
        productModel.addProductSelectionById(products[index].id);
      }

      if (double.parse(liveProducts
                  .firstWhere((element) => element.id == products[index].id)
                  .netTotalQuantity) >
              0 &&
          products[index].selectionNo <
              double.parse(liveProducts
                  .firstWhere((element) => element.id == products[index].id)
                  .netTotalQuantity) &&
          switcherOpen) {
        productModel.addProductSelectionById(products[index].id);
      }

      if (homeServices.transactionType == "بيع") {
        productModel.calculateTheTotalPerProduct(billServices.selectedBuyerType);
        billServices.calculateTheTotalBill(selectedList);
        billServices.calculateChange();
        if (billServices.selectedBuyerType == "House") {
          billServices.calculateOnlyForHouseType();
        }
      }

      if (homeServices.transactionType == "شراء") {
        print("yes شراء");
        billServices.calculateTheTotalBill(selectedList);
        billServices.calculateOnlyForHouseType();
      }
    }

    Widget showGeneralCard(index) {
      if (double.parse(liveProducts
                  .firstWhere((element) => element.id == products[index].id)
                  .netTotalQuantity) <=
              0 ||
          double.parse(liveProducts
                  .firstWhere((element) => element.id == products[index].id)
                  .netTotalQuantity) ==
              null) {
        if (switcherOpen) {
          return _generalItem.customCard(
              topSpace: SizedBox(height: _dimensions.heightPercent(9)),
              betweenSpace: SizedBox(height: _dimensions.heightPercent(2)),
              selectionNo: 0,
              backGround: Colors.blue,
              assetImage: "assets/images/products.jpg",
              title: products[index].name,
              // backGround: Colors.grey,
              networkImage: '');
        }
      }
      return _generalItem.customCard(
        backGround: Colors.black,
        onPressItem: () {
          onPlusItem(index);
        },
        onPressIcon: () {
          onMinusItem(index);
        },
        selectionNo: products[index].selectionNo,
        statistics: products[index].selectionNo > 0 ? products[index].selectionNo.toString() : "",
        topSpace: SizedBox(height: _dimensions.heightPercent(9)),
        betweenSpace: SizedBox(height: _dimensions.heightPercent(2)),
        title: products[index].name,
        assetImage: "assets/images/products.jpg",
        networkImage: '',
      );
    }

    return Container(
      height: _dimensions.heightPercent(57),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: _dimensions.widthPercent(kIsWeb ? 1 : 0),
                  right: _dimensions.widthPercent(1)),
              child: GridView.builder(
                itemCount: productModel.filterProduct(selectedCategory).length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: kIsWeb ? 6 : 5),
                itemBuilder: (BuildContext context, int index) {
                  return products.isEmpty
                      ? Center(child: Text('لا يوجد منتجات هنا'))
                      : Padding(
                          padding: EdgeInsets.only(
                            left: _dimensions.widthPercent(1),
                            bottom: _dimensions.widthPercent(1),
                          ),
                          child: showGeneralCard(index),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
