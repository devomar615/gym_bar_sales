import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/models/employee.dart';
import 'package:gym_bar_sales/core/models/my_transaction.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/models/total.dart';
import 'package:gym_bar_sales/core/services/bill_services.dart';
import 'package:gym_bar_sales/core/services/home_services.dart';
import 'package:gym_bar_sales/core/view_models/client_model.dart';
import 'package:gym_bar_sales/core/view_models/employee_model.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/core/view_models/total_model.dart';
import 'package:gym_bar_sales/core/view_models/transaction_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PanelBillCheckout extends StatelessWidget {
  final panelController;

  const PanelBillCheckout({Key key, this.panelController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String branch = context.read<String>();

    ProductModel productModel = Provider.of<ProductModel>(context);
    ClientModel clientModel = Provider.of<ClientModel>(context);
    TransactionModel transactionModel = Provider.of<TransactionModel>(context);
    EmployeeModel employeeModel = Provider.of<EmployeeModel>(context);
    TotalModel totalModel = Provider.of<TotalModel>(context);
    BillServices billServices = Provider.of<BillServices>(context);
    HomeServices homeServices = Provider.of<HomeServices>(context);

    Employee selectedEmployee = employeeModel.selectedEmployee;
    Client selectedClient = clientModel.selectedClient;

    List<Product> selectedList = productModel.getSelectedProducts();
    List<Total> total = totalModel.total;
    String selectedBuyerType = billServices.selectedBuyerType;
    double billChange = billServices.billChange;
    TextStyles _textStyles = TextStyles(context: context);
    Dimensions _dimensions = Dimensions(context);

    _autoClosePanel() {
      if (productModel.isThereSelectedProduct()) {
        print(selectedList.length);
        FocusScope.of(context).unfocus();
        panelController.close();
      }
    }

    updateProductQuantity(
        {productId, selectionNo, theAmountOfSalesPerProduct}) async {
      Product product = await productModel.fetchProductById(
          branchName: "بيفرلي", id: productId);

      // get currentTotalAmount from database
      double currentTotalAmount = double.parse(product.netTotalQuantity);
      print('printing current total amount...');
      print(currentTotalAmount);

      print('printing No of selected product...');
      print(selectionNo);
      print('printing theAmountOfSalesPerProduct...');
      print(theAmountOfSalesPerProduct);
      double billQuantity =
          selectionNo * double.parse(theAmountOfSalesPerProduct);

      print('printing bill quantity...');
      print(billQuantity);

      double newQuantity = homeServices.switcherOpen
          ? currentTotalAmount - billQuantity
          : currentTotalAmount + billQuantity;

      print('printing new quantity after transaction...');
      print(newQuantity);

      return newQuantity.toString();
    }

    updateProductWholesaleQuantity(
        {productId, selectionNo, theAmountOfSalesPerProduct}) async {
      Product product = await productModel.fetchProductById(
          branchName: "بيفرلي", id: productId);
      //get currentWholesaleAmount from database
      double currentWholesaleAmount =
          double.parse(product.quantityOfWholesaleUnit);
      print('printing current wholesaleAmount...');
      print(currentWholesaleAmount);

      double newWholesaleQuantity = double.parse(await updateProductQuantity(
              productId: productId,
              selectionNo: selectionNo,
              theAmountOfSalesPerProduct: theAmountOfSalesPerProduct)) /
          currentWholesaleAmount;
      print('printing new wholesaleQuantity...');
      print(newWholesaleQuantity);

      return newWholesaleQuantity.toString();
    }

    sellingProducts() {
      var map = {};
      selectedList
          .forEach((products) => map[products.name] = products.selectionNo);
      print(map);
      return map;
    }

    updateBuyerCash(oldCash, credit) {
      double newCash;
      newCash = double.parse(oldCash) + billChange;
      return newCash.toString();
    }

    updateClientCash(clientCash, clientId, credit) {
      double updatedCash = double.parse(updateBuyerCash(clientCash, credit));
      var updatedType;
      if (updatedCash == 0) updatedType = "خالص";
      if (updatedCash < 0) updatedType = "دائن";
      if (updatedCash > 0) updatedType = "مدين";

      clientModel.updateClient(
          branchName: branch,
          clientId: clientId,
          data: {'cash': updatedCash.toString(), 'type': updatedType});
    }

    updateEmployeeCash(employeeCash, employeeId, credit) {
      double updatedCash = double.parse(updateBuyerCash(employeeCash, credit));
      var updatedType;

      if (updatedCash == 0) updatedType = "خالص";
      if (updatedCash < 0) updatedType = "دائن";
      if (updatedCash > 0) updatedType = "مدين";
      employeeModel.updateEmployee(
          branchName: branch,
          employeeId: employeeId,
          data: {'cash': updatedCash.toString(), 'type': updatedType});
    }

    // todo:channnnge temp data;

    var tempTransactorName = "Omar";
    var tempBranchName = context.read<String>();

    updateProductOnDatabase() async {
      for (int i = 0; i < selectedList.length; i++) {
        print('netTotalQuantity of prodduct number $i =' +
            selectedList[i].netTotalQuantity);
        print('id of prodduct number $i is=' + selectedList[i].id);
        print('selection number of prodduct number $i is=' +
            selectedList[i].selectionNo.toString());

        productModel.updateProduct(
            branchName: tempBranchName,
            productId: selectedList[i].id,
            data: {
              "netTotalQuantity": await updateProductQuantity(
                  productId: selectedList[i].id,
                  selectionNo: selectedList[i].selectionNo,
                  theAmountOfSalesPerProduct:
                      selectedList[i].theAmountOfSalesPerProduct),

              "wholesaleQuantity": await updateProductWholesaleQuantity(
                  productId: selectedList[i].id,
                  selectionNo: selectedList[i].selectionNo,
                  theAmountOfSalesPerProduct:
                      selectedList[i].theAmountOfSalesPerProduct),
              //     });
            });

        print('Products Updated');
      }
    }

    transaction() {
      print('beginning transaction...');
      MyTransaction myTransaction = homeServices.switcherOpen
          ? MyTransaction(
              transactorName: tempTransactorName,
              transactionType: "selling",
              transactionAmount: billServices.totalBill.toString(),
              date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
              hour: DateFormat('h:mm a').format(DateTime.now()),
              branch: tempBranchName,
              customerName: billServices.selectedBuyerType == 'Employee'
                  ? selectedEmployee.name
                  : billServices.selectedBuyerType == 'Client'
                      ? selectedClient.name
                      : 'المشتري عامل',
              customerType: billServices.selectedBuyerType,
              sellingProducts: sellingProducts(),
              paid: billServices.payedAmount.toString(),
              change: billChange.toString(),
            )
          : MyTransaction(
              transactorName: tempTransactorName,
              transactionType: "selling",
              transactionAmount: billServices.totalBill.toString(),
              date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
              hour: DateFormat('h:mm a').format(DateTime.now()),
              branch: tempBranchName,
              buyingProducts: sellingProducts(),
              buyingCashAmount: billServices.payedAmount.toString(),
            );

      transactionModel.addTransaction(
          branchName: tempBranchName, transaction: myTransaction);

      print('Transaction Added');
      updateProductOnDatabase();
    }

    calculateNewTreasury({String oldCash, double cashToAdd}) {
      print("printing old cash");
      print(oldCash);
      double newTotal;
      if (homeServices.switcherOpen) {
        newTotal = double.parse(oldCash) + cashToAdd;
      }
      if (!homeServices.switcherOpen) {
        newTotal = double.parse(oldCash) - cashToAdd;
      }
      print("printing new cash for ");
      print(newTotal);
      return newTotal.toString();
    }

    _confirmTransactionDialog() {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('تاكيد العمليه'),
              content: billChange < 0
                  ? Text(
                      'تحذير سيتم اضافه باقي الفاتوره علي حساب العميل هل تريد المتابعه ؟')
                  : billChange > 0
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CheckboxListTile(
                              title: Text("هل تريد وضع الباقي في حساب العميل"),
                              value: billServices.isCredit,
                              onChanged: (bool value) {
                                setState(() {
                                  billServices.changeIsCredit();
                                });
                              },
                            ),
                            SizedBox(height: _dimensions.heightPercent(0.5)),
                            Text(
                                "عدم الاختيار تعني ان الباقي قد تم تسليمه بالكامل للعميل"),
                          ],
                        )
                      : Text("هل تريد اتمام العمليه ؟"),
              actions: <Widget>[
                FlatButton(
                  child: Text('الغاء'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
                FlatButton(
                  child: Text('اتمام'),
                  onPressed: () {
                    print("Fitshing all needed data for security reasons");
                    totalModel.fetchTotal();

                    // totalModel.fetchTotal();
                    // if (billServices.selectedBuyerType == 'Client') {
                    //   clientModel.fetchClients();
                    // }
                    // if (billServices.selectedBuyerType == 'Employee') {
                    //   employeeModel.fetchEmployees();
                    // }

                    if (billChange < 0) {
                      transaction();
                      if (billServices.selectedBuyerType == 'Client') {
                        updateClientCash(
                            selectedClient.cash, selectedClient.id, true);
                      }
                      if (billServices.selectedBuyerType == 'Employee') {
                        updateEmployeeCash(
                            selectedEmployee.cash, selectedEmployee.id, true);
                      }

                      totalModel.updateTotal(data: {
                        'cash': calculateNewTreasury(
                            oldCash: total[0].cash,
                            cashToAdd: billServices.payedAmount)
                      }, docId: branch);

                      print('الباقي اقل');
                      //المدفوع يروح للخزنه

                    }

                    if (billServices.isCredit) {
                      transaction();
                      if (billServices.selectedBuyerType == 'Client') {
                        updateClientCash(
                            selectedClient.cash, selectedClient.id, false);
                      }
                      if (billServices.selectedBuyerType == 'Employee') {
                        updateEmployeeCash(
                            selectedEmployee.cash, selectedEmployee.id, false);
                      }
                      totalModel.updateTotal(data: {
                        'cash': calculateNewTreasury(
                            oldCash: total[0].cash,
                            cashToAdd: billServices.payedAmount)
                      }, docId: branch);
                      print('الباقي اكتر');

                      //المدفوع يروح للخزنه
                    }

                    if (!billServices.isCredit && billChange > 0) {
                      transaction();
                      totalModel.updateTotal(data: {
                        'cash': calculateNewTreasury(
                            oldCash: total[0].cash,
                            cashToAdd: billServices.totalBill)
                      }, docId: branch);
                      //الاجمالي يروح للخزنه
                    }

                    if (billChange == 0) {
                      transaction();
                      totalModel.updateTotal(data: {
                        'cash': calculateNewTreasury(
                            oldCash: total[0].cash,
                            cashToAdd: billServices.totalBill)
                      }, docId: branch);
                      //الاجمالي يروح للخزنه

                    }
                    // todo: to refresh data you must use streams in your app [idiot]
                    // todo: go read about it and rebuild the whole project again hehehehe
                    // todo: link to help [https://dev.to/nitishk72/understanding-streams-in-flutter-dart-2pb8]
                    // todo: another link [https://medium.com/flutter-community/real-time-stats-monitor-with-flutter-and-firebase-576cd554b9ca]

                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog

                    _autoClosePanel();
                  },
                ),
              ],
            );
          });
        },
      );
    }

    _noSelectedBuyerNameOrTypeDialog() => showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('لا يوجد اسم مشتري'),
              content: Text('من فضلك تاكد من اختيار نوع و اسم المشتري الصحيح'),
              actions: <Widget>[
                FlatButton(
                  child: Text('حسناً'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );

    void sellingTransaction() {
      print("yes switcher open");
      if (selectedClient == null &&
          selectedEmployee == null &&
          selectedBuyerType != "House") {
        _noSelectedBuyerNameOrTypeDialog();
      }
      if (selectedClient != null ||
          selectedEmployee != null ||
          selectedBuyerType == "House") {
        _confirmTransactionDialog();
      }
    }

    _confirmBuyingTransactionDialog() => showDialog<void>(
          context: context,
          barrierDismissible: true,
          // false = user must tap button, true = tap outside dialog
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('إتمام عملية شراء'),
              content: Text(
                  'هل تود اتمام عملية الشراء وسوف يتم سحب هذا المبلغ من الغزنه'),
              actions: <Widget>[
                FlatButton(
                  child: Text('إتمام'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                    transaction();
                    totalModel.updateTotal(data: {
                      'cash': calculateNewTreasury(
                          oldCash: total[0].cash,
                          cashToAdd: billServices.totalBill)
                    }, docId: branch);
                    // productModel.cleanProductSelection();
                    // billServices.totalBill = 0;
                    _autoClosePanel();
                  },
                ),
                FlatButton(
                  child: Text('الغاء'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );

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
            child: Text("إتمام العمليه", style: _textStyles.billButtonStyle()),
            onPressed: () {
              if (homeServices.switcherOpen) {
                print("yes switcher open");

                sellingTransaction();
              }
              if (!homeServices.switcherOpen) {
                print("no switcher open");

                _confirmBuyingTransactionDialog();
              }
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
}
