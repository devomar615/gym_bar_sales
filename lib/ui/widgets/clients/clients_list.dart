import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/view_models/client_model.dart';
import 'package:gym_bar_sales/core/view_models/transaction_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/widgets/clients/one_client_info.dart';
import 'package:provider/provider.dart';

SortSelection selectedSort;
File file;

class ClientsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TransactionModel transactionModel = Provider.of<TransactionModel>(context, listen: false);
    String branchName = context.read<String>();


    ClientModel clientModel = Provider.of<ClientModel>(context);
    // BranchModel branchModel = Provider.of<BranchModel>(context);

    String selectedClientType = clientModel.selectedClientType;
    // print("filtering");
    // List<Client> filteredClients = clientModel.filterClients(
    //     selectedClientType: selectedClientType, liveClients: _liveClients);

    Dimensions _dimensions = Dimensions(context);
    TextStyles _textStyles = TextStyles(context: context);

    void fetchTransaction() {
      var customerName = clientModel.selectedClient.name;
      // print("tapping clienttt");
      // print(customerName);
      transactionModel.fetchTransactionByCustomerName(branchName: branchName, customerName: customerName);
    }

    Widget popUpSortSelection(List<Client> _liveClients) => PopupMenuButton<SortSelection>(
        icon: Icon(
          Icons.sort,
          size: _dimensions.widthPercent(3.5),
        ),
        onSelected: (SortSelection selectedSort) {
          if (selectedSort == SortSelection.sortByName) {
            clientModel.onSortName(_liveClients);
          }
          if (selectedSort == SortSelection.sortByCash) {
            clientModel.onSortCash(_liveClients);
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
          padding:
              EdgeInsets.symmetric(horizontal: _dimensions.widthPercent(2), vertical: _dimensions.widthPercent(0.4)),
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
          padding:
              EdgeInsets.symmetric(horizontal: _dimensions.widthPercent(2), vertical: _dimensions.widthPercent(0.4)),
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
          padding:
              EdgeInsets.symmetric(horizontal: _dimensions.widthPercent(2), vertical: _dimensions.widthPercent(0.4)),
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
      return Consumer<List<Client>>(
        builder: (_, clients, __) {
          var filteredClients = clientModel.filterClients(selectedClientType: selectedClientType, liveClients: clients);
          return clients == null
              ? Center(child: CircularProgressIndicator())
              : filteredClients.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: _dimensions.widthPercent(3)),
                      child: Center(
                        child: Text(
                          "لا يوجد عملاء هنا اضغط الزر السفلي لاضافة اول عميل",
                          style: _textStyles.warningStyle(),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: _dimensions.widthPercent(2),
                            ),
                            popUpSortSelection(clients),
                          ],
                        ),
                        SizedBox(height: _dimensions.heightPercent(1.5)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredClients.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: _dimensions.heightPercent(0.4), horizontal: _dimensions.widthPercent(1)),
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(_dimensions.heightPercent(1)),
                                  ),
                                  child: ListTileTheme(
                                    // contentPadding: EdgeInsets.only(top: _dimensions.heightPercent(2)),
                                    selectedColor: filteredClients[index].type == 'دائن' ? Colors.red : Colors.blue,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.account_circle,
                                        size: _dimensions.widthPercent(4),
                                      ),
                                      title: Text(
                                        filteredClients[index].name,
                                        style: _textStyles.listTileTitleStyle(),
                                      ),
                                      subtitle: Text(clients[index].cash,
                                          style: _textStyles.listTileSubtitleStyle(clients[index].type)),
                                      selected: clientModel.selectedClient == null
                                          ? false
                                          : filteredClients[index].id == clientModel.selectedClient.id,
                                      onTap: () {
                                        clientModel.selectedClient = filteredClients[index];
                                        if (clientModel.selectedClient == null) {
                                          clientModel.selectedClient = filteredClients[index];
                                          fetchTransaction();
                                        } else if (filteredClients[index].id == clientModel.selectedClient.id) {
                                          fetchTransaction();
                                        } else {
                                          clientModel.selectedClient = filteredClients[index];
                                          fetchTransaction();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
        },
      );
    }

    return StreamProvider<List<Client>>(
      create: (_) => ClientModel().fetchClientStream(branchName: branchName),
      initialData: null,
      child: Expanded(
        child: Column(
          children: [
            SizedBox(height: _dimensions.heightPercent(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: clientTypeChoices(),
            ),
            SizedBox(height: _dimensions.heightPercent(1)),
            Expanded(child: Container(height: _dimensions.widthPercent(50), child: clientsList())),
          ],
        ),
      ),
    );
  }
}
