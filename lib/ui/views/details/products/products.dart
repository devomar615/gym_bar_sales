import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/ui/widgets/home_item.dart';
import '../../base_view.dart';

class Products extends StatelessWidget {
  final List<String> args;

  Products({this.args});

  @override
  Widget build(BuildContext context) {
    return BaseView<ProductModel>(
      onModelReady: (model) =>
          model.fetchProducts(branchName: args[0], categoryName: args[1]),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("أختر نوع المنتج"),
        ),
        body: model.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(6),
                child: GridView.builder(
                  itemCount: model.products.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6),
                  itemBuilder: (BuildContext context, int index) {
                    return item(
                      topSpace: SizedBox(height: 50),
                      betweenSpace: SizedBox(height: 20),
                      title: model.products[index].name,
                      statistics: "${model.products[index].netTotalQuantity}"
                          "${model.products[index].unit} ",
                      assetImage: "",
                      backGround: Colors.lightBlue,
                      onPress: () {
                        Map productDetails = {
                          "name": model.products[index].name,
                          "category": model.products[index].category,
                          "description": model.products[index].description,
                          "netTotalQuantity":
                              model.products[index].netTotalQuantity,
                          "branch": model.products[index].branch,
                          "customerPrice": model.products[index].customerPrice,
                          "employeePrice": model.products[index].employeePrice,
                          "housePrice": model.products[index].housePrice,
                          "quantityOfWholesaleUnit":
                              model.products[index].quantityOfWholesaleUnit,
                          "wholesaleQuantity":
                              model.products[index].wholesaleQuantity,
                          "quantityLimit": model.products[index].quantityLimit,
                          "wholesaleUnit": model.products[index].wholesaleUnit,
                          "unit": model.products[index].unit,
                          "supplierName": model.products[index].supplierName,
                          "photo": model.products[index].photo,
                          "id": model.products[index].id,
                        };
                        print("my dataaaaaa is  quantityOfWholesaleUnit " +productDetails["quantityOfWholesaleUnit"]);
                        print("my dataaaaaa is  netTotalQuantity " +productDetails["netTotalQuantity"]);
                        print("my dataaaaaa is  branch " +productDetails["branch"]);
                        print("my dataaaaaa is  quantityOfWholesaleUnit " +productDetails["quantityOfWholesaleUnit"]);

                        Navigator.pushNamed(context, '/TransactionView',
                            arguments: productDetails);
                      },
                    );
                  },
                ),
              ),
      ),
    );
  }
}
