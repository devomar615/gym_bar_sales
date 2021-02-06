import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:provider/provider.dart';

class CollapsedPanel extends StatelessWidget {
  final pc;

  const CollapsedPanel({Key key, this.pc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dimensions _dimensions = Dimensions(context);
    TextStyles _textStyles = TextStyles(context: context);

    BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(_dimensions.heightPercent(3)),
        topRight: Radius.circular(_dimensions.heightPercent(3)));

    var productModel = Provider.of<ProductModel>(context);

    List<Product> selectedList = productModel.getSelectedProducts();

    changePanelState() {
      if (selectedList.isEmpty || selectedList.length <= 0) {
        print("no product selected to open the pill");
      }
      if (selectedList.length > 0) {
        // if (_pc.isPanelOpen) _pc.close();
        if (pc.isPanelClosed) pc.open();
      }
    }

    return GestureDetector(
      onTap: () => changePanelState(),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
        child: Center(
          child: Text("الفاتوره", style: _textStyles.billTitleStyle()),
        ),
      ),
    );
  }
}
