import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/category.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/models/employee.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/models/transaction.dart';
import 'package:gym_bar_sales/core/view_models/product_category_model.dart';
import 'package:gym_bar_sales/core/view_models/employee_client_model.dart';
import 'package:gym_bar_sales/core/view_models/transaction_model.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/views/base_view.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:gym_bar_sales/ui/widgets/home_item.dart';
import 'package:search_widget/search_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AddBill extends StatefulWidget {
  @override
  _AddBillState createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {
  double totalBill = 0;
  double payedAmount = 0;
  double billChange = 0;
  bool isCredit = false;
  final TextEditingController name = TextEditingController();
  final TextEditingController payed = TextEditingController();
  String selectedCategory = "All";
  String selectedBuyerType = "Client";
  List<Product> filteredProducts = List<Product>();

  List<Product> selectedList = List<Product>();

  Employee selectedEmployee;
  Client selectedClient;

  BorderRadiusGeometry radius =
      BorderRadius.only(topLeft: Radius.circular(28.0), topRight: Radius.circular(28.0));
  var branch = "بيفرلي";
  var transactorName = 'dsad';

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
    //todo must not complete the transaction if the billQuantity > currentQuantity
    //todo must not complete the transaction if the billQuantity > currentQuantity
    //todo must not complete the transaction if the billQuantity > currentQuantity
    //todo must not complete the transaction if the billQuantity > currentQuantity
    //todo must not complete the transaction if the billQuantity > currentQuantity
    //todo must not complete the transaction if the billQuantity > currentQuantity

    //todo: try to limit selection in product and greyout the outstock products
    //todo: try to limit selection in product and greyout the outstock products
    //todo: try to limit selection in product and greyout the outstock products

    double currentTotalAmount = double.parse(selectedList[index].netTotalQuantity);
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
    double currentWholesaleAmount = double.parse(selectedList[index].quantityOfWholesaleUnit);
    print('printing currentWholesaleAmount...');
    print(currentWholesaleAmount);

    double newWholesaleQuantity = updateProductQuantity(index) / currentWholesaleAmount;
    print('printing newWholesaleQuantity...');
    print(newWholesaleQuantity);

    return newWholesaleQuantity.toString();
  }

  sellingProducts() {
    var map = {};
    selectedList.forEach((products) => map[products.name] = products.selectionNo);
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
          date: DateTime.now().toString(),
          branch: branch,
          customerName: selectedBuyerType == 'Employee'
              ? selectedEmployee.name
              : selectedBuyerType == 'Client' ? selectedClient.name : 'المشتري عامل',
          customerType: selectedBuyerType,
          sellingProducts: sellingProducts(),
          paid: payedAmount.toString(),
          change: billChange.toString(),
        ));
    print('Transaction Added');
    for (int i = 0; i < selectedList.length; i++) {
      print('netTotalQuantity of prodduct number $i =' + selectedList[i].netTotalQuantity);
      print('id of prodduct number $i is=' + selectedList[i].id);
      TransactionModel().updateProducts(branchName: branch, productId: selectedList[i].id, data: {
        "netTotalQuantity": updateProductQuantity(i).toString(),
        "wholesaleQuantity": updateProductWholesaleQuantity(i)
      });
    }
    print('Products Updated');
  }

  appBar() {
    return Row(
      children: <Widget>[
        RaisedButton(
          child: Text("profile"),
          onPressed: () {},
        ),
        RaisedButton(
          child: Text("treasury"),
          onPressed: () {},
        ),
        RaisedButton(
          child: Text('selectedBuyerName'),
          onPressed: () {},
        )
      ],
    );
  }

  _buildCategoryList({List<Category> category, List<Product> products}) {
    List<Widget> choices = List();
    if (selectedCategory == "All") {
      filteredProducts = products;
    }
    choices.add(Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: ChoiceChip(
          labelStyle: chipLabelStyleLight,
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
        padding: const EdgeInsets.only(left: 30.0),
        child: ChoiceChip(
          labelStyle: chipLabelStyleLight,
          selectedColor: Colors.orange,
          backgroundColor: Colors.white,
          shape: StadiumBorder(side: BorderSide(color: Colors.orange)),
          label: Text(category[i].name),
          selected: selectedCategory == category[i].name,
          onSelected: (selected) {
            setState(() {
              selectedCategory = category[i].name;
              filteredProducts =
                  products.where((product) => product.category == selectedCategory).toList();
            });
          },
        ),
      ));
    }
    return choices;
  }

  tableBuilder() {
    return ListView.builder(
        itemCount: selectedList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                  minHeight: 15.0,
                  maxHeight: 200,
                ),
                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(width: 150),
                    Container(
                      child: Text(selectedList[index].theTotalBillPerProduct.toString(),
                          style: tableContentStyle),
                      constraints: BoxConstraints(
                        maxWidth: 100.0,
                        minWidth: 100,
                      ),
                    ),
                    SizedBox(width: 230),
                    Container(
                      child: Text(
                          selectedBuyerType == "Client"
                              ? selectedList[index].customerPrice
                              : selectedBuyerType == "Employee"
                                  ? selectedList[index].employeePrice
                                  : selectedList[index].housePrice,
                          style: tableContentStyle),
                      constraints: BoxConstraints(
                        maxWidth: 100.0,
                        minWidth: 100,
                      ),
                    ),
                    SizedBox(width: 70),
                    Row(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 100.0,
                            minWidth: 100,
                          ),
                          child: IconButton(
                            color: Colors.red,
                            iconSize: 50,
                            icon: Icon(Icons.remove_circle),
                            onPressed: () {
                              final product = filteredProducts.firstWhere(
                                  (product) => product.name == selectedList[index].name);
                              setState(() {
                                product.selectionNo -= 1;
                                product.theTotalBillPerProduct =
                                    product.selectionNo * int.parse(product.customerPrice);
                                selectedList
                                    .removeWhere((selectedList) => selectedList.selectionNo == 0);
                              });
                              calculateTheTotalBillPerProduct();
                              calculateTheTotalBill();
                            },
                          ),
                        ),
                        SizedBox(width: 50),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 100.0,
                            minWidth: 50,
                          ),
                          child: Text(selectedList[index].selectionNo.toString(),
                              style: tableContentStyle),
                        ),
                        SizedBox(width: 10),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 100.0,
                            minWidth: 100,
                          ),
                          child: IconButton(
                              color: Colors.green,
                              iconSize: 50,
                              icon: Icon(Icons.add_circle),
                              onPressed: () {
                                final product = filteredProducts.firstWhere(
                                    (product) => product.name == selectedList[index].name);
                                setState(() {
                                  product.selectionNo += 1;
                                  product.theTotalBillPerProduct =
                                      product.selectionNo * int.parse(product.customerPrice);
                                });
                                calculateTheTotalBillPerProduct();
                                calculateTheTotalBill();
                              }),
                        ),
                        SizedBox(width: 120),
                      ],
                    ),

                    //todo: change customerPrice to the selected one in the slidingUpPanel.
                    Container(
                        constraints: BoxConstraints(
                          maxWidth: 100.0,
                          minWidth: 100,
                        ),
                        child: Text(selectedList[index].name, style: tableContentStyle))
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
        padding: EdgeInsets.symmetric(horizontal: 15),
        labelStyle: chipLabelStyleLight,
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
          });
          calculateTheTotalBillPerProduct();
          calculateTheTotalBill();
        },
      ),
      SizedBox(width: 20),
      ChoiceChip(
        padding: EdgeInsets.symmetric(horizontal: 15),
        labelStyle: chipLabelStyleLight,
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
          });
          calculateTheTotalBillPerProduct();
          calculateTheTotalBill();
        },
      ),
      SizedBox(width: 20),
      ChoiceChip(
        padding: EdgeInsets.symmetric(horizontal: 15),
        labelStyle: chipLabelStyleLight,
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
          });
          calculateTheTotalBillPerProduct();
          calculateTheTotalBill();
        },
      ),
    ];
  }

  tableHead() {
    return Container(
      height: 60,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("الإجمالي", style: tableTitleStyle),
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
              Text("اسم المنتج", style: tableTitleStyle),
              SizedBox(width: 10),
            ],
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    searchWidget(List<Employee> employees, List<Client> clients) {
      if (selectedBuyerType == "Employee") {
        return Container(
          width: 400,
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
                      padding: const EdgeInsets.all(12),
                      child: Text(employee.name, style: const TextStyle(fontSize: 16))),
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
            textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
              return searchTextField(controller, focusNode, context);
            },
          ),
        );
      }
      if (selectedBuyerType == "Client") {
        return Container(
          width: 400,
          child: SearchWidget<Client>(
            dataList: clients,
            hideSearchBoxWhenItemSelected: false,
            listContainerHeight: MediaQuery.of(context).size.height / 4,
            queryBuilder: (String query, List<Client> client) {
              return client
                  .where((Client client) => client.name.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            },
            popupListItemBuilder: (Client client) {
              return Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(client.name, style: const TextStyle(fontSize: 16))),
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
            textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
              return searchTextField(controller, focusNode, context);
            },
          ),
        );
      } else
        return Container();
    }

    billHeader({List<Employee> employees, List<Client> clients, context}) {
      return Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            "الفاتوره",
            style: headerStyle,
          ),
          SizedBox(
            height: 10,
          ),
          selectedBuyerType == "House"
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: searchWidget(employees, clients)),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'اسم المشتري',
                      style: formTitleStyle,
                    ),
                  ],
                ),
          SizedBox(height: 10),
          Wrap(
            children: buyerTypeChoices(),
          ),
          SizedBox(height: 10),
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
                  payedAmount = double.parse(value);
                });
                calculateChange();
              },
              decoration: InputDecoration(labelText: 'اكتب المبلغ هنا'),
              keyboardType: TextInputType.number,
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
                  ? model.fetchClientById(branchName: branch, id: selectedClient.id)
                  : selectedBuyerType == "Employee"
                      ? model.fetchEmployeeById(branchName: branch, id: selectedEmployee.id)
                      : null,
              builder: (context, model, child) => StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: Text('تاكيد العمليه'),
                      content: billChange < 0
                          ? Text(
                              'تحذير سيتم اضافه باقي الفاتوره علي حساب العميل هل تريد المتابعه ؟')
                          : billChange > 0
                              ? CheckboxListTile(
                                  title: Text("هل تريد وضع الباقي في حساب العميل"),
                                  value: isCredit,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isCredit = value;
                                    });
                                  },
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
                            if (billChange < 0) {
                              transaction(); //todo: make buyer creditor
                              if (selectedBuyerType == 'Client') {
                                updateClientCash(model.oneClient.cash, model.oneClient.id, true);
                              }
                              if (selectedBuyerType == 'Employee') {
                                updateEmployeeCash(
                                    model.oneEmployee.cash, model.oneEmployee.id, true);
                              }
                              TransactionModel().updateTotal(data: {
                                'cash': calculateNewTreasury(oldCash: cash, cashToAdd: payedAmount)
                              }, docId: branch);
                              print('الباقي اقل');
                              //المدفوع يروح للخزنه

                            }

                            if (isCredit) {
                              transaction(); //todo: make buyer debtor
                              if (selectedBuyerType == 'Client') {
                                updateClientCash(model.oneClient.cash, model.oneClient.id, false);
                              }
                              if (selectedBuyerType == 'Employee') {
                                updateEmployeeCash(
                                    model.oneEmployee.cash, model.oneEmployee.id, false);
                              }
                              TransactionModel().updateTotal(data: {
                                'cash': calculateNewTreasury(oldCash: cash, cashToAdd: payedAmount)
                              }, docId: branch);
                              print('الباقي اكتر');

                              //المدفوع يروح للخزنه

                            }

                            if (!isCredit && billChange > 0) {
                              transaction();
                              TransactionModel().updateTotal(data: {
                                'cash': calculateNewTreasury(oldCash: cash, cashToAdd: totalBill)
                              }, docId: branch);
                              //الاجمالي يروح للخزنه
                            }

                            if (billChange == 0) {
                              transaction();
                              TransactionModel().updateTotal(data: {
                                'cash': calculateNewTreasury(oldCash: cash, cashToAdd: totalBill)
                              }, docId: branch);
                              //الاجمالي يروح للخزنه

                            }
                            Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                          },
                        ),
                      ],
                    );
                  }));
        },
      );
    }

    billFooter() {
      return BaseView<TransactionModel>(
          onModelReady: (model) => model.fetchTotal(),
          builder: (context, model, child) => Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        totalBill.toString(),
                        style: formTitleStyle,
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Text(
                        'الاجمالي',
                        style: formTitleStyle,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(height: 1, color: Colors.black),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () {
                            _changePayAmountDialog();
                          },
                          child: Text(payedAmount.toString(), style: formTitleStyle)),
                      SizedBox(width: 80),
                      Text('المدفوع', style: formTitleStyle),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          constraints: BoxConstraints(
                            minWidth: 110,
                            minHeight: 50,
                            maxWidth: 500,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text('الباقي: ' + billChange.toString(),
                                  style: TextStyle(
                                      color: billChange > 0 ? Colors.black : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      fontFamily: 'Tajawal')),
                            ],
                          )),
                      SizedBox(width: 15),
                    ],
                  ),
                  SizedBox(height: 15),
                  Center(
                      child: ButtonTheme(
                    minWidth: 200.0,
                    height: 50,
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text("إتمام العمليه", style: formButtonStyle),
                      onPressed: () {
                        _confirmTransactionDialog(model.total[0].cash);
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  )),
                  SizedBox(height: 20),
                ],
              ));
    }

    return BaseView<ProductCategoryModel>(
        onModelReady: (model) => model.fetchCategoriesAndProducts(branchName: branch),
        builder: (context, model, child) => SafeArea(
              child: Scaffold(
                body: GestureDetector(
                  onTap: () {
                    // call this method here to hide soft keyboard
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: SlidingUpPanel(
                    onPanelOpened: () => filteredProducts = selectedList,
                    onPanelClosed: () {
                      TransactionModel().fetchTotal();
                      setState(() {
                        selectedCategory == 'All'
                            ? filteredProducts = model.products
                            : filteredProducts = model.products
                                .where((product) => product.category == selectedCategory)
                                .toList();
                      });
                    },
                    parallaxEnabled: true,
                    backdropEnabled: true,
                    backdropOpacity: 0.3,
                    maxHeight: 800,
                    borderRadius: radius,
                    panel: BaseView<EmployeeClientModel>(
                      onModelReady: (model) => model.fetchClientsAndEmployees(branchName: branch),
                      builder: (context, model, child) => model.state == ViewState.Busy
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                billHeader(
                                    employees: model.employees,
                                    clients: model.clients,
                                    context: context),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      tableHead(),
                                      Expanded(child: tableBuilder()),
                                    ],
                                  ),
                                ),
                                billFooter(),
                              ],
                            ),
                    ),
                    collapsed: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
                      child: Center(
                        child: Text("الفاتوره", style: headerStyle),
                      ),
                    ),
                    body: model.state == ViewState.Busy
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            child: CustomScrollView(
                              slivers: <Widget>[
                                SliverList(
                                    delegate: SliverChildListDelegate(
                                  [appBar()],
                                )),
                                SliverToBoxAdapter(
                                  child: Container(
                                    height: 50.0,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: _buildCategoryList(
                                          category: model.categories, products: model.products),
                                    ),
                                  ),
                                ),
                                SliverGrid(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return filteredProducts.isEmpty
                                          ? Center(child: Text('لا يوجد منتجات هنا'))
                                          : Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20.0, top: 20.0, right: 20),
                                              child: item(
                                                onPressIcon: () {
                                                  if (filteredProducts[index].selectionNo > 0) {
                                                    setState(() {
                                                      filteredProducts[index].selectionNo -= 1;
                                                      selectedList.removeWhere((selectedList) =>
                                                          selectedList.selectionNo == 0);
                                                    });
                                                  }
                                                  calculateTheTotalBillPerProduct();
                                                  calculateTheTotalBill();
                                                },
                                                selectionNo: filteredProducts[index].selectionNo,
                                                statistics: filteredProducts[index].selectionNo > 0
                                                    ? filteredProducts[index].selectionNo.toString()
                                                    : "",
                                                topSpace: SizedBox(height: 50),
                                                betweenSpace: SizedBox(height: 20),
                                                title: filteredProducts[index].name,
                                                assetImage: "",
                                                backGround: Colors.black,
                                                onPress: () {
                                                  setState(() {
                                                    filteredProducts[index].selectionNo += 1;
                                                  });
                                                  if (!selectedList
                                                      .contains(filteredProducts[index])) {
                                                    selectedList.add(filteredProducts[index]);
                                                  }
                                                  calculateTheTotalBillPerProduct();
                                                  calculateTheTotalBill();
                                                },
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
