import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/view_models/client_model.dart';
import 'package:gym_bar_sales/core/view_models/transaction_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:provider/provider.dart';

SortSelection selectedSort;
File file;
var branch = "بيفرلي";

class Clients extends StatelessWidget {
  // String _selectedClientID;
  // Client client;
  // String selectedClientType = "all";

  // List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    ClientModel clientModel = Provider.of<ClientModel>(context);

    String selectedClientType = clientModel.selectedClientType;

    List<Client> filteredClients =
        clientModel.filterClients(selectedClientType);

    Client selectedClient = clientModel.selectedClient;

    FormWidget _formWidget = FormWidget(context: context);
    Dimensions _dimensions = Dimensions(context);
    TextStyles _textStyles = TextStyles(context: context);

    bool nameAscending = clientModel.nameAscending;
    bool cashAscending = clientModel.cashAscending;

    var transactionModel = Provider.of<TransactionModel>(context);

    var filteredTransactions;
    if (selectedClient != null) {
      filteredTransactions =
          transactionModel.getTransactionByCustomerName(selectedClient.name);
    }
    Widget addPhoto() {
      if (file == null) {
        return _formWidget.logo(
            imageContent:
                Image.asset("assets/images/myprofile.jpg", fit: BoxFit.cover),
            backgroundColor: Colors.white);
      } else
        return _formWidget.logo(
            imageContent: Image.file(file, fit: BoxFit.cover));
    }

    onSortName() {
      nameAscending
          ? filteredClients.sort((a, b) => a.name.compareTo(b.name))
          : filteredClients.sort((a, b) => b.name.compareTo(a.name));
    }

    onSortCash() {
      cashAscending
          ? filteredClients.sort((a, b) => a.cash.compareTo(b.cash))
          : filteredClients.sort((a, b) => b.cash.compareTo(a.cash));
    }

    Widget popUpSortSelection() => PopupMenuButton<SortSelection>(
        icon: Icon(
          Icons.sort,
          size: 40,
        ),
        onSelected: (SortSelection selectedSort) {
          if (selectedSort == SortSelection.sortByName) {
            onSortName();
            clientModel.changeNameAscendingState();
            clientModel.changeCashAscendingState();
          }
          if (selectedSort == SortSelection.sortByCash) {
            onSortCash();
            clientModel.changeNameAscendingState();
            clientModel.changeCashAscendingState();
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<SortSelection>(
              child: Text("تصنيف حسب الاسم"),
              value: SortSelection.sortByName,
            ),
            PopupMenuItem<SortSelection>(
              child: Text("تصنيف حسب الرصيد"),
              value: SortSelection.sortByCash,
            ),
          ];
        });

    List<Widget> clientTypeChoices() {
      return [
        ChoiceChip(
          padding: EdgeInsets.symmetric(
              horizontal: _dimensions.widthPercent(2), vertical: 5),
          labelStyle: _textStyles.chipLabelStyleLight(),
          selectedColor: Colors.blue,
          backgroundColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.blue),
          ),
          label: Text("مدين"),
          selected: selectedClientType == "مدين",
          onSelected: (_) => clientModel.selectedClientType = "مدين",
        ),
        SizedBox(width: _dimensions.widthPercent(2)),
        ChoiceChip(
          padding: EdgeInsets.symmetric(
              horizontal: _dimensions.widthPercent(2), vertical: 5),
          labelStyle: _textStyles.chipLabelStyleLight(),
          backgroundColor: Colors.white,
          selectedColor: Colors.blue,
          shape: StadiumBorder(side: BorderSide(color: Colors.blue)),
          label: Text("دائن"),
          selected: selectedClientType == "دائن",
          onSelected: (_) => clientModel.selectedClientType = "دائن",
        ),
        SizedBox(width: _dimensions.widthPercent(2)),
        ChoiceChip(
          padding: EdgeInsets.symmetric(
              horizontal: _dimensions.widthPercent(2), vertical: 5),
          labelStyle: _textStyles.chipLabelStyleLight(),
          backgroundColor: Colors.white,
          selectedColor: Colors.blue,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.blue),
          ),
          label: Text("الكل"),
          selected: selectedClientType == "all",
          onSelected: (_) => clientModel.selectedClientType = "all",
        ),
      ];
    }

    clientsList() {
      //     .fetchTransaction(branchName: branch)
      return ListView.builder(
        itemCount: filteredClients.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTileTheme(
                selectedColor: filteredClients[index].type == 'دائن'
                    ? Colors.red
                    : Colors.blue,
                child: ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    size: 60,
                  ),
                  title: Text(filteredClients[index].name),
                  subtitle: Text(filteredClients[index].cash,
                      style: TextStyle(
                          color: filteredClients[index].type == 'دائن'
                              ? Colors.red
                              : Colors.green)),
                  selected: selectedClient == null
                      ? false
                      : filteredClients[index].id == selectedClient.id,
                  onTap: () {
                    if (selectedClient == null) {
                      clientModel.selectedClient = filteredClients[index];
                    }
                    if (filteredClients[index].id == selectedClient.id) {
                      clientModel.selectedClient = null;
                    } else
                      clientModel.selectedClient = filteredClients[index];
                  },
                ),
              ),
            ),
          );
        },
      );
    }

    leftBody() => Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: clientTypeChoices(),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  popUpSortSelection(),
                ],
              ),
              Expanded(child: Container(height: 500, child: clientsList())),
            ],
          ),
        );

    tableHead() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(10.0) //
              ),
        ),
        height: _dimensions.heightPercent(6),
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

    tableBuilder() {
      List<Widget> transactionList = <Widget>[];
      for (int i = 0; i < filteredTransactions.length; i++) {
        transactionList.add(
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
                  child:
                      Text("dsds", style: _textStyles.billTableContentStyle()),
                  constraints: BoxConstraints(
                    maxWidth: _dimensions.widthPercent(7.5),
                    minWidth: _dimensions.widthPercent(7.5),
                  ),
                ),
                SizedBox(width: _dimensions.widthPercent(20)),
                Container(
                  child:
                      Text("dssd", style: _textStyles.billTableContentStyle()),
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
                    ),
                    SizedBox(width: _dimensions.widthPercent(3)),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: _dimensions.widthPercent(3),
                        minWidth: _dimensions.widthPercent(3),
                      ),
                      child: Text("ssd",
                          style: _textStyles.billTableContentStyle()),
                    ),
                    SizedBox(width: _dimensions.widthPercent(8)),
                  ],
                ),
                Container(
                    constraints: BoxConstraints(
                      maxWidth: _dimensions.widthPercent(15),
                      minWidth: _dimensions.widthPercent(7.5),
                    ),
                    child: Text("dsdsdsddsd",
                        style: _textStyles.billTableContentStyle()))
              ],
            ),
          ),
        );
      }
      return transactionList;
    }

    rightBody() => selectedClient == null
        ? Expanded(flex: 2, child: Center(child: Text("no item selected")))
        : Expanded(
            flex: 2,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(width: 200, height: 200, child: addPhoto()),
                SizedBox(
                  height: 15,
                ),
                Center(
                    child: Text(
                  selectedClient.name,
                  style: TextStyles(context: context).clientTableContentStyle(),
                )),
                SizedBox(
                  height: 15,
                ),
                //header("الوصف"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        // dialogue(context, "سحب", () {
                        //   print("سحب");
                        // });
                      },
                      child: Text("سحب"),
                    ),
                    RaisedButton(
                      onPressed: () {
                        // dialogue(context, "ايداع", () {
                        //   print("ايداع");
                        // });
                      },
                      child: Text("ايداع"),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                tableHead(),
                Column(children: tableBuilder()),
              ],
            ),
          );

    body() {
      return Row(
        children: [
          leftBody(),
          rightBody(),
          SizedBox(
            width: 20,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("العملاء"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: body(),
      ),
    );
  }
}
