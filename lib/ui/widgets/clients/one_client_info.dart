import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/models/my_transaction.dart';
import 'package:gym_bar_sales/core/models/total.dart';
import 'package:gym_bar_sales/core/view_models/client_model.dart';
import 'package:gym_bar_sales/core/view_models/total_model.dart';
import 'package:gym_bar_sales/core/view_models/transaction_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

File file;
var branch = "بيفرلي";
var transactorName = "عمر";

class OneClientInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ClientModel clientModel = Provider.of<ClientModel>(context);
    TotalModel totalModel = Provider.of<TotalModel>(context, listen: false);

    Client selectedClient = clientModel.selectedClient;
    List<Total> total = totalModel.total;

    FormWidget _formWidget = FormWidget(context: context);
    Dimensions _dimensions = Dimensions(context);
    TextStyles _textStyles = TextStyles(context: context);

    var transactionModel = Provider.of<TransactionModel>(context);

    // var filteredTransactions = transactionModel.filteredTransactions;

    transaction(type) {
      transactionModel.addTransaction(
          branchName: branch,
          transaction: MyTransaction(
            transactorName: transactorName,
            transactionType: type,
            transactionAmount: clientModel.cashToAdd.toString(),
            customerName: selectedClient.name,
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            hour: DateFormat('h:mm a').format(DateTime.now()),
            branch: branch,
          ));
    }

    updateTreasury({String transactionType}) async {
      totalModel.fetchTotal();

      double currentCash = double.parse(total[0].cash);

      double updatedCash = transactionType == "ايداع"
          ? currentCash + clientModel.cashToAdd
          : currentCash - clientModel.cashToAdd;

      totalModel
          .updateTotal(docId: branch, data: {'cash': updatedCash.toString()});
    }

    updateClientCash({String transactionType}) async {
      Client client = await clientModel.fetchClientById(
          branchName: branch, id: selectedClient.id);
      double currentCash = double.parse(client.cash);

      double updatedCash = transactionType == "ايداع"
          ? currentCash + clientModel.cashToAdd
          : currentCash - clientModel.cashToAdd;

      String updatedType;
      if (updatedCash == 0) updatedType = "خالص";
      if (updatedCash < 0) updatedType = "دائن";
      if (updatedCash > 0) updatedType = "مدين";

      clientModel.updateClient(
          branchName: branch,
          clientId: selectedClient.id,
          data: {'cash': updatedCash.toString(), 'type': updatedType});
    }

    onTapTransaction(String type) => showDialog<void>(
          context: context,
          barrierDismissible: true,
          // false = user must tap button, true = tap outside dialog
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(type),
              content: TextField(
                onChanged: (value) {
                  print(value);
                  clientModel.cashToAdd = double.parse(value);
                  print(clientModel.cashToAdd);
                },
                decoration: InputDecoration(labelText: 'اكتب المبلغ هنا'),
                keyboardType: TextInputType.number,
                maxLength: 3,
                maxLengthEnforced: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('اتمام'),
                  onPressed: () {
                    if (clientModel.cashToAdd > 0) {
                      updateClientCash(transactionType: type);
                      transaction(type);
                      updateTreasury(transactionType: type);
                    } else
                      print("cash cannot be null or equal 0");
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
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

    Widget transactionChoices(String type) {
      return GestureDetector(
        onTap: () {
          onTapTransaction(type);
        },
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
                type == "ايداع"
                    ? 'assets/images/deposit.png'
                    : 'assets/images/withdraw.png',
                width: _dimensions.widthPercent(7),
                height: _dimensions.widthPercent(7)),
          ),
        ),
      );
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

    tableHead() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius:
              BorderRadius.all(Radius.circular(_dimensions.widthPercent(1)) //
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
                Text("التاريخ", style: _textStyles.billTableTitleStyle()),
                SizedBox(width: _dimensions.widthPercent(2)),
              ],
            )),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("القيمه", style: _textStyles.billTableTitleStyle()),
                SizedBox(width: _dimensions.widthPercent(2)),
              ],
            )),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("المدفوع", style: _textStyles.billTableTitleStyle()),
                SizedBox(width: _dimensions.widthPercent(2)),
              ],
            )),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("الاسم", style: _textStyles.billTableTitleStyle()),
                SizedBox(width: _dimensions.widthPercent(2)),
              ],
            )),
          ],
        ),
      );
    }

    tableBuilder() {
      return StreamBuilder(
        stream: transactionModel.fetchTransactionStreamByCustomerName(
            branchName: branch, customerName: selectedClient.name),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Loading");
          }

          List<MyTransaction> filteredTransactions;
          if (snapshot.hasData) {
            filteredTransactions = snapshot.data.docs
                .map<MyTransaction>((DocumentSnapshot document) =>
                    MyTransaction.fromMap(document.data(), document.id))
                .toList();
            filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
          }

          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredTransactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            minHeight: _dimensions.heightPercent(5),
                            maxHeight: _dimensions.heightPercent(5),
                          ),
                          child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(width: _dimensions.widthPercent(4)),
                              Container(
                                child: Text(filteredTransactions[index].date,
                                    style: _textStyles.billTableContentStyle()),
                                constraints: BoxConstraints(
                                  maxWidth: _dimensions.widthPercent(10),
                                  minWidth: _dimensions.widthPercent(10),
                                ),
                              ),
                              SizedBox(width: _dimensions.widthPercent(7.5)),
                              Container(
                                child: Text(
                                    filteredTransactions[index]
                                        .transactionAmount,
                                    style: _textStyles.billTableContentStyle()),
                                constraints: BoxConstraints(
                                  maxWidth: _dimensions.widthPercent(10),
                                  minWidth: _dimensions.widthPercent(10),
                                ),
                              ),
                              SizedBox(width: _dimensions.widthPercent(6)),
                              Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: _dimensions.widthPercent(10),
                                      minWidth: _dimensions.widthPercent(10),
                                    ),
                                    child: Text(
                                        filteredTransactions[index].paid,
                                        style: _textStyles
                                            .billTableContentStyle()),
                                  ),
                                  SizedBox(width: _dimensions.widthPercent(7)),
                                ],
                              ),
                              Container(
                                  constraints: BoxConstraints(
                                    maxWidth: _dimensions.widthPercent(10),
                                    minWidth: _dimensions.widthPercent(10),
                                  ),
                                  child: Text(
                                      filteredTransactions[index]
                                                  .transactionType ==
                                              "selling"
                                          ? filteredTransactions[index]
                                              .buyingProducts
                                          : filteredTransactions[index]
                                              .transactionType,
                                      style:
                                          _textStyles.billTableContentStyle())),
                            ],
                          ),
                        ),
                        SizedBox(height: _dimensions.heightPercent(1)),
                        Divider(height: 1, color: Colors.black),
                        SizedBox(height: _dimensions.heightPercent(1)),

                        // Divider(height: 1, color: Colors.black),
                      ],
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      );
    }

    return selectedClient == null
        ? Expanded(
            flex: 2,
            child: Center(
              child: Text("no item selected"),
            ),
          )
        : Expanded(
            flex: 2,
            child: ListView(
              children: <Widget>[
                SizedBox(height: _dimensions.heightPercent(3)),
                Container(
                    width: _dimensions.widthPercent(12),
                    height: _dimensions.widthPercent(12),
                    child: addPhoto()),
                SizedBox(height: _dimensions.heightPercent(2)),
                Center(
                    child: Text(
                  selectedClient.name,
                  style: TextStyles(context: context).clientTableContentStyle(),
                )),
                SizedBox(height: _dimensions.heightPercent(2)),
                //header("الوصف"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        transactionChoices("سحب"),
                        Text(
                          "سحب",
                          style: _textStyles.iconTitle(),
                        )
                      ],
                    ),
                    SizedBox(width: _dimensions.widthPercent(1)),
                    Column(
                      children: [
                        transactionChoices("ايداع"),
                        Text(
                          "ايداع",
                          style: _textStyles.iconTitle(),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: _dimensions.heightPercent(2)),
                tableHead(),
                SizedBox(height: _dimensions.heightPercent(2)),
                tableBuilder(),
              ],
            ),
          );
  }
}
