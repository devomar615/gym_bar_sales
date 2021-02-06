import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/category.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:gym_bar_sales/ui/widgets/products_grid.dart';
import 'package:provider/provider.dart';

File file;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyles _textStyles = TextStyles(context: context);
    FormWidget _formWidget = FormWidget(context: context);
    Dimensions _dimensions = Dimensions(context);

    CategoryModel categoryModel = Provider.of<CategoryModel>(context);
    String selectedCategory = categoryModel.selectedCategory;
    List<Category> categories = categoryModel.categories;

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
                  Navigator.pushNamed(
                    context,
                    '/more',
                  );
                },
              ),
              SizedBox(width: _dimensions.widthPercent(2)),
            ],
          ),
          SizedBox(height: _dimensions.heightPercent(1)),
        ],
      );
    }

    return Container(
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
          ProductsGrid(),
        ],
      ),
    );
  }
}
