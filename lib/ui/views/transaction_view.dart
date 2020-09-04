import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/models/employee.dart';
import 'package:gym_bar_sales/core/models/total.dart';
import 'package:gym_bar_sales/core/models/transaction.dart';
import 'package:gym_bar_sales/core/view_models/employee_client_model.dart';
import 'package:gym_bar_sales/core/view_models/transaction_model.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/shared/ui_helpers.dart';
import 'package:gym_bar_sales/ui/views/base_view.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';

class TransactionView extends StatefulWidget {
  final Map productDetails;

  TransactionView({this.productDetails});

  @override
  _TransactionViewState createState() => _TransactionViewState(productDetails: productDetails);
}

class _TransactionViewState extends State<TransactionView> {
  final Map productDetails;

  _TransactionViewState({this.productDetails});

  final TextEditingController quantity = TextEditingController();

  var _selectedEmployee;
  var _selectedClient;

  productSellingDetails() {}

  dropdownClients(List<Client> client) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(
          "اختر العميل",
          style: formLabelsStyle,
        ),
        value: _selectedClient,
        isDense: true,
        onChanged: (value) {
          setState(() {
            _selectedClient = value;
          });
          print(_selectedClient);
        },
        items: client.map((client) {
          return DropdownMenuItem<String>(child: Text("${client.name}"), value: "${client.name}");
        }).toList(),
      )),
    );
  }

  dropdownEmployees(List<Employee> employee) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(
          "اختر الموظف",
          style: formLabelsStyle,
        ),
        value: _selectedEmployee,
        isDense: true,
        onChanged: (value) {
          setState(() {
            _selectedEmployee = value;
          });
          print(_selectedEmployee);
        },
        items: employee.map((employee) {
          return DropdownMenuItem<String>(
              child: Text("${employee.name}"), value: "${employee.name}");
        }).toList(),
      )),
    );
  }

  String updatePayNowTreasury(Total total) {
    double newCash = double.parse(total.cash) + double.parse(calculateBill());
    return newCash.toString();
  }

  String calculateBill() {
    //todo: should know if the price for empployee,customer or house.
    double price = double.parse(productDetails["customerPrice"]);
    double newQuantity = double.parse(quantity.text);
    double totalPrice = price * newQuantity;
    print("toootal priceee is   :" + totalPrice.toString());
    return totalPrice.toString();
  }

  updateProductQuantity() {
    //todo must not complete the transaction if the billQuantity > currentQuantity
    double currentAmount = double.parse(productDetails["netTotalQuantity"]);
    double billQuantity = double.parse(quantity.text);
    double newQuantity = currentAmount - billQuantity;
    return newQuantity.toString();
  }

  updateProductWholesaleQuantity() {
    print(
        "what is in itttttt:quantityOfWholesaleUnit " + productDetails["quantityOfWholesaleUnit"]);
    double currentWholesaleAmount = double.parse(productDetails["quantityOfWholesaleUnit"]);
    double newWholesaleQuantity = double.parse(updateProductQuantity()) / currentWholesaleAmount;
    return newWholesaleQuantity.toString();
  }

  actions() {
    return BaseView<TransactionModel>(
        onModelReady: (model) => model.fetchTotal(docId: productDetails["branch"]),
        builder: (context, model, child) => Row(
              children: <Widget>[
                formButtonTemplate(
                    context: context,
                    onTab: () {
                      model.addTransaction(
                          branchName: productDetails["branch"],
                          transaction: Transaction(
                            transactorName: _selectedEmployee,
                            transactionType: "buying",
                            transactionAmount: calculateBill(),
                            date: DateTime.now().toString(),
                            branch: productDetails["branch"],
                            clientName: _selectedClient,
                            sellingProducts: "$quantity ${productDetails["name"]} ,",
                            paid: calculateBill(),
                            change: "0",
                          ));

                      model.updateTotal(
                          docId: productDetails["branch"],
                          data: {"cash": updatePayNowTreasury(model.total)});
                      model.updateProducts(
                          branchName: productDetails["branch"],
                          categoryName: productDetails["category"],
                          productId: productDetails["id"],
                          data: {
                            "netTotalQuantity": updateProductQuantity(),
                            "wholesaleQuantity": updateProductWholesaleQuantity()
                          });
                    },
                    text: "الدفع الان"),
                formButtonTemplate(context: context, onTab: () {}, text: "الدفع مسبقا"),
              ],
            ));
  }

  form({dropdownEmployeesWidget, dropdownClientsWidget, context}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: EdgeInsets.only(left: 10, right: 10, top: 50, bottom: 10),
      child: ListView(
        children: <Widget>[
          UIHelper.verticalSpaceMedium(),
          formTextFieldTemplate(hint: "االعدد", controller: quantity),
          UIHelper.verticalSpaceMedium(),
          dropdownEmployeesWidget,
          UIHelper.verticalSpaceMedium(),
          dropdownClientsWidget,
          UIHelper.verticalSpaceMedium(),
          actions()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction"),
      ),
      body: form(
          context: context,
          dropdownEmployeesWidget: BaseView<EmployeeClientModel>(
              onModelReady: (model) => model.fetchEmployees(branchName: productDetails["branch"]),
              builder: (context, model, child) => dropdownEmployees(model.employees)),
          dropdownClientsWidget: BaseView<EmployeeClientModel>(
              onModelReady: (model) => model.fetchClients(productDetails["branch"]),
              builder: (context, model, child) => dropdownClients(model.clients))),
    );
  }
}
