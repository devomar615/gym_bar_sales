import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/core/view_models/total_model.dart';
import 'package:gym_bar_sales/core/view_models/transaction_model.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/views/home.dart';
import 'package:gym_bar_sales/ui/widgets/panel/collapsed_panel.dart';
import 'package:gym_bar_sales/ui/widgets/panel/panel_bill_checkout.dart';
import 'package:gym_bar_sales/ui/widgets/panel/panel_bill_details.dart';
import 'package:gym_bar_sales/ui/widgets/panel/panel_bill_table.dart';
import 'package:gym_bar_sales/ui/widgets/panel/panel_buyer_selection.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gym_bar_sales/core/view_models/client_model.dart';
import 'package:gym_bar_sales/core/view_models/employee_model.dart';

class Panel extends StatefulWidget {
  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  final PanelController _pc = PanelController();

  Timer timer;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      String branch = context.read<String>();
      print(branch);
      Provider.of<EmployeeModel>(context).fetchEmployees(branchName: branch);
      Provider.of<ClientModel>(context).fetchClients(branchName: branch);
      Provider.of<TotalModel>(context).fetchTotal();
      Provider.of<TransactionModel>(context)
          .fetchTransaction(branchName: branch);
      Provider.of<CategoryModel>(context).fetchCategories();
      Provider.of<ProductModel>(context).fetchProducts(branchName: branch);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions _dimensions = Dimensions(context);
    var productModel = Provider.of<ProductModel>(context);
    BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(_dimensions.heightPercent(3)),
        topRight: Radius.circular(_dimensions.heightPercent(3)));
    return Scaffold(
      body: productModel.status == Status.Busy
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SlidingUpPanel(
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
                panelBuilder: (sc) => MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    controller: sc,
                    children: [
                      Column(
                        mainAxisSize:
                            MainAxisSize.min, // Use children total size
                        children: [
                          PanelBuyerSelection(panelController: _pc),
                          PanelBillTable(panelController: _pc),
                          PanelBillDetails(),
                          PanelBillCheckout(),
                        ],
                      ),
                    ],
                  ),
                ),
                collapsed: CollapsedPanel(pc: _pc),
                body: GestureDetector(
                  onTap: () {
                    if (_pc.isPanelOpen) {
                      FocusScope.of(context).unfocus();
                      _pc.close();
                    }
                  },
                  child: Home(),
                ),
              ),
            ),
    );
  }
}
