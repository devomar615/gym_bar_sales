//import 'package:flutter/material.dart';
//import 'package:gym_bar_sales/core/models/product.dart';
//import 'package:gym_bar_sales/ui/shared/text_styles.dart';
//import 'package:gym_bar_sales/ui/views/Add/add_bill.dart';
//
//class SlidingUpPanelWidget extends StatelessWidget {
//  final List<Product> billProducts;
//  final Function onRemove;
//  final Function onAdd;
//
//  SlidingUpPanelWidget({this.billProducts, this.onRemove, this.onAdd});
//
//  tableHead() {
//    return Container(
//      height: 70,
//      color: Colors.blue,
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceAround,
//        children: <Widget>[
//          Center(
//              child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text("سعر القطعه", style: tableTitleStyle),
//              SizedBox(width: 10),
//            ],
//          )),
//          Center(
//              child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text("العدد", style: tableTitleStyle),
//              SizedBox(width: 10),
//            ],
//          )),
//          Center(
//              child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text("اسم المنتج", style: tableTitleStyle),
//              SizedBox(width: 10),
//            ],
//          )),
//        ],
//      ),
//    );
//  }
//
//  Widget buildBill({text}) {
//    return Container(
//      child: Text(text, style: tableContentStyle),
//      constraints: BoxConstraints(
//        maxWidth: 200.0,
//        minWidth: 200,
//      ),
//    );
//  }
//
//  tableBuilder() {
//    return ListView.builder(
//        itemCount: billProducts.length,
//        itemBuilder: (BuildContext context, int index) {
//          return Column(
//            children: <Widget>[
//              Container(
//                constraints: BoxConstraints(
//                  minHeight: 50.0,
//                  maxHeight: 200,
//                ),
//                child: Row(
////                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  children: <Widget>[
//                    SizedBox(width: 200),
//                    Container(
//                      child: Text(billProducts[index].customerPrice,
//                          style: tableContentStyle),
//                      constraints: BoxConstraints(
//                        maxWidth: 100.0,
//                        minWidth: 100,
//                      ),
//                    ),
//                    SizedBox(width: 200),
//                    Row(
//                      children: [
//                        Container(
//                          constraints: BoxConstraints(
//                            maxWidth: 100.0,
//                            minWidth: 100,
//                          ),
//                          child: IconButton(
//                              iconSize: 50,
//                              icon: Icon(Icons.remove_circle),
//                              onPressed: () => AddBillState().onRemove(index)),
//                        ),
//                        SizedBox(width: 50),
//                        Container(
//                          constraints: BoxConstraints(
//                            maxWidth: 100.0,
//                            minWidth: 50,
//                          ),
//                          child: Text(
//                              billProducts[index].selectionNo.toString(),
//                              style: tableContentStyle),
//                        ),
//                        SizedBox(width: 10),
//                        Container(
//                          constraints: BoxConstraints(
//                            maxWidth: 100.0,
//                            minWidth: 100,
//                          ),
//                          child: IconButton(
//                              iconSize: 50,
//                              icon: Icon(Icons.add_circle),
//                              onPressed: () => onAdd),
//                        ),
//                        SizedBox(width: 180),
//                      ],
//                    ),
//
//                    //todo: change customerPrice to the selected one in the slidingUpPanel.
//                    Container(
//                        constraints: BoxConstraints(
//                          maxWidth: 100.0,
//                          minWidth: 100,
//                        ),
//                        child: Text(billProducts[index].name,
//                            style: tableContentStyle))
//                  ],
//                ),
//              ),
//              Divider(height: 1, color: Colors.black),
//              Divider(height: 1, color: Colors.black),
//            ],
//          );
//        });
//  }
//
//  table() {
//    return Column(
//      children: <Widget>[
//        tableHead(),
//        Expanded(child: tableBuilder()),
//      ],
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: [
//        SizedBox(
//          height: 20,
//        ),
//        Text(
//          "الفاتوره",
//          style: headerStyle,
//        ),
//        Expanded(
//          child: table(),
//        ),
//        Text("data"),
//        Text("data"),
//        Text("data"),
//      ],
//    );
//  }
//}
