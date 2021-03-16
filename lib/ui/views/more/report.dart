import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';

class Report extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Dimensions _dimensions = Dimensions(context);
    TextStyles _textStyles = TextStyles(context: context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: Text("report"))],
      ),
    );
  }
}
