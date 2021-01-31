import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/views/home.dart';
import 'package:gym_bar_sales/ui/widgets/panel/panel_body.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/view_models/client_model.dart';
import 'package:gym_bar_sales/core/view_models/employee_model.dart';

class Panel extends StatefulWidget {
  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  final PanelController _pc = PanelController();

  Timer timer;
  var branch = "بيفرلي";
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ProductModel>(context).fetchProducts(branchName: branch);
      Provider.of<EmployeeModel>(context).fetchEmployees(branchName: branch);
      Provider.of<ClientModel>(context).fetchClients(branchName: branch);
      Provider.of<CategoryModel>(context).fetchCategories().then((_) {});
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
        if (_pc.isPanelClosed) _pc.open();
      }
    }

    var isLoading = false;
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SlidingUpPanel(
                controller: _pc,
                maxHeight: _dimensions.heightPercent(85),
                minHeight: _dimensions.heightPercent(13),
                // panelSnapping: false,
                // onPanelOpened: () {},
                // onPanelClosed: onPanelClosed(),
                // parallaxEnabled: true,
                isDraggable: false,
                // backdropEnabled: true,
                backdropOpacity: 0.3,
                borderRadius: radius,
                panelBuilder: (sc) => PanelBody(
                      sc: sc,
                      pc: _pc,
                    ),
                collapsed: GestureDetector(
                  onTap: () => changePanelState(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: radius),
                    child: Center(
                      child:
                          Text("الفاتوره", style: _textStyles.billTitleStyle()),
                    ),
                  ),
                ),
                body: GestureDetector(
                  onTap: () {
                    if (_pc.isPanelOpen) {
                      FocusScope.of(context).unfocus();
                      _pc.close();
                    }
                  },
                  child: Home(),
                )),
          );
  }
}
