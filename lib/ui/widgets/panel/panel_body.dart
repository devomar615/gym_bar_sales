import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/models/employee.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/services/bill_services.dart';
import 'package:gym_bar_sales/core/view_models/client_model.dart';
import 'package:gym_bar_sales/core/view_models/employee_model.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:provider/provider.dart';
import 'package:search_widget/search_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// final TextEditingController name = TextEditingController();
// final TextEditingController payed = TextEditingController();

// var branch = "بيفرلي";
// var transactorName = 'dsad';
double totalBill = 0;
double payedAmount = 0;
double billChange = 0;
// bool isCredit = false;
Timer timer;

class PanelBody extends StatelessWidget {
  final ScrollController sc;
  final PanelController pc;

  const PanelBody({Key key, this.sc, this.pc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyles _textStyles = TextStyles(context: context);
    Dimensions _dimensions = Dimensions(context);
    FormWidget _formWidget = FormWidget(context: context);

    var productModel = Provider.of<ProductModel>(context);

    var employeeModel = Provider.of<EmployeeModel>(context);
    var clientModel = Provider.of<ClientModel>(context);
    var billServices = Provider.of<BillServices>(context);

    List<Product> selectedList = productModel.getSelectedProducts();

    List<Employee> employees = employeeModel.employees;
    Employee selectedEmployee = employeeModel.selectedEmployee;

    List<Client> clients = clientModel.clients;
    Client selectedClient = clientModel.selectedClient;

    String selectedBuyerType = billServices.selectedBuyerType;

    calculateTheTotalBillPerProduct() {}
    calculateTheTotalBill() {}
    calculateOnlyForHouseType() {}

    changePanelState() {
      if (selectedList.isEmpty || selectedList.length <= 0) {
        print("no product selected to open the pill");
      }
      if (selectedList.length > 0) {
        // if (_pc.isPanelOpen) _pc.close();
        if (pc.isPanelClosed) pc.open();
      }
    }

    onMinusProduct(index) {
      productModel.removeProductSelectionById(selectedList[index].id);
      print(selectedList.length);
    }

    _omar() {
      if (productModel.isThereSelectedProduct()) {
        print(selectedList.length);
        print("حصل");
        FocusScope.of(context).unfocus();
        pc.close();
      }
    }

    onPlusProduct(index) {
      if (selectedList[index].selectionNo >=
          double.parse(selectedList[index].netTotalQuantity)) {
        print("product needed");
      }

      if (double.parse(selectedList[index].netTotalQuantity) > 0 &&
          selectedList[index].selectionNo <
              double.parse(selectedList[index].netTotalQuantity)) {
        productModel.addProductSelectionById(selectedList[index].id);

        // calculateTheTotalBillPerProduct();
        // calculateTheTotalBill();
        // if (selectedBuyerType == "House") {
        //   calculateOnlyForHouseType();
        // }

      }
    }

    cancelTimer() {
      print('cancel');
      timer.cancel();
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
                      SizedBox(width: _dimensions.widthPercent(9)),
                      Container(
                        child: Text(
                            selectedList[index]
                                .theTotalBillPerProduct
                                .toString(),
                            style: _textStyles.billTableContentStyle()),
                        constraints: BoxConstraints(
                          maxWidth: _dimensions.widthPercent(7.5),
                          minWidth: _dimensions.widthPercent(7.5),
                        ),
                      ),
                      SizedBox(width: _dimensions.widthPercent(20)),
                      Container(
                        child: Text(
                            selectedBuyerType == "Client"
                                ? selectedList[index].customerPrice
                                : selectedBuyerType == "Employee"
                                    ? selectedList[index].employeePrice
                                    : selectedList[index].housePrice,
                            style: _textStyles.billTableContentStyle()),
                        constraints: BoxConstraints(
                          maxWidth: _dimensions.widthPercent(7.5),
                          minWidth: _dimensions.widthPercent(7.5),
                        ),
                      ),
                      SizedBox(width: _dimensions.widthPercent(7)),
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
                                _omar();
                              },
                              onTapDown: (TapDownDetails details) {
                                timer = Timer.periodic(
                                    Duration(milliseconds: 200),
                                    (t) => onMinusProduct(index));
                                _omar();
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
                          SizedBox(width: _dimensions.widthPercent(8)),
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

    List<Widget> buyerTypeChoices() {
      return [
        ChoiceChip(
          padding:
              EdgeInsets.symmetric(horizontal: _dimensions.widthPercent(2)),
          labelStyle: _textStyles.chipLabelStyleLight(),
          backgroundColor: Colors.white,
          selectedColor: Colors.blue,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.blue),
          ),
          label: Text("عامل"),
          selected: selectedBuyerType == "House",
          onSelected: (selected) {
            billServices.selectedBuyerType = "House";
            employeeModel.selectedEmployee = null;
            clientModel.selectedClient = null;

            calculateTheTotalBillPerProduct();
            calculateTheTotalBill();
            calculateOnlyForHouseType();
          },
        ),
        SizedBox(width: _dimensions.widthPercent(2)),
        ChoiceChip(
          padding:
              EdgeInsets.symmetric(horizontal: _dimensions.widthPercent(2)),
          labelStyle: _textStyles.chipLabelStyleLight(),
          backgroundColor: Colors.white,
          selectedColor: Colors.blue,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.blue),
          ),
          label: Text("موظف"),
          selected: selectedBuyerType == "Employee",
          onSelected: (selected) {
            billServices.selectedBuyerType = "Employee";
            payedAmount = 0;
            employeeModel.selectedEmployee = null;
            clientModel.selectedClient = null;

            calculateTheTotalBillPerProduct();
            calculateTheTotalBill();
          },
        ),
        SizedBox(width: _dimensions.widthPercent(2)),
        ChoiceChip(
          padding:
              EdgeInsets.symmetric(horizontal: _dimensions.widthPercent(2)),
          labelStyle: _textStyles.chipLabelStyleLight(),
          selectedColor: Colors.blue,
          backgroundColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.blue),
          ),
          label: Text("عميل"),
          selected: selectedBuyerType == "Client",
          onSelected: (selected) {
            billServices.selectedBuyerType = "Client";
            payedAmount = 0;
            employeeModel.selectedEmployee = null;
            clientModel.selectedClient = null;
            calculateTheTotalBillPerProduct();
            calculateTheTotalBill();
          },
        ),
      ];
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
                Text("الإجمالي", style: _textStyles.billTableTitleStyle()),
                SizedBox(width: _dimensions.widthPercent(2)),
              ],
            )),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("سعر القطعه", style: _textStyles.billTableTitleStyle()),
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

    searchWidget() {
      if (selectedBuyerType == "Employee") {
        return Container(
          width: _dimensions.widthPercent(30),
          child: SearchWidget<Employee>(
            dataList: employees,
            hideSearchBoxWhenItemSelected: false,
            listContainerHeight: MediaQuery.of(context).size.height / 4,
            queryBuilder: (String query, List<Employee> employee) {
              return employee
                  .where((Employee employee) =>
                      employee.name.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            },
            popupListItemBuilder: (Employee employee) {
              return Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: _dimensions.widthPercent(1.8)),
                      child: Text(employee.name,
                          style: _textStyles.searchListItemStyle())),
                ],
              );
            },
            selectedItemBuilder:
                // ignore: missing_return
                (Employee selectedItem, VoidCallback deleteSelectedItem) {},
            onItemSelected: (Employee employee) {
              employeeModel.selectedEmployee = employee;
              print(selectedEmployee.name);
            },
            noItemsFoundWidget: Center(child: Text("No item Found")),
            textFieldBuilder:
                (TextEditingController controller, FocusNode focusNode) {
              return _formWidget.searchTextField(controller, focusNode);
            },
          ),
        );
      }
      if (selectedBuyerType == "Client") {
        return Container(
          width: _dimensions.widthPercent(30),
          child: SearchWidget<Client>(
            dataList: clients,
            hideSearchBoxWhenItemSelected: false,
            listContainerHeight: MediaQuery.of(context).size.height / 4,
            queryBuilder: (String query, List<Client> client) {
              return client
                  .where((Client client) =>
                      client.name.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            },
            popupListItemBuilder: (Client client) {
              return Column(
                children: <Widget>[
                  SizedBox(height: _dimensions.heightPercent(1)),
                  Text(client.name, style: _textStyles.searchListItemStyle()),
                  SizedBox(height: _dimensions.heightPercent(1)),
                ],
              );
            },
            selectedItemBuilder:
                // ignore: missing_return
                (Client selectedItem, VoidCallback deleteSelectedItem) {},
            onItemSelected: (Client client) {
              clientModel.selectedClient = client;
              print(selectedClient.name);
            },
            noItemsFoundWidget: Center(child: Text("No item Found")),
            textFieldBuilder:
                (TextEditingController controller, FocusNode focusNode) {
              return _formWidget.searchTextField(controller, focusNode);
            },
          ),
        );
      } else
        return Container();
    }

    _showNameOfTheBuyer(employees, clients) {
      if (selectedClient == null && selectedEmployee == null) {
        return Flexible(child: searchWidget());
      }
      if (selectedClient != null) {
        return Text(selectedClient.name,
            style: _textStyles.billSearchTitleStyle());
      }
      if (selectedEmployee != null) {
        return Text(selectedEmployee.name,
            style: _textStyles.billSearchTitleStyle());
      }
    }

    billHeader() {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              print("header tapped");
              changePanelState();
            },
            //todo: maybe error;
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  SizedBox(height: _dimensions.heightPercent(2)),
                  Text(
                    "الفاتوره",
                    style: _textStyles.billTitleStyle(),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                SizedBox(height: _dimensions.heightPercent(2)),
                selectedBuyerType == "House"
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: _dimensions.widthPercent(2)),
                          _showNameOfTheBuyer(employees, clients),
                          SizedBox(width: _dimensions.widthPercent(1)),
                          Text(':اسم المشتري',
                              style: _textStyles.billSearchTitleStyle()),
                        ],
                      ),
                SizedBox(height: _dimensions.heightPercent(1.5)),
                Wrap(
                  children: buyerTypeChoices(),
                ),
                SizedBox(height: _dimensions.heightPercent(1.5)),
              ],
            ),
          ),
        ],
      );
    }

    // _confirmTransactionDialog(String cash) {
    //   showDialog<void>(
    //     context: context,
    //     barrierDismissible: true,
    //     // false = user must tap button, true = tap outside dialog
    //     builder: (BuildContext dialogContext) {
    //       return BaseView<EmployeeClientModel>(
    //           onModelReady: (model) => selectedBuyerType == "Client"
    //               ? model.fetchClientById(
    //               branchName: branch, id: selectedClient.id)
    //               : selectedBuyerType == "Employee"
    //               ? model.fetchEmployeeById(
    //               branchName: branch, id: selectedEmployee.id)
    //               : null,
    //           builder: (context, model, child) =>
    //               StatefulBuilder(builder: (context, setState) {
    //                 return AlertDialog(
    //                   title: Text('تاكيد العمليه'),
    //                   content: billChange < 0
    //                       ? Text(
    //                       'تحذير سيتم اضافه باقي الفاتوره علي حساب العميل هل تريد المتابعه ؟')
    //                       : billChange > 0
    //                       ? Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       CheckboxListTile(
    //                         title: Text(
    //                             "هل تريد وضع الباقي في حساب العميل"),
    //                         value: isCredit,
    //                         onChanged: (bool value) {
    //                           setState(() {
    //                             isCredit = value;
    //                           });
    //                         },
    //                       ),
    //                       SizedBox(
    //                           height: _dimensions.heightPercent(0.5)),
    //                       Text(
    //                           "عدم الاختيار تعني ان الباقي قد تم تسليمه بالكامل للعميل"),
    //                     ],
    //                   )
    //                       : Text("هل تريد اتمام العمليه ؟"),
    //                   actions: <Widget>[
    //                     FlatButton(
    //                       child: Text('الغاء'),
    //                       onPressed: () {
    //                         Navigator.of(dialogContext)
    //                             .pop(); // Dismiss alert dialog
    //                       },
    //                     ),
    //                     FlatButton(
    //                       child: Text('اتمام'),
    //                       onPressed: () {
    //                         if (billChange < 0) {
    //                           transaction();
    //                           if (selectedBuyerType == 'Client') {
    //                             updateClientCash(model.oneClient.cash,
    //                                 model.oneClient.id, true);
    //                           }
    //                           if (selectedBuyerType == 'Employee') {
    //                             updateEmployeeCash(model.oneEmployee.cash,
    //                                 model.oneEmployee.id, true);
    //                           }
    //                           TransactionModel().updateTotal(data: {
    //                             'cash': calculateNewTreasury(
    //                                 oldCash: cash, cashToAdd: payedAmount)
    //                           }, docId: branch);
    //                           print('الباقي اقل');
    //                           //المدفوع يروح للخزنه
    //
    //                         }
    //
    //                         if (isCredit) {
    //                           transaction();
    //                           if (selectedBuyerType == 'Client') {
    //                             updateClientCash(model.oneClient.cash,
    //                                 model.oneClient.id, false);
    //                           }
    //                           if (selectedBuyerType == 'Employee') {
    //                             updateEmployeeCash(model.oneEmployee.cash,
    //                                 model.oneEmployee.id, false);
    //                           }
    //                           TransactionModel().updateTotal(data: {
    //                             'cash': calculateNewTreasury(
    //                                 oldCash: cash, cashToAdd: payedAmount)
    //                           }, docId: branch);
    //                           print('الباقي اكتر');
    //
    //                           //المدفوع يروح للخزنه
    //
    //                         }
    //
    //                         if (!isCredit && billChange > 0) {
    //                           transaction();
    //                           TransactionModel().updateTotal(data: {
    //                             'cash': calculateNewTreasury(
    //                                 oldCash: cash, cashToAdd: totalBill)
    //                           }, docId: branch);
    //                           //الاجمالي يروح للخزنه
    //                         }
    //
    //                         if (billChange == 0) {
    //                           transaction();
    //                           TransactionModel().updateTotal(data: {
    //                             'cash': calculateNewTreasury(
    //                                 oldCash: cash, cashToAdd: totalBill)
    //                           }, docId: branch);
    //                           //الاجمالي يروح للخزنه
    //
    //                         }
    //                         Navigator.of(dialogContext)
    //                             .pop(); // Dismiss alert dialog
    //                       },
    //                     ),
    //                   ],
    //                 );
    //               }));
    //     },
    //   );
    // }
    //
    // _noSelectedBuyerNameOrTypeDialog() => showDialog<void>(
    //   context: context,
    //   builder: (BuildContext dialogContext) {
    //     return AlertDialog(
    //       title: Text('لا يوجد اسم مشتري'),
    //       content: Text('من فضلك تاكد من اختيار نوع و اسم المشتري الصحيح'),
    //       actions: <Widget>[
    //         FlatButton(
    //           child: Text('حسناً'),
    //           onPressed: () {
    //             Navigator.of(dialogContext).pop(); // Dismiss alert dialog
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
    //
    // billInfo() {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     children: [
    //       SizedBox(
    //         height: _dimensions.heightPercent(2),
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Text(
    //             totalBill.toString(),
    //             style: _textStyles.billInfoStyle(),
    //           ),
    //           SizedBox(width: _dimensions.widthPercent(3)),
    //           Text('الاجمالي', style: _textStyles.billInfoStyle()),
    //           SizedBox(width: _dimensions.widthPercent(3)),
    //         ],
    //       ),
    //       SizedBox(height: _dimensions.heightPercent(2)),
    //       Divider(height: 1, color: Colors.black),
    //       SizedBox(height: _dimensions.heightPercent(2)),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           GestureDetector(
    //               onTap: () {
    //                 if (selectedBuyerType != "House") {
    //                   _changePayAmountDialog();
    //                 }
    //                 if (selectedBuyerType == "House") {
    //                   print("house pay must be equal to total bill");
    //                 }
    //               },
    //               child: Text(payedAmount.toString(),
    //                   style: _textStyles.billInfoStyle())),
    //           SizedBox(width: _dimensions.widthPercent(3)),
    //           Text('المدفوع', style: _textStyles.billInfoStyle()),
    //           SizedBox(width: _dimensions.widthPercent(2.5)),
    //         ],
    //       ),
    //       SizedBox(height: _dimensions.heightPercent(2)),
    //       selectedBuyerType == "House"
    //           ? Container()
    //           : Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Container(
    //               constraints: BoxConstraints(
    //                 maxWidth: _dimensions.widthPercent(30),
    //                 minWidth: _dimensions.widthPercent(8),
    //                 minHeight: _dimensions.widthPercent(4),
    //               ),
    //               decoration: BoxDecoration(
    //                 border: Border.all(color: Colors.black12),
    //                 borderRadius: BorderRadius.circular(
    //                     _dimensions.heightPercent(1)),
    //               ),
    //               child: Column(
    //                 children: [
    //                   SizedBox(height: _dimensions.heightPercent(1.5)),
    //                   Text('الباقي: ' + billChange.toString(),
    //                       style: _textStyles
    //                           .billCustomInfoStyle(billChange)),
    //                   SizedBox(
    //                       width: _dimensions.widthPercent(12),
    //                       height: _dimensions.heightPercent(1))
    //                 ],
    //               )),
    //           SizedBox(width: _dimensions.widthPercent(2.5)),
    //         ],
    //       ),
    //     ],
    //   );
    // }
    //
    billTransactionButton() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: _dimensions.heightPercent(1.5)),
          Center(
              child: ButtonTheme(
            minWidth: 200.0,
            height: _dimensions.heightPercent(5),
            child: RaisedButton(
              color: Colors.blue,
              child:
                  Text("إتمام العمليه", style: _textStyles.billButtonStyle()),
              onPressed: () {
                print(selectedList.length);
                // if (selectedClient == null &&
                //     selectedEmployee == null &&
                //     selectedBuyerType != "House") {
                //   _noSelectedBuyerNameOrTypeDialog();
                // }
                // if (selectedClient != null ||
                //     selectedEmployee != null ||
                //     selectedBuyerType == "House") {
                //   _confirmTransactionDialog(model.total[0].cash);
                // }
              },
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(_dimensions.heightPercent(1))),
            ),
          )),
          SizedBox(height: _dimensions.heightPercent(2.5)),
        ],
      );
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: sc,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min, // Use children total size
            children: [
              billHeader(),
              Column(
                children: <Widget>[
                  tableHead(),
                  billTableBuilder(),
                ],
              ),
              // billInfo(),
              billTransactionButton(),
            ],
          ),
        ],
      ),
    );
  }
}
