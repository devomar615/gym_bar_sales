import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/view_models/client_model.dart';
import 'package:gym_bar_sales/core/view_models/transaction_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:provider/provider.dart';

SortSelection selectedSort;
File file;
var branch = "بيفرلي";

class ClientsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ClientModel clientModel = Provider.of<ClientModel>(context);

    String selectedClientType = clientModel.selectedClientType;

    List<Client> filteredClients =
        clientModel.filterClients(selectedClientType);

    Client selectedClient = clientModel.selectedClient;

    Dimensions _dimensions = Dimensions(context);
    TextStyles _textStyles = TextStyles(context: context);

    bool nameAscending = clientModel.nameAscending;
    bool cashAscending = clientModel.cashAscending;

    var transactionModel = Provider.of<TransactionModel>(context);

    void fetchTransaction() {
      var customerName = clientModel.selectedClient.name;
      transactionModel.fetchTransactionByCustomerName(
          branchName: "بيفرلي", customerName: customerName);
      // transactionModel.getTransactionByCustomerName(selectedClient.name);
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
          size: _dimensions.widthPercent(3),
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
              horizontal: _dimensions.widthPercent(2),
              vertical: _dimensions.widthPercent(0.4)),
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
              horizontal: _dimensions.widthPercent(2),
              vertical: _dimensions.widthPercent(0.4)),
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
              horizontal: _dimensions.widthPercent(2),
              vertical: _dimensions.widthPercent(0.4)),
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
      return StreamBuilder(
        stream: clientModel.fetchClientStream(branchName: branch),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Loading");
          }

          List<Client> liveClient;
          if (snapshot.hasData) {
            liveClient = snapshot.data.docs
                .map<Client>((DocumentSnapshot document) =>
                    Client.fromMap(document.data(), document.id))
                .toList();
          }

          return snapshot.hasData
              ? ListView.builder(
                  itemCount: filteredClients.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: _dimensions.widthPercent(0.4),
                          horizontal: _dimensions.widthPercent(1)),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              _dimensions.widthPercent(1)),
                        ),
                        child: ListTileTheme(
                          selectedColor: liveClient
                                      .firstWhere((element) =>
                                          element.id ==
                                          filteredClients[index].id)
                                      .type ==
                                  'دائن'
                              ? Colors.red
                              : Colors.blue,
                          child: ListTile(
                            leading: Icon(
                              Icons.account_circle,
                              size: _dimensions.widthPercent(4),
                            ),
                            title: Text(filteredClients[index].name),
                            subtitle: Text(
                                liveClient
                                    .firstWhere((element) =>
                                        element.id == filteredClients[index].id)
                                    .cash,
                                style: TextStyle(
                                    color: liveClient
                                                .firstWhere((element) =>
                                                    element.id ==
                                                    filteredClients[index].id)
                                                .type ==
                                            'دائن'
                                        ? Colors.red
                                        : Colors.green)),
                            selected: selectedClient == null
                                ? false
                                : filteredClients[index].id ==
                                    selectedClient.id,
                            onTap: () {
                              if (selectedClient == null) {
                                clientModel.selectedClient =
                                    filteredClients[index];
                                fetchTransaction();
                              } else if (filteredClients[index].id ==
                                  selectedClient.id) {
                                // clientModel.selectedClient = null;
                              } else {
                                clientModel.selectedClient =
                                    filteredClients[index];
                                fetchTransaction();
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      );
    }

    return Expanded(
      child: Column(
        children: [
          SizedBox(height: _dimensions.heightPercent(3)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: clientTypeChoices(),
          ),
          SizedBox(height: _dimensions.heightPercent(1)),
          Row(
            children: [
              SizedBox(
                width: _dimensions.widthPercent(2),
              ),
              popUpSortSelection(),
            ],
          ),
          Expanded(
              child: Container(
                  height: _dimensions.widthPercent(50), child: clientsList())),
        ],
      ),
    );
  }
}
