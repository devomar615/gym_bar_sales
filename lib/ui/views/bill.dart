import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/category.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/models/employee.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/models/transaction.dart';
import 'package:gym_bar_sales/core/view_models/employee_client_model.dart';
import 'package:gym_bar_sales/core/view_models/product_category_model.dart';
import 'package:gym_bar_sales/core/view_models/transaction_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/views/base_view.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:gym_bar_sales/ui/widgets/home_item.dart';
import 'package:intl/intl.dart';
import 'package:search_widget/search_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Bill extends StatefulWidget {
  @override
  _BillState createState() => _BillState();
}

class _BillState extends State<Bill> {
  double totalBill = 0;
  double payedAmount = 0;
  double billChange = 0;
  bool isCredit = false;
  Timer timer;

  final TextEditingController name = TextEditingController();
  final TextEditingController payed = TextEditingController();
  final PanelController _pc = PanelController();

  String selectedCategory = "All";
  String selectedBuyerType = "Client";

  List<Product> filteredProducts = List<Product>();
  List<Product> selectedList = List<Product>();

  Employee selectedEmployee;
  Client selectedClient;


  var branch = "بيفرلي";
  var transactorName = 'dsad';

  changePanelState() {
    if (selectedList.isEmpty || selectedList.length <= 0) {
      print("no product selected to open the pill");
    }
    if (selectedList.length > 0) {
      if (_pc.isPanelOpen) _pc.close();
      if (_pc.isPanelClosed) _pc.open();
    }
  }

  calculateTheTotalBillPerProduct() {
    for (int i = 0; i < selectedList.length; i++) {
      selectedList[i].theTotalBillPerProduct = selectedList[i].selectionNo *
          int.parse(
            selectedBuyerType == "Client"
                ? selectedList[i].customerPrice
                : selectedBuyerType == "Employee"
                    ? selectedList[i].employeePrice
                    : selectedList[i].housePrice,
          );
    }
  }

  calculateChange() {
    billChange = payedAmount - totalBill;
  }

  calculateTheTotalBill() {
    double sum = 0;
    selectedList.forEach((element) {
      sum += element.theTotalBillPerProduct;
    });
    setState(() {
      totalBill = sum;
    });
    calculateChange();
  }

  calculateOnlyForHouseType() {
    payedAmount = totalBill;
    billChange = 0;
  }

  calculateNewTreasury({String oldCash, double cashToAdd}) {
    print("printing old cash");
    print(oldCash);
    double newTotal = double.parse(oldCash) + cashToAdd;
    print("printing new cash");
    print(newTotal);
    return newTotal.toString();
  }

  updateBuyerCash(oldCash, credit) {
    double newCash;
    newCash = double.parse(oldCash) + billChange;
    return newCash.toString();
  }

  updateProductQuantity(index) {
    //todo: greyout the outstock products
    //todo: greyout the outstock products
    //todo: greyout the outstock products
    //todo: greyout the outstock products
    //todo: greyout the outstock products

    double currentTotalAmount =
        double.parse(selectedList[index].netTotalQuantity);
    print('printing current total amount...');
    print(currentTotalAmount);

    double billQuantity = selectedList[index].selectionNo *
        double.parse(selectedList[index].theAmountOfSalesPerProduct);
    print('printing bill quantity...');
    print(billQuantity);

    double newQuantity = currentTotalAmount - billQuantity;
    print('printing new quantity to be added...');
    print(newQuantity);

    return newQuantity;
  }

  updateProductWholesaleQuantity(index) {
    double currentWholesaleAmount =
        double.parse(selectedList[index].quantityOfWholesaleUnit);
    print('printing currentWholesaleAmount...');
    print(currentWholesaleAmount);

    double newWholesaleQuantity =
        updateProductQuantity(index) / currentWholesaleAmount;
    print('printing newWholesaleQuantity...');
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

  updateClientCash(clientCash, clientId, credit) {
    double updatedCash = double.parse(updateBuyerCash(clientCash, credit));
    var updatedType;
    if (updatedCash == 0) updatedType = "خالص";
    if (updatedCash < 0) updatedType = "دائن";
    if (updatedCash > 0) updatedType = "مدين";

    EmployeeClientModel().updateClient(
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
    EmployeeClientModel().updateEmployee(
        branchName: branch,
        employeeId: employeeId,
        data: {'cash': updatedCash.toString(), 'type': updatedType});
  }

  transaction() {
    print('beginning transaction...');
    TransactionModel().addTransaction(
        branchName: branch,
        transaction: Transaction(
          transactorName: transactorName,
          transactionType: "selling",
          transactionAmount: totalBill.toString(),
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          hour: DateFormat('h:mm a').format(DateTime.now()),
          branch: branch,
          customerName: selectedBuyerType == 'Employee'
              ? selectedEmployee.name
              : selectedBuyerType == 'Client'
                  ? selectedClient.name
                  : 'المشتري عامل',
          customerType: selectedBuyerType,
          sellingProducts: sellingProducts(),
          paid: payedAmount.toString(),
          change: billChange.toString(),
        ));
    print('Transaction Added');
    for (int i = 0; i < selectedList.length; i++) {
      print('netTotalQuantity of prodduct number $i =' +
          selectedList[i].netTotalQuantity);
      print('id of prodduct number $i is=' + selectedList[i].id);
      TransactionModel().updateProducts(
          branchName: branch,
          productId: selectedList[i].id,
          data: {
            "netTotalQuantity": updateProductQuantity(i).toString(),
            "wholesaleQuantity": updateProductWholesaleQuantity(i)
          });
    }
    print('Products Updated');
  }

  File file;

  @override
  Widget build(BuildContext context) {
    TextStyles _textStyles = TextStyles(context: context);
    HomeItem _homeItem = HomeItem(context: context);
    FormWidget _formWidget = FormWidget(context: context);
    Dimensions _dimensions = Dimensions(context);

    BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(_dimensions.heightPercent(3)), topRight: Radius.circular(_dimensions.heightPercent(3)));

    Widget addPhoto() => file == null
        ? _formWidget.logo(
            imageContent:
                Image.asset("assets/images/myprofile.jpg", fit: BoxFit.cover),
            backgroundColor: Colors.white)
        : _formWidget.logo(imageContent: Image.file(file, fit: BoxFit.cover));
    _buildCategoryList({List<Category> category, List<Product> products}) {
      List<Widget> choices = List();
      if (selectedCategory == "All") {
        filteredProducts = products;
      }
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
              setState(() {
                selectedCategory = "All";
                filteredProducts = products;
              });
            },
          )));
      for (int i = 0; i < category.length; i++) {
        choices.add(Container(
          padding: EdgeInsets.only(left: _dimensions.heightPercent(2)),
          child: ChoiceChip(
            labelStyle: _textStyles.chipLabelStyleLight(),
            selectedColor: Colors.orange,
            backgroundColor: Colors.white,
            shape: StadiumBorder(side: BorderSide(color: Colors.orange)),
            label: Text(category[i].name),
            selected: selectedCategory == category[i].name,
            onSelected: (selected) {
              setState(() {
                selectedCategory = category[i].name;
                filteredProducts = products
                    .where((product) => product.category == selectedCategory)
                    .toList();
              });
            },
          ),
        ));
      }
      return choices;
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
                              onTapDown: (TapDownDetails details) {
                                print('down');
                                timer = Timer.periodic(
                                    Duration(milliseconds: 200), (t) {
                                  final product = filteredProducts.firstWhere(
                                      (product) =>
                                          product.name ==
                                          selectedList[index].name);
                                  setState(() {
                                    product.selectionNo -= 1;
                                    product.theTotalBillPerProduct =
                                        product.selectionNo *
                                            int.parse(product.customerPrice);
                                    selectedList.removeWhere((selectedList) =>
                                        selectedList.selectionNo == 0);
                                  });
                                  calculateTheTotalBillPerProduct();
                                  calculateTheTotalBill();
                                  if (selectedList.length < 0 ||
                                      selectedList.isEmpty) {
                                    _pc.close();
                                  }
                                });
                              },
                              onTapUp: (TapUpDetails details) {
                                print('up');
                                timer.cancel();
                              },
                              onTapCancel: () {
                                print('cancel');
                                timer.cancel();
                              },
                              child: IconButton(
                                color: Colors.red,
                                iconSize: _dimensions.widthPercent(3.5),
                                icon: Icon(Icons.remove_circle),
                                onPressed: () {
                                  final product = filteredProducts.firstWhere(
                                      (product) =>
                                          product.name ==
                                          selectedList[index].name);
                                  setState(() {
                                    product.selectionNo -= 1;
                                    product.theTotalBillPerProduct =
                                        product.selectionNo *
                                            int.parse(product.customerPrice);
                                    selectedList.removeWhere((selectedList) =>
                                        selectedList.selectionNo == 0);
                                  });
                                  calculateTheTotalBillPerProduct();
                                  calculateTheTotalBill();
                                  if (selectedBuyerType == "House") {
                                    calculateOnlyForHouseType();
                                  }
                                  if (selectedList.length < 0 ||
                                      selectedList.isEmpty) {
                                    _pc.close();
                                  }
                                },
                              ),
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
                                onPressed: () {
                                  if (selectedList[index].selectionNo >=
                                      double.parse(selectedList[index]
                                          .netTotalQuantity)) {
                                    print("product needed");
                                  }

                                  if (double.parse(selectedList[index]
                                              .netTotalQuantity) >
                                          0 &&
                                      selectedList[index].selectionNo <
                                          double.parse(selectedList[index]
                                              .netTotalQuantity)) {
                                    final product = filteredProducts.firstWhere(
                                        (product) =>
                                            product.name ==
                                            selectedList[index].name);
                                    setState(() {
                                      product.selectionNo += 1;
                                      product.theTotalBillPerProduct =
                                          product.selectionNo *
                                              int.parse(product.customerPrice);
                                    });
                                    calculateTheTotalBillPerProduct();
                                    calculateTheTotalBill();
                                    if (selectedBuyerType == "House") {
                                      calculateOnlyForHouseType();
                                    }
                                  }
                                }),
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
            setState(() {
              selectedBuyerType = "House";
              selectedEmployee = null;
              selectedClient = null;
            });
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
            setState(() {
              selectedBuyerType = "Employee";
              payedAmount = 0;
              selectedEmployee = null;
              selectedClient = null;
            });
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
            setState(() {
              selectedBuyerType = "Client";
              payedAmount = 0;
              selectedEmployee = null;
              selectedClient = null;
            });
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

    searchWidget(List<Employee> employees, List<Client> clients) {
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
              setState(() {
                selectedEmployee = employee;
              });
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
              setState(() {
                selectedClient = client;
              });
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
        return Flexible(child: searchWidget(employees, clients));
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

    billHeader({List<Employee> employees, List<Client> clients, context}) {
      return Column(
        children: [
          GestureDetector(
            onTap: () => changePanelState(),
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

    _changePayAmountDialog() {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('اختيار المبلغ المدفوع'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  payedAmount = double.tryParse(value);
                  if (payedAmount == null) payedAmount = 0;
                });
                calculateChange();
              },
              decoration: InputDecoration(labelText: 'اكتب المبلغ هنا'),
              keyboardType: TextInputType.number,
              maxLength: 3,
              maxLengthEnforced: true,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('اتمام'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        },
      );
    }

    _confirmTransactionDialog(String cash) {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return BaseView<EmployeeClientModel>(
              onModelReady: (model) => selectedBuyerType == "Client"
                  ? model.fetchClientById(
                      branchName: branch, id: selectedClient.id)
                  : selectedBuyerType == "Employee"
                      ? model.fetchEmployeeById(
                          branchName: branch, id: selectedEmployee.id)
                      : null,
              builder: (context, model, child) =>
                  StatefulBuilder(builder: (context, setState) {
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
                                      title: Text(
                                          "هل تريد وضع الباقي في حساب العميل"),
                                      value: isCredit,
                                      onChanged: (bool value) {
                                        setState(() {
                                          isCredit = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                        height: _dimensions.heightPercent(0.5)),
                                    Text(
                                        "عدم الاختيار تعني ان الباقي قد تم تسليمه بالكامل للعميل"),
                                  ],
                                )
                              : Text("هل تريد اتمام العمليه ؟"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('الغاء'),
                          onPressed: () {
                            Navigator.of(dialogContext)
                                .pop(); // Dismiss alert dialog
                          },
                        ),
                        FlatButton(
                          child: Text('اتمام'),
                          onPressed: () {
                            if (billChange < 0) {
                              transaction();
                              if (selectedBuyerType == 'Client') {
                                updateClientCash(model.oneClient.cash,
                                    model.oneClient.id, true);
                              }
                              if (selectedBuyerType == 'Employee') {
                                updateEmployeeCash(model.oneEmployee.cash,
                                    model.oneEmployee.id, true);
                              }
                              TransactionModel().updateTotal(data: {
                                'cash': calculateNewTreasury(
                                    oldCash: cash, cashToAdd: payedAmount)
                              }, docId: branch);
                              print('الباقي اقل');
                              //المدفوع يروح للخزنه

                            }

                            if (isCredit) {
                              transaction();
                              if (selectedBuyerType == 'Client') {
                                updateClientCash(model.oneClient.cash,
                                    model.oneClient.id, false);
                              }
                              if (selectedBuyerType == 'Employee') {
                                updateEmployeeCash(model.oneEmployee.cash,
                                    model.oneEmployee.id, false);
                              }
                              TransactionModel().updateTotal(data: {
                                'cash': calculateNewTreasury(
                                    oldCash: cash, cashToAdd: payedAmount)
                              }, docId: branch);
                              print('الباقي اكتر');

                              //المدفوع يروح للخزنه

                            }

                            if (!isCredit && billChange > 0) {
                              transaction();
                              TransactionModel().updateTotal(data: {
                                'cash': calculateNewTreasury(
                                    oldCash: cash, cashToAdd: totalBill)
                              }, docId: branch);
                              //الاجمالي يروح للخزنه
                            }

                            if (billChange == 0) {
                              transaction();
                              TransactionModel().updateTotal(data: {
                                'cash': calculateNewTreasury(
                                    oldCash: cash, cashToAdd: totalBill)
                              }, docId: branch);
                              //الاجمالي يروح للخزنه

                            }
                            Navigator.of(dialogContext)
                                .pop(); // Dismiss alert dialog
                          },
                        ),
                      ],
                    );
                  }));
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

    billInfo() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: _dimensions.heightPercent(2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                totalBill.toString(),
                style: _textStyles.billInfoStyle(),
              ),
              SizedBox(width: _dimensions.widthPercent(3)),
              Text('الاجمالي', style: _textStyles.billInfoStyle()),
              SizedBox(width: _dimensions.widthPercent(3)),
            ],
          ),
          SizedBox(height: _dimensions.heightPercent(2)),
          Divider(height: 1, color: Colors.black),
          SizedBox(height: _dimensions.heightPercent(2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: () {
                    if (selectedBuyerType != "House") {
                      _changePayAmountDialog();
                    }
                    if (selectedBuyerType == "House") {
                      print("house pay must be equal to total bill");
                    }
                  },
                  child: Text(payedAmount.toString(),
                      style: _textStyles.billInfoStyle())),
              SizedBox(width: _dimensions.widthPercent(3)),
              Text('المدفوع', style: _textStyles.billInfoStyle()),
              SizedBox(width: _dimensions.widthPercent(2.5)),
            ],
          ),
          SizedBox(height: _dimensions.heightPercent(2)),
          selectedBuyerType == "House"
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        constraints: BoxConstraints(
                          maxWidth: _dimensions.widthPercent(30),
                          minWidth: _dimensions.widthPercent(8),
                          minHeight: _dimensions.widthPercent(4),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(
                              _dimensions.heightPercent(1)),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: _dimensions.heightPercent(1.5)),
                            Text('الباقي: ' + billChange.toString(),
                                style: _textStyles
                                    .billCustomInfoStyle(billChange)),
                            SizedBox(
                                width: _dimensions.widthPercent(12),
                                height: _dimensions.heightPercent(1))
                          ],
                        )),
                    SizedBox(width: _dimensions.widthPercent(2.5)),
                  ],
                ),
        ],
      );
    }

    billTransactionButton() {
      return BaseView<TransactionModel>(
          onModelReady: (model) => model.fetchTotal(),
          builder: (context, model, child) => Column(
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
                      child: Text("إتمام العمليه",
                          style: _textStyles.billButtonStyle()),
                      onPressed: () {
                        if (selectedClient == null &&
                            selectedEmployee == null &&
                            selectedBuyerType != "House") {
                          _noSelectedBuyerNameOrTypeDialog();
                        }
                        if (selectedClient != null ||
                            selectedEmployee != null ||
                            selectedBuyerType == "House") {
                          _confirmTransactionDialog(model.total[0].cash);
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              _dimensions.heightPercent(1))),
                    ),
                  )),
                  SizedBox(height: _dimensions.heightPercent(2.5)),
                ],
              ));
    }

    Widget _panel(ScrollController sc) {
      return BaseView<EmployeeClientModel>(
        onModelReady: (model) =>
            model.fetchClientsAndEmployees(branchName: branch),
        builder: (context, model, child) => model.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator())
            : MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  controller: sc,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min, // Use children total size
                      children: [
                        billHeader(
                            employees: model.employees,
                            clients: model.clients,
                            context: context),
                        Column(
                          children: <Widget>[
                            tableHead(),
                            billTableBuilder(),
                          ],
                        ),
                        billInfo(),
                        billTransactionButton(),
                      ],
                    ),
                  ],
                ),
              ),
      );
    }

    onPanelClosed(List<Product> products) {
      TransactionModel().fetchTotal();
      setState(() {
        selectedCategory == 'All'
            ? filteredProducts = products
            : filteredProducts = products
                .where((product) => product.category == selectedCategory)
                .toList();
      });
    }

    appBar() {
      return BaseView<TransactionModel>(
          onModelReady: (model) => model.fetchTotal(),
          builder: (context, model, child) => model.state == ViewState.Busy
              ? Column(
                  children: [
                    SizedBox(height: _dimensions.heightPercent(4)),
                    Text("Loading Treasury Info..."),
                    SizedBox(height: _dimensions.heightPercent(4)),
                  ],
                )
              : Column(
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
                        Text(
                          model.total[0].cash,
                          style: _textStyles
                              .appBarCalculationsStyle(model.total[0].cash),
                        ),
                        SizedBox(width: _dimensions.widthPercent(2)),
                        Text(
                          ':الخزينه',
                          style: _textStyles
                              .appBarCalculationsStyle(model.total[0].cash),
                        ),
                        SizedBox(width: _dimensions.widthPercent(2)),
                        IconButton(
                          icon: Icon(Icons.menu),
                          iconSize: _dimensions.widthPercent(4),
                          onPressed: () {
                            Navigator.pushNamed(context, '/more');
                          },
                        ),
                        SizedBox(width: _dimensions.widthPercent(2)),
                      ],
                    ),
                    SizedBox(height: _dimensions.heightPercent(1)),
                  ],
                ));
    }

    return BaseView<ProductCategoryModel>(
        onModelReady: (model) =>
            model.fetchCategoriesAndProducts(branchName: branch),
        builder: (context, model, child) => Scaffold(
              body: GestureDetector(
                onTap: () {
                  // call this method here to hide soft keyboard
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SlidingUpPanel(
                  maxHeight: _dimensions.heightPercent(90),
                  minHeight:_dimensions.heightPercent(13),
                  // panelSnapping: false,
                  onPanelOpened: () => filteredProducts = selectedList,
                  onPanelClosed: () => onPanelClosed(model.products),
                  // parallaxEnabled: true,
                  isDraggable: false,
                  // backdropEnabled: true,
                  backdropOpacity: 0.3,
                  borderRadius: radius,
                  panelBuilder: (sc) => _panel(sc),
                  controller: _pc,
                  collapsed: GestureDetector(
                    onTap: () => changePanelState(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: radius),
                      child: Center(
                        child: Text("الفاتوره",
                            style: _textStyles.billTitleStyle()),
                      ),
                    ),
                  ),
                  body: model.state == ViewState.Busy
                      ? Center(child: CircularProgressIndicator())
                      : GestureDetector(
                          onTap: () {
                            if (_pc.isPanelOpen) _pc.close();
                          },
                          child: Container(
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
                                      children: _buildCategoryList(
                                          category: model.categories,
                                          products: model.products),
                                    ),
                                  ),
                                ),
                                SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return filteredProducts.isEmpty
                                          ? Center(
                                              child: Text('لا يوجد منتجات هنا'))
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  left: _dimensions
                                                      .widthPercent(1),
                                                  top: _dimensions
                                                      .heightPercent(3),
                                                  right: _dimensions
                                                      .widthPercent(1)),
                                              child: double.parse(filteredProducts[
                                                              index]
                                                          .netTotalQuantity) <=
                                                      0
                                                  ? _homeItem.item(
                                                      selectionNo: null,
                                                      networkImage:
                                                          "https://cdn.mos.cms.futurecdn.net/42E9as7NaTaAi4A6JcuFwG-1200-80.jpg",
                                                      title: filteredProducts[
                                                              index]
                                                          .name,
                                                      backGround: Colors.grey)
                                                  : _homeItem.item(
                                                      backGround: Colors.blue,
                                                      onTapDownIcon:
                                                          (TapDownDetails
                                                              details) {
                                                        print('down');
                                                        timer = Timer.periodic(
                                                            Duration(
                                                                milliseconds:
                                                                    200), (t) {
                                                          if (filteredProducts[
                                                                      index]
                                                                  .selectionNo >
                                                              0) {
                                                            setState(() {
                                                              filteredProducts[
                                                                      index]
                                                                  .selectionNo -= 1;
                                                              selectedList.removeWhere(
                                                                  (selectedList) =>
                                                                      selectedList
                                                                          .selectionNo ==
                                                                      0);
                                                            });
                                                          }
                                                          calculateTheTotalBillPerProduct();
                                                          calculateTheTotalBill();
                                                          if (selectedBuyerType ==
                                                              "House") {
                                                            calculateOnlyForHouseType();
                                                          }
                                                        });
                                                      },
                                                      onTapUpIcon: (TapUpDetails
                                                          details) {
                                                        print('up');
                                                        timer.cancel();
                                                      },
                                                      onTapCancelIcon: () {
                                                        print('cancel');
                                                        timer.cancel();
                                                      },
                                                      onPressIcon: () {
                                                        if (filteredProducts[
                                                                    index]
                                                                .selectionNo >
                                                            0) {
                                                          setState(() {
                                                            filteredProducts[
                                                                    index]
                                                                .selectionNo -= 1;
                                                            selectedList.removeWhere(
                                                                (selectedList) =>
                                                                    selectedList
                                                                        .selectionNo ==
                                                                    0);
                                                          });
                                                        }
                                                        calculateTheTotalBillPerProduct();
                                                        calculateTheTotalBill();
                                                        if (selectedBuyerType ==
                                                            "House") {
                                                          calculateOnlyForHouseType();
                                                        }
                                                      },
                                                      selectionNo:
                                                          filteredProducts[
                                                                  index]
                                                              .selectionNo,
                                                      statistics: filteredProducts[
                                                                      index]
                                                                  .selectionNo >
                                                              0
                                                          ? filteredProducts[
                                                                  index]
                                                              .selectionNo
                                                              .toString()
                                                          : "",
                                                      topSpace: SizedBox(
                                                        height: _dimensions
                                                            .heightPercent(9),
                                                      ),
                                                      betweenSpace: SizedBox(
                                                        height: _dimensions
                                                            .heightPercent(3),
                                                      ),
                                                      title: filteredProducts[
                                                              index]
                                                          .name,
                                                      assetImage: null,
                                                      onPressItem: () {
                                                        if (double.parse(filteredProducts[
                                                                        index]
                                                                    .netTotalQuantity) <
                                                                0 ||
                                                            filteredProducts[
                                                                        index]
                                                                    .selectionNo >=
                                                                double.parse(
                                                                    filteredProducts[
                                                                            index]
                                                                        .netTotalQuantity)) {
                                                          print(
                                                              'product needed');
                                                        }

                                                        if (double.parse(filteredProducts[
                                                                        index]
                                                                    .netTotalQuantity) >
                                                                0 &&
                                                            filteredProducts[
                                                                        index]
                                                                    .selectionNo <
                                                                double.parse(
                                                                    filteredProducts[
                                                                            index]
                                                                        .netTotalQuantity)) {
                                                          setState(() {
                                                            filteredProducts[
                                                                    index]
                                                                .selectionNo += 1;
                                                          });

                                                          if (!selectedList
                                                              .contains(
                                                                  filteredProducts[
                                                                      index])) {
                                                            selectedList.add(
                                                                filteredProducts[
                                                                    index]);
                                                          }

                                                          calculateTheTotalBillPerProduct();
                                                          calculateTheTotalBill();
                                                          if (selectedBuyerType ==
                                                              "House") {
                                                            calculateOnlyForHouseType();
                                                          }
                                                        }
                                                      },
                                                      networkImage:
                                                          "https://cdn.mos.cms.futurecdn.net/42E9as7NaTaAi4A6JcuFwG-1200-80.jpg",
                                                    ),
                                            );
                                    },
                                    childCount: filteredProducts.length,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ));
  }
}
