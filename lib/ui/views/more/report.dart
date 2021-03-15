import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/models/employee.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:search_choices/search_choices.dart';

class Report extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Dimensions _dimensions = Dimensions(context);
    TextStyles _textStyles = TextStyles(context: context);



    Widget search(List<Client>clients, List<Employee>employees){
      List<>
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Center(
            child: Container(
              height: 200,
              width: 400,
              child: SearchChoices.single(
                dialogBox: false,
                isExpanded: true,
                menuConstraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
                items: ["طنجة", "فاس‎", "أكادير‎", "تزنيت‎", "آكــلــو", "سيدي بيبي"]
                    .map<DropdownMenuItem<String>>((string) {
                  return (DropdownMenuItem<String>(
                    child: Text(
                      string,
                      textDirection: TextDirection.rtl,
                    ),
                    value: string,
                  ));
                }).toList(),
                value: () {},
                hint: Text(
                  "ختار",
                  textDirection: TextDirection.rtl,
                ),
                searchHint: Text(
                  "ختار",
                  textDirection: TextDirection.rtl,
                ),
                closeButton: TextButton(
                  onPressed: () {},
                  child: Text(
                    "سدّ",
                    textDirection: TextDirection.rtl,
                  ),
                ),
                onChanged: (value) {},
                // isExpanded: true,
                rightToLeft: true,

                displayItem: (item, selected) {
                  return (Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      selected
                          ? Icon(
                              Icons.radio_button_checked,
                              color: Colors.grey,
                            )
                          : Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.grey,
                            ),
                      SizedBox(width: 7),
                      item,
                      // Expanded(child: SizedBox.shrink()),
                    ],
                  ));
                },
                selectedValueWidgetFn: (item) {
                  return Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      (Text(
                        item,
                        textDirection: TextDirection.rtl,
                      )),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
