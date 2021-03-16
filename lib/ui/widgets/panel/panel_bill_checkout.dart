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
import 'package:gym_bar_sales/ui/widgets/clients/one_client_info.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PanelBillCheckout extends StatelessWidget {
  final panelController;

  const PanelBillCheckout({Key key, this.panelController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String branch = context.read<String>();
    FormWidget _formWidget = FormWidget(context: context);
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
    String selectedBuyerType = billServices.selectedBuyerType;
    double billChange = billServices.billChange;
    Dimensions _dimensions = Dimensions(context);

    _autoClosePanel() {
      if (productModel.isThereSelectedProduct()) {
        print(selectedList.length);
        FocusScope.of(context).unfocus();
        panelController.close();
      }
    }

    updateSellingProductOnDatabase() async {
      for (int i = 0; i < selectedList.length; i++) {
        Product product = await productModel.fetchProductById(branchName: branchName, id: selectedList[i].id);

        double netTotalQuantityToSell =
            selectedList[i].selectionNo * double.parse(selectedList[i].theAmountOfSalesPerProduct);
        double wholeSaleQuantityToSell = netTotalQuantityToSell / double.parse(product.quantityOfWholesaleUnit);

        double currentNetTotalQuantity = double.parse(product.netTotalQuantity);
        double currentWholesaleQuantity = double.parse(product.wholesaleQuantity);

        double newNetTotalQuantity = currentNetTotalQuantity - netTotalQuantityToSell;
        double newWholesaleQuantity = currentWholesaleQuantity - wholeSaleQuantityToSell;

        productModel.updateProduct(branchName: branchName, productId: selectedList[i].id, data: {
          "netTotalQuantity": newNetTotalQuantity.toString(),
          "wholesaleQuantity": newWholesaleQuantity.toString(),
          "limit": productModel.checkLimit(newNetTotalQuantity, double.parse(product.quantityLimit))
        });
      }
    }

    updateBuyingProductOnDatabase() async {
      for (int i = 0; i < selectedList.length; i++) {
        Product product = await productModel.fetchProductById(branchName: branchName, id: selectedList[i].id);

        double netTotalQuantityToBuy = selectedList[i].selectionNo;
        double wholeSaleQuantityToBuy = netTotalQuantityToBuy / double.parse(product.quantityOfWholesaleUnit);

        double currentNetTotalQuantity = double.parse(product.netTotalQuantity);
        double currentWholesaleQuantity = double.parse(product.wholesaleQuantity);

        double newNetTotalQuantity = currentNetTotalQuantity + netTotalQuantityToBuy;
        double newWholesaleQuantity = currentWholesaleQuantity + wholeSaleQuantityToBuy;

        productModel.updateProduct(branchName: branchName, productId: selectedList[i].id, data: {
          "netTotalQuantity": newNetTotalQuantity.toString(),
          "wholesaleQuantity": newWholesaleQuantity.toString(),
          "limit": productModel.checkLimit(newNetTotalQuantity, double.parse(product.quantityLimit))
        });
      }
    }

    updateClientCash({bool addToCash}) async {
      print(selectedClient.name);
      Client client = await clientModel.fetchClientById(branchName: branchName, id: selectedClient.id);

      double currentCash = double.parse(client.cash);
      double cashToAdd = billChange;

      double newCash = addToCash ? currentCash + cashToAdd : currentCash - cashToAdd;
      String newClientType = billServices.calculatePersonCashType(newCash);

      clientModel.updateClient(
          branchName: branch, clientId: selectedClient.id, data: {'cash': newCash.toString(), 'type': newClientType});
    }

    updateEmployeeCash({double cashToAdd, bool addToCash}) async {
      print(selectedEmployee.name);
      Employee employee = await employeeModel.fetchEmployeeById(branchName: branchName, id: selectedEmployee.id);

      double currentCash = double.parse(employee.cash);
      double cashToAdd = billChange;

      double newCash = addToCash ? currentCash + cashToAdd : currentCash - cashToAdd;
      String newEmployeeType = billServices.calculatePersonCashType(newCash);

      employeeModel.updateEmployee(
          branchName: branch,
          employeeId: selectedEmployee.id,
          data: {'cash': newCash.toString(), 'type': newEmployeeType});
    }

    // todo:channnnge temp data;

    var tempTransactorName = "Omar";
    var tempBranchName = context.read<String>();

    mapOfSelectedProduct() {
      Map<String, dynamic> map = {};
      selectedList.forEach((products) => map[products.name + "(${products.unit})"] = products.selectionNo);
      print(map);
      return map;
    }

    sellingTransaction() async {
      MyTransaction myTransaction = MyTransaction(
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
        sellingProducts: mapOfSelectedProduct(),
        paid: billServices.payedAmount.toString(),
        change: billChange.toString(),
      );
      transactionModel.addTransaction(branchName: tempBranchName, transaction: myTransaction).then((_) {
        updateSellingProductOnDatabase();
      });
    }

    buyingTransaction() async {
      MyTransaction myTransaction = MyTransaction(
        transactorName: "Ms Amany",
        transactionType: "buying",
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        hour: DateFormat('h:mm a').format(DateTime.now()),
        branch: branchName,
        buyingProducts: mapOfSelectedProduct(),
        transactionAmount: billServices.payedAmount.toString(),
      );

      transactionModel.addTransaction(branchName: tempBranchName, transaction: myTransaction).then((_) {
        updateBuyingProductOnDatabase();
      });
    }

    calculateNewTreasury({double cashToAdd}) async {
      Total total = await totalModel.fetchTotal(branchName);

      print("printing current cash... ${total.cash}");

      double currentCash = double.parse(total.cash);

      double updatedCash = homeServices.switcherOpen ? currentCash + cashToAdd : currentCash - cashToAdd;

      print("updated cash " + updatedCash.toString());
      totalModel.updateTotal(docId: branchName, total: Total(cash: updatedCash.toString()));
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
                  ? Text('تحذير سيتم اضافه باقي الفاتوره علي حساب العميل هل تريد المتابعه ؟')
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
                            Text("عدم الاختيار تعني ان الباقي قد تم تسليمه بالكامل للعميل"),
                          ],
                        )
                      : Text("هل تريد اتمام العمليه ؟"),
              actions: <Widget>[
                TextButton(
                  child: Text('الغاء'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
                TextButton(
                  child: Text('اتمام'),
                  onPressed: () {
                    billServices.creatingTransaction = true;

                    /// **************************************************************************************************************  ///
                    if (billChange < 0) {
                      sellingTransaction().then((value) {
                        calculateNewTreasury(cashToAdd: billServices.payedAmount).then((_) {
                          if (billServices.selectedBuyerType == 'Client') {
                            updateClientCash(addToCash: false).then((_) {
                              billServices.creatingTransaction = false;
                              productModel.cleanProductSelection();
                            });
                          }
                          if (billServices.selectedBuyerType == 'Employee') {
                            updateEmployeeCash(addToCash: false).then((_) {
                              billServices.creatingTransaction = false;

                              productModel.cleanProductSelection();
                            });
                          }
                        });
                      });
                      //المدفوع يروح للخزنه
                    }

                    /// **************************************************************************************************************  ///
                    if (billServices.isCredit) {
                      sellingTransaction().then((_) {
                        calculateNewTreasury(cashToAdd: billServices.payedAmount).then((_) {
                          if (billServices.selectedBuyerType == 'Client') {
                            updateClientCash(addToCash: true).then((_) {
                              billServices.creatingTransaction = false;

                              productModel.cleanProductSelection();
                            });
                          }
                          if (billServices.selectedBuyerType == 'Employee') {
                            updateEmployeeCash(addToCash: true).then((_) {
                              billServices.creatingTransaction = false;

                              productModel.cleanProductSelection();
                            });
                          }
                        });
                      });
                      //المدفوع يروح للخزنه
                    }

                    /// **************************************************************************************************************  ///

                    if (!billServices.isCredit && billChange > 0) {
                      sellingTransaction().then((_) {
                        calculateNewTreasury(cashToAdd: billServices.totalBill).then((_) {
                          productModel.cleanProductSelection();
                          billServices.creatingTransaction = false;
                        });
                      });
                      //الاجمالي يروح للخزنه
                    }

                    /// **************************************************************************************************************  ///

                    if (billChange == 0) {
                      sellingTransaction().then((_) {
                        calculateNewTreasury(cashToAdd: billServices.totalBill).then((_) {
                          productModel.cleanProductSelection();
                          billServices.creatingTransaction = false;
                        });
                      });
                      //الاجمالي يروح للخزنه
                    }

                    /// **************************************************************************************************************  ///
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
                TextButton(
                  child: Text('حسناً'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );

    void sellingTransactionDialog() {
      print("yes switcher open");
      if (selectedClient == null && selectedEmployee == null && selectedBuyerType != "House") {
        _noSelectedBuyerNameOrTypeDialog();
      }
      if (selectedClient != null || selectedEmployee != null || selectedBuyerType == "House") {
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
              content: Text('هل تود اتمام عملية الشراء وسوف يتم سحب هذا المبلغ من الخزنه'),
              actions: <Widget>[
                TextButton(
                  child: Text('إتمام'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                    buyingTransaction();
                    calculateNewTreasury(cashToAdd: billServices.totalBill);
                    // productModel.cleanProductSelection();
                    // billServices.totalBill = 0;
                    // _autoClosePanel();
                    //todo: productModel.checkLimit(netTotalQuantity, quantityLimit);
                  },
                ),
                TextButton(
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
                child: _formWidget.formButtonTemplate(
                    minWidth: _dimensions.widthPercent(15),
                    height: _dimensions.heightPercent(7),
                    context: context,
                    text: "إتمام العمليه",
                    onTab: () {
                      if (homeServices.switcherOpen) {
                        print("yes switcher open");

                        sellingTransactionDialog();
                      }
                      if (!homeServices.switcherOpen) {
                        print("no switcher open");

                        _confirmBuyingTransactionDialog();
                      }
                    }))),
        SizedBox(height: _dimensions.heightPercent(2.5)),
      ],
    );
  }
}
