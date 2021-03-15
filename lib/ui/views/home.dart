import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/ui/widgets/home/home_app_bar.dart';
import 'package:gym_bar_sales/ui/widgets/home/home_products_grid.dart';
import 'package:provider/provider.dart';
import 'package:gym_bar_sales/core/models/product.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CategoryModel categoryModel = Provider.of<CategoryModel>(context);
    ProductModel productModel = Provider.of<ProductModel>(context);

    return categoryModel.status == Status.Busy
        ? Center(child: CircularProgressIndicator())
        : Container(
            color: Colors.transparent,
            child: Column(
              children: [
                HomeAppBar(),
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
                          .map<Product>((DocumentSnapshot document) =>
                              Product.fromMap(document.data(), document.id))
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
