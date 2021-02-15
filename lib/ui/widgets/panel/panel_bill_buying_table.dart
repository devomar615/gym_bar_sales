import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/services/bill_services.dart';
import 'package:gym_bar_sales/core/services/home_services.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:provider/provider.dart';

Timer timer;

class PanelBillBuyingTable extends StatelessWidget {
  final panelController;

  PanelBillBuyingTable({this.panelController});

  @override
  Widget build(BuildContext context) {
    TextStyles _textStyles = TextStyles(context: context);
    Dimensions _dimensions = Dimensions(context);
    FormWidget _formWidget = FormWidget(context: context);

    var productModel = Provider.of<ProductModel>(context);

    var billServices = Provider.of<BillServices>(context);

    var homeServices = Provider.of<HomeServices>(context);

    List<Product> selectedList = productModel.getSelectedProducts();

    onMinusProduct(index) {
      productModel.removeProductSelectionById(selectedList[index].id);

      billServices.calculateTheTotalBill(selectedList);
      billServices.calculateOnlyForHouseType();

      print(selectedList.length);
    }

    _autoClosePanel() {
      if (productModel.isThereSelectedProduct()) {
        print(selectedList.length);
        FocusScope.of(context).unfocus();
        panelController.close();
      }
    }

    onPlusProduct(index) {
      if (selectedList[index].selectionNo >=
          double.parse(selectedList[index].netTotalQuantity)) {
        if (homeServices.switcherOpen) {
          print("product needed");
        }
      }

      if (double.parse(selectedList[index].netTotalQuantity) > 0 &&
          selectedList[index].selectionNo <
              double.parse(selectedList[index].netTotalQuantity)) {
        productModel.addProductSelectionById(selectedList[index].id);

        billServices.calculateTheTotalBill(selectedList);
        billServices.calculateOnlyForHouseType();
      }
      if (!homeServices.switcherOpen) {
        productModel.addProductSelectionById(selectedList[index].id);
        billServices.calculateTheTotalBill(selectedList);
        billServices.calculateOnlyForHouseType();
      }
    }

    cancelTimer() {
      print('cancel');
      timer.cancel();
    }

    tableHead() {
      return Container(
        height: _dimensions.heightPercent(6),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("المبلغ المدفوع",
                    style: _textStyles.billTableTitleStyle()),
                SizedBox(width: _dimensions.widthPercent(2)),
              ],
            )),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("العدد", style: _textStyles.billTableTitleStyle()),
                SizedBox(width: _dimensions.widthPercent(2)),
              ],
            )),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("اسم المنتج", style: _textStyles.billTableTitleStyle()),
                SizedBox(width: _dimensions.widthPercent(2)),
              ],
            )),
          ],
        ),
      );
    }

    billTableBuilder() {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: selectedList.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                    minHeight: _dimensions.heightPercent(5),
                    maxHeight: _dimensions.heightPercent(15),
                  ),
                  child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(width: _dimensions.widthPercent(14.5)),
                      Container(
                        child: _formWidget.formTextFieldTemplate(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            keyboardType: TextInputType.number,
                            onChanged: (String value) {
                              if (value.length == 0) {
                                value = "0";
                              }
                              print(value);
                              productModel.addTheTotalBuyingPerProduct(
                                  changingValue: double.parse(value),
                                  productId: selectedList[index].id);

                              billServices.calculateTheTotalBill(selectedList);
                              billServices.calculateOnlyForHouseType();
                            }),
                        constraints: BoxConstraints(
                          maxWidth: _dimensions.widthPercent(7.5),
                          minWidth: _dimensions.widthPercent(7.5),
                        ),
                      ),
                      SizedBox(width: _dimensions.widthPercent(17.5)),
                      //todo: ممكن نضيف هنا اذا كانت عملية الشراء جمله يعني علبه مثلا او مش جمله
                      //todo: ممكن نضيف هنا اذا كانت عملية الشراء جمله يعني علبه مثلا او مش جمله
                      //todo: ممكن نضيف هنا اذا كانت عملية الشراء جمله يعني علبه مثلا او مش جمله
                      Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: _dimensions.widthPercent(7.5),
                              minWidth: _dimensions.widthPercent(7.5),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                onMinusProduct(index);
                                _autoClosePanel();
                              },
                              onTapDown: (TapDownDetails details) {
                                timer = Timer.periodic(
                                    Duration(milliseconds: 200),
                                    (t) => onMinusProduct(index));
                                _autoClosePanel();
                              },
                              onTapUp: (TapUpDetails details) => cancelTimer(),
                              onTapCancel: () => cancelTimer(),
                              child: Icon(Icons.remove_circle,
                                  color: Colors.red,
                                  size: _dimensions.widthPercent(3.5)),
                            ),
                          ),
                          SizedBox(width: _dimensions.widthPercent(3)),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: _dimensions.widthPercent(3),
                              minWidth: _dimensions.widthPercent(3),
                            ),
                            child: Text(
                                selectedList[index]
                                    .selectionNo
                                    .toInt()
                                    .toString(),
                                style: _textStyles.billTableContentStyle()),
                          ),
                          SizedBox(width: _dimensions.widthPercent(2)),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: _dimensions.widthPercent(7.5),
                              minWidth: _dimensions.widthPercent(7.5),
                            ),
                            child: IconButton(
                                color: Colors.green,
                                iconSize: _dimensions.widthPercent(3.5),
                                icon: Icon(Icons.add_circle),
                                onPressed: () => onPlusProduct(index)),
                          ),
                          SizedBox(width: _dimensions.widthPercent(15.5)),
                        ],
                      ),
                      Container(
                          constraints: BoxConstraints(
                            maxWidth: _dimensions.widthPercent(15),
                            minWidth: _dimensions.widthPercent(7.5),
                          ),
                          child: Text(selectedList[index].name,
                              style: _textStyles.billTableContentStyle()))
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.black),
                Divider(height: 1, color: Colors.black),
              ],
            );
          });
    }

    return Column(
      children: <Widget>[
        tableHead(),
        billTableBuilder(),
      ],
    );
  }
}
