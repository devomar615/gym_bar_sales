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

File file;

class OneClientInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ClientModel clientModel = Provider.of<ClientModel>(context);

    Client selectedClient = clientModel.selectedClient;

    FormWidget _formWidget = FormWidget(context: context);
    Dimensions _dimensions = Dimensions(context);
    TextStyles _textStyles = TextStyles(context: context);

    var transactionModel = Provider.of<TransactionModel>(context);

    var filteredTransactions = transactionModel.filteredTransactions;

    onTapTransaction(String type) => showDialog<void>(
          context: context,
          barrierDismissible: true,
          // false = user must tap button, true = tap outside dialog
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(type),
              content: TextField(
                onChanged: (value) {},
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
      return transactionModel.status == Status.Busy
          ? Center(child: Text("Loading..."))
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
                            child: Text(filteredTransactions[index].date,
                                style: _textStyles.billTableContentStyle()),
                            constraints: BoxConstraints(
                              maxWidth: _dimensions.widthPercent(10),
                              minWidth: _dimensions.widthPercent(10),
                            ),
                          ),
                          SizedBox(width: _dimensions.widthPercent(7.5)),
                          Container(
                            child: Text(filteredTransactions[index].total,
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
                                child: Text(filteredTransactions[index].paid,
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
                                  filteredTransactions[index].transactionType ==
                                          "selling"
                                      ? filteredTransactions[index]
                                          .buyingProduct
                                      : filteredTransactions[index]
                                          .transactionType,
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

    return selectedClient == null || filteredTransactions == null
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
                Expanded(child: tableBuilder()),
              ],
            ),
          );
  }
}
