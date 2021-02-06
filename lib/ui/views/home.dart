import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/category.dart';
import 'package:gym_bar_sales/core/services/home_services.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:gym_bar_sales/ui/widgets/products_grid.dart';
import 'package:provider/provider.dart';

File file;
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
    HomeServices homeServices = Provider.of<HomeServices>(context);
    String selectedCategory = categoryModel.selectedCategory;
    List<Category> categories = categoryModel.categories;
    String transactionType = homeServices.transactionType;
    bool switcherOpen = homeServices.switcherOpen;

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
        Navigator.pushNamed(context, '/report');
      }
      if (choice == "تسجيل الخروج") {
        Navigator.pushNamed(context, '/logout');
      }
      if (choice == "الاعدادات") {
        Navigator.pushNamed(context, '/settings');
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
              more(),
              // IconButton(
              //   icon: Icon(Icons.menu),
              //   iconSize: _dimensions.widthPercent(4),
              //   onPressed: () {
              //     Navigator.pushNamed(
              //       context,
              //       '/more',
              //     );
              //   },
              // ),
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
                  },
                )),
          ),
          SizedBox(width: _dimensions.widthPercent(1)),
          Text(
            transactionType,
            style: _textStyles.appBarTextStyle(),
          ),
        ],
      );
    }

    return Container(
      child: CustomScrollView(
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
          // SliverList(
          //     delegate: SliverChildListDelegate(
          //   [
          //     appBar(),
          //     Row(
          //       children: [
          //         Container(
          //             width: _dimensions.widthPercent(6),
          //             padding:
          //                 EdgeInsets.only(left: _dimensions.heightPercent(2)),
          //             child: Switch(value: true, onChanged: null)),
          //         Text("بيع"),
          //       ],
          //     ),
          //   ],
          // )),
          // SliverToBoxAdapter(
          //   child: Container(
          //     height: _dimensions.heightPercent(10),
          //     child: ListView(
          //       scrollDirection: Axis.horizontal,
          //       children: _buildCategoryList(),
          //     ),
          //   ),
          // ),
          ProductsGrid(),
        ],
      ),
    );
  }
}
