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

Timer timer;

class ProductsGrid extends StatelessWidget {
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

    return productModel.status == Status.Busy
        ? Center(child: CircularProgressIndicator())
        : SliverGrid(
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
                        child: double.parse(products[index].netTotalQuantity) <=
                                    0 ||
                                double.parse(
                                        products[index].netTotalQuantity) ==
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
                                  });
                                },
                                onPressItem: () {
                                  if (double.parse(products[index]
                                              .netTotalQuantity) <
                                          0 ||
                                      products[index].selectionNo >=
                                          double.parse(products[index]
                                              .netTotalQuantity)) {
                                    print('product needed');
                                  }

                                  if (double.parse(products[index]
                                              .netTotalQuantity) >
                                          0 &&
                                      products[index].selectionNo <
                                          double.parse(products[index]
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
                                      billServices.calculateOnlyForHouseType();
                                    }
                                  }

                                  if (homeServices.transactionType == "شراء") {
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
                                      billServices.calculateOnlyForHouseType();
                                    }
                                    // calculateTheTotalBillPerProduct();
                                    // calculateTheTotalBill();
                                  }

                                  if (homeServices.transactionType == "شراء") {
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
          );
  }
}
