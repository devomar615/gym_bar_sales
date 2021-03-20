import 'dart:io';
import 'package:flutter/foundation.dart';
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
var transactorName = "عمر";

class OneClientInfo extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyles _textStyles = TextStyles(context: context);
    Dimensions _dimensions = Dimensions(context);
    FormWidget _formWidget = FormWidget(context: context);

    String branchName = context.read<String>();


    TotalModel totalModel = Provider.of<TotalModel>(context, listen: false);
    ClientModel clientModel = Provider.of<ClientModel>(context);
    TransactionModel transactionModel = Provider.of<TransactionModel>(context);

    // List<Total> total = totalModel.total;
    // List<MyTransaction> filteredTransactions = transactionModel.filteredTransactions;

    Client selectedClient = clientModel.selectedClient;
    var filteredTransactions = transactionModel.filteredTransactions;
    // var branchName = Provider.of<BranchModel>(context).selectedBranch;

    transaction(type) {
      transactionModel.addTransaction(
          branchName: branchName,
          transaction: MyTransaction(
            transactorName: transactorName,
            transactionType: type,
            transactionAmount: clientModel.cashToAdd.text,
            customerName: selectedClient.name,
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            hour: DateFormat('h:mm a').format(DateTime.now()),
            branch: branchName,
          ));
    }

    updateTreasury({String transactionType}) async {
      Total total = await totalModel.fetchTotal(branchName);
      print("printing cash... ${total.cash}");
      double currentCash = double.parse(total.cash);
      print("printing cash...again");
      print(currentCash);
      print("${clientModel.cashToAdd.text}");

      double updatedCash = transactionType == "ايداع"
          ? currentCash + double.tryParse(clientModel.cashToAdd.text)
          : currentCash - double.tryParse(clientModel.cashToAdd.text);

      print("updated cash " + updatedCash.toString());
      totalModel.updateTotal(docId: branchName, total: Total(cash: updatedCash.toString()));
    }

    updateClientCash({String transactionType}) async {
      double currentCash;
      await clientModel.fetchClientById(branchName: branchName, id: selectedClient.id).then((client) {
        currentCash = double.tryParse(client.cash);
        print("current cash for ${client.name} is: ${currentCash.toString()}");

        double updatedCash = transactionType == "ايداع"
            ? currentCash + double.tryParse(clientModel.cashToAdd.text)
            : currentCash - double.tryParse(clientModel.cashToAdd.text);

        String updatedType;

        if (updatedCash == 0) updatedType = "خالص";
        if (updatedCash < 0) updatedType = "دائن";
        if (updatedCash > 0) updatedType = "مدين";

        clientModel.updateClient(
            branchName: branchName,
            clientId: selectedClient.id,
            data: {'cash': updatedCash.toString(), 'type': updatedType});
      });
    }

    onTapTransaction(String type) => showDialog<void>(
          context: context,
          barrierDismissible: true,
          // false = user must tap button, true = tap outside dialog
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(type),
              content: Form(
                  key: _formKey,
                  child: _formWidget.formTextFieldTemplate(
                    controller: clientModel.cashToAdd,
                    border: false,
                    hint: 'اكتب المبلغ هنا',
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('اتمام'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    try {
                      // Dismiss alert dialog
                      if (_formKey.currentState.validate()) {
                        updateClientCash(transactionType: type);
                        transaction(type);
                        updateTreasury(transactionType: type);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('العملية تمت بنجاح'),
                          ),
                        );
                      }
                    } catch (err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(err.toString()),
                        ),
                      );
                    }
                  },
                ),
                TextButton(
                  child: Text('الغاء'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    clientModel.clear();
                  },
                ),
              ],
            );
          },
        );

    Widget transactionChoices(String type) {
      return GestureDetector(
        onTap: () {
          clientModel.clear();
          onTapTransaction(type);
        },
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_dimensions.heightPercent(3)),
            child: Image.asset(
                type == "ايداع"
                    ? 'assets/images/employee_clients/deposit.png'
                    : 'assets/images/employee_clients/withdraw.png',
                width: _dimensions.widthPercent(7),
                height: _dimensions.widthPercent(7)),
          ),
        ),
      );
    }

    Widget addPhoto() {
      if (file == null) {
        return _formWidget.logo(
            imageContent: Image.asset("assets/images/employee_clients/default_profile.jpg", fit: BoxFit.cover),
            backgroundColor: Colors.white);
      } else
        return _formWidget.logo(imageContent: Image.file(file, fit: BoxFit.cover));
    }

    tableHead() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(_dimensions.widthPercent(1)) //
              ),
        ),
        height: _dimensions.heightPercent(kIsWeb ? 8 : 6),
        // color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  // transactionModel.changeAmountAscendingState();
                  transactionModel.onSortAmount();
                },
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("القيمة", style: _textStyles.billTableTitleStyle()),
                    // SizedBox(width: _dimensions.widthPercent(3)),
                    Icon(
                      transactionModel.sortAmountIcon,
                      size: _dimensions.widthPercent(3.5),
                    )
                  ],
                ))),
            GestureDetector(
                onTap: () {
                  // transactionModel.changeHourAscendingState();
                  transactionModel.onSortHour();
                },
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("الساعة", style: _textStyles.billTableTitleStyle()),
                    // SizedBox(width: _dimensions.widthPercent(3)),
                    Icon(
                      transactionModel.sortHourIcon,
                      size: _dimensions.widthPercent(3.5),
                    )
                  ],
                ))),
            GestureDetector(
                onTap: () {
                  // transactionModel.changeHourAscendingState();
                  transactionModel.onSortDate();
                },
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("التاريخ", style: _textStyles.billTableTitleStyle()),
                    // SizedBox(width: _dimensions.widthPercent(3)),
                    Icon(
                      transactionModel.sortDateIcon,
                      size: _dimensions.widthPercent(3.5),
                    )
                  ],
                ))),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("النوع", style: _textStyles.billTableTitleStyle()),
                // SizedBox(width: _dimensions.widthPercent(3)),
                Icon(
                  Icons.add,
                  color: Colors.transparent,
                  size: _dimensions.widthPercent(3.5),
                )
              ],
            )),
          ],
        ),
      );
    }

    tableBuilder() {
      return filteredTransactions == null
          ? Center(child: CircularProgressIndicator())
          : filteredTransactions.isEmpty
              ? Center(
                  child: Text(
                    "لا يوجد عمليات ",
                    style: _textStyles.warningStyle(),
                  ),
                )
              : ListView.builder(
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
                                child: Text(filteredTransactions[index].transactionAmount,
                                    style: _textStyles.billTableContentStyle()),
                                constraints: BoxConstraints(
                                  maxWidth: _dimensions.widthPercent(10),
                                  minWidth: _dimensions.widthPercent(10),
                                ),
                              ),
                              SizedBox(width: _dimensions.widthPercent(7.5)),
                              Container(
                                child:
                                    Text(filteredTransactions[index].hour, style: _textStyles.billTableContentStyle()),
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
                                    child: Text(filteredTransactions[index].date,
                                        style: _textStyles.billTableContentStyle()),
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
                                      filteredTransactions[index].transactionType == "selling"
                                          ? "بيع"
                                          : filteredTransactions[index].transactionType == "buying"
                                              ? "شراء"
                                              : filteredTransactions[index].transactionType,
                                      style: _textStyles.billTableContentStyle())),
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
                Container(width: _dimensions.widthPercent(12), height: _dimensions.widthPercent(12), child: addPhoto()),
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
                Container(height: _dimensions.heightPercent(40), child: tableBuilder()),
                // Expanded(child: tableBuilder()),
              ],
            ),
          );
  }
}
