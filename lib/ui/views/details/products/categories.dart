import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/ui/views/base_view.dart';
import 'package:gym_bar_sales/ui/widgets/home_item.dart';

class Categories extends StatelessWidget {
  final String branchName;

  Categories({this.branchName});

  static List<String> args = List(2);

  @override
  Widget build(BuildContext context) {
    return BaseView<CategoryModel>(
      onModelReady: (model) => model.fetchCategories(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("أختر نوع المنتج"),
        ),
        body: model.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(6),
                child: GridView.builder(
                  itemCount: model.categories.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6),
                  itemBuilder: (BuildContext context, int index) {
                    return item(
                      title: model.categories[index].name,
                      assetImage: "",
                      backGround: Colors.lightBlue,
                      onPress: () {
                        args = [branchName, model.categories[index].name];
                        Navigator.pushNamed(context, "/products",
                            arguments: args);
                      },
                    );
                  },
                ),
              ),
      ),
    );
  }
}
