import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';

class SlidingUpPanelWidget extends StatelessWidget {
  final List<Product> billProducts;

  SlidingUpPanelWidget({this.billProducts});

  tableHead() {
    return Container(
      height: 50,
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("اسم المنتج", style: tableTitleStyle),
              SizedBox(width: 10),
            ],
          )),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("العدد", style: tableTitleStyle),
              SizedBox(width: 10),
            ],
          )),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("سعر القطعه", style: tableTitleStyle),
              SizedBox(width: 10),
            ],
          )),
        ],
      ),
    );
  }

  tableBuilder() {
    return ListView.builder(
        itemCount: billProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(billProducts[index].name, style: formTitleStyleLight),
                    Text(billProducts[index].selectionNo.toString(),
                        style: formTitleStyleLight),
                    //todo: change customerPrice to the selected one in the slidingUpPanel.
                    Text(billProducts[index].customerPrice,
                        style: formTitleStyleLight),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.black),
            ],
          );
        });
  }

  table() {
    return Column(
      children: <Widget>[
        tableHead(),
        Divider(
          thickness: 3,
          color: Colors.black54,
          height: 3,
        ),
        Expanded(child: tableBuilder()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("data"),
        Text("data"),
        Text("data"),
        Text("data"),
        Expanded(
          child: table(),
        ),
        Text("data"),
        Text("data"),
        Text("data"),
        Text("data"),
      ],
    );
  }
}
