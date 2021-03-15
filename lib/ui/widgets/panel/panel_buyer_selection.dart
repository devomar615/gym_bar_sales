import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/models/employee.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/services/bill_services.dart';
import 'package:gym_bar_sales/core/services/home_services.dart';
import 'package:gym_bar_sales/core/view_models/client_model.dart';
import 'package:gym_bar_sales/core/view_models/employee_model.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:provider/provider.dart';
import 'package:search_widget/search_widget.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

double billChange = 0;
// bool isCredit = false;

class PanelBuyerSelection extends StatelessWidget {
  final panelController;

  const PanelBuyerSelection({Key key, this.panelController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyles _textStyles = TextStyles(context: context);
    Dimensions _dimensions = Dimensions(context);
    FormWidget _formWidget = FormWidget(context: context);

    var productModel = Provider.of<ProductModel>(context);

    var employeeModel = Provider.of<EmployeeModel>(context);
    var clientModel = Provider.of<ClientModel>(context);
    var billServices = Provider.of<BillServices>(context);
    HomeServices homeServices = Provider.of<HomeServices>(context);

    List<Product> selectedList = productModel.getSelectedProducts();

    List<Employee> employees = employeeModel.employees;
    Employee selectedEmployee = employeeModel.selectedEmployee;

    List<Client> clients = clientModel.clients;
    Client selectedClient = clientModel.selectedClient;

    String selectedBuyerType = billServices.selectedBuyerType;

    changePanelState() {
      if (selectedList.isEmpty || selectedList.length <= 0) {
        print("no product selected to open the pill");
      }
      if (selectedList.length > 0) {
        // if (_pc.isPanelOpen) _pc.close();
        if (panelController.isPanelClosed) panelController.open();
      }
    }

    List<Widget> buyerTypeChoices() {
      return [
        ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: _dimensions.widthPercent(1)),
          labelStyle: _textStyles.chipLabelStyleLight(),
          backgroundColor: Colors.white,
          selectedColor: Colors.blue,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.blue),
          ),
          label: Text("عامل", style: _textStyles.chipLabelStyle()),
          selected: selectedBuyerType == "House",
          onSelected: (selected) {
            billServices.selectedBuyerType = "House";
            employeeModel.selectedEmployee = null;
            clientModel.selectedClient = null;

            productModel.calculateTheTotalPerProduct(billServices.selectedBuyerType);
            billServices.calculateTheTotalBill(selectedList);
            billServices.calculateChange();

            billServices.calculateOnlyForHouseType();
          },
        ),
        SizedBox(width: _dimensions.widthPercent(2)),
        ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: _dimensions.widthPercent(1)),
          labelStyle: _textStyles.chipLabelStyleLight(),
          backgroundColor: Colors.white,
          selectedColor: Colors.blue,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.blue),
          ),
          label: Text("موظف", style: _textStyles.chipLabelStyle()),
          selected: selectedBuyerType == "Employee",
          onSelected: (selected) {
            billServices.selectedBuyerType = "Employee";
            billServices.payedAmount = 0;
            employeeModel.selectedEmployee = null;
            clientModel.selectedClient = null;

            productModel.calculateTheTotalPerProduct(billServices.selectedBuyerType);
            billServices.calculateTheTotalBill(selectedList);
            billServices.calculateChange();
          },
        ),
        SizedBox(width: _dimensions.widthPercent(2)),
        ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: _dimensions.widthPercent(1)),
          labelStyle: _textStyles.chipLabelStyleLight(),
          selectedColor: Colors.blue,
          backgroundColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.blue),
          ),
          label: Text("عميل", style: _textStyles.chipLabelStyle()),
          selected: selectedBuyerType == "Client",
          onSelected: (selected) {
            billServices.selectedBuyerType = "Client";
            billServices.payedAmount = 0;
            employeeModel.selectedEmployee = null;
            clientModel.selectedClient = null;

            productModel.calculateTheTotalPerProduct(billServices.selectedBuyerType);
            billServices.calculateTheTotalBill(selectedList);
            billServices.calculateChange();
          },
        ),
      ];
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
                  .where((Employee employee) => employee.name.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            },
            popupListItemBuilder: (Employee employee) {
              return Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: _dimensions.widthPercent(1.8)),
                      child: Text(employee.name, style: _textStyles.searchListItemStyle())),
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
            textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
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
              return client.where((Client client) => client.name.toLowerCase().contains(query.toLowerCase())).toList();
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
            textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
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
        return Text(selectedClient.name, style: _textStyles.billSearchTitleStyle());
      }
      if (selectedEmployee != null) {
        return Text(selectedEmployee.name, style: _textStyles.billSearchTitleStyle());
      }
    }

    return clientModel.status == Status.Busy
        ? Center(child: CircularProgressIndicator())
        : employeeModel.status == Status.Busy
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                                  homeServices.switcherOpen
                                      ? _showNameOfTheBuyer(employees, clients)
                                      : Text("اسم الراجل بتاع الكاشير", style: _textStyles.billSearchTitleStyle()),
                                  SizedBox(width: _dimensions.widthPercent(1)),
                                  Text(':اسم المشتري', style: _textStyles.billSearchTitleStyle()),
                                ],
                              ),
                        SizedBox(height: _dimensions.heightPercent(1.5)),
                        homeServices.switcherOpen ? Wrap(children: buyerTypeChoices()) : Container(),
                        SizedBox(height: _dimensions.heightPercent(1.5)),
                      ],
                    ),
                  ),
                ],
              );
  }
}
