import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/services/bill_services.dart';
import 'package:gym_bar_sales/core/services/home_services.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

class PanelBillDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // double totalBill = 0;

    TextStyles _textStyles = TextStyles(context: context);
    Dimensions _dimensions = Dimensions(context);

    BillServices billServices = Provider.of<BillServices>(context);
    HomeServices homeServices = Provider.of<HomeServices>(context);
    String selectedBuyerType = billServices.selectedBuyerType;
    double payedAmount = billServices.payedAmount;
    double billChange = billServices.billChange;
    double totalBill = billServices.totalBill;

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
                billServices.payedAmount = double.tryParse(value);
                if (payedAmount == null) billServices.payedAmount = 0;
                billServices.calculateChange();
              },
              decoration: InputDecoration(labelText: 'اكتب المبلغ هنا'),
              keyboardType: TextInputType.number,
              maxLength: 3,
              maxLengthEnforced: true,
            ),
            actions: <Widget>[
              TextButton(
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
                  if (selectedBuyerType != "House" && homeServices.transactionType != "شراء") {
                    _changePayAmountDialog();
                  }
                  if (selectedBuyerType == "House" || homeServices.transactionType == "شراء") {
                    print("house pay must be equal to total bill");
                  }
                },
                child: Text(payedAmount.toString(), style: _textStyles.billInfoStyle())),
            SizedBox(width: _dimensions.widthPercent(3)),
            Text('المدفوع', style: _textStyles.billInfoStyle()),
            SizedBox(width: _dimensions.widthPercent(2.5)),
          ],
        ),
        SizedBox(height: _dimensions.heightPercent(2)),
        selectedBuyerType == "House" || homeServices.transactionType == "شراء"
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
                        borderRadius: BorderRadius.circular(_dimensions.heightPercent(1)),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: _dimensions.heightPercent(1.5)),
                          Text('الباقي: ' + billChange.toString(), style: _textStyles.billCustomInfoStyle(billChange)),
                          SizedBox(width: _dimensions.widthPercent(12), height: _dimensions.heightPercent(1))
                        ],
                      )),
                  SizedBox(width: _dimensions.widthPercent(2.5)),
                ],
              ),
      ],
    );
  }
}
