import 'package:gym_bar_sales/core/services/bill_services.dart';
import 'package:gym_bar_sales/core/services/home_services.dart';
import 'package:gym_bar_sales/core/view_models/client_model.dart';
import 'package:gym_bar_sales/core/view_models/employee_model.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/core/view_models/total_model.dart';
import 'package:gym_bar_sales/core/view_models/transaction_model.dart';
import 'package:provider/provider.dart';
import 'core/view_models/category_model.dart';

final String branch = "بيفرلي";

var providers = [
  // ChangeNotifierProvider(
  //   create: (_) => Auth(),
  // ),

  Provider(create: (_) => branch),
  ChangeNotifierProvider(create: (_) => CategoryModel()),
  ChangeNotifierProvider(create: (_) => ProductModel()),
  ChangeNotifierProvider(create: (_) => EmployeeModel()),
  ChangeNotifierProvider(create: (_) => ClientModel()),
  ChangeNotifierProvider(create: (_) => TransactionModel()),
  ChangeNotifierProvider(create: (_) => TotalModel()),
  ChangeNotifierProvider(create: (_) => BillServices()),
  ChangeNotifierProvider(create: (_) => HomeServices()),

  // ChangeNotifierProxyProvider<Auth, ProductsViewModel>(
  //   create: null,
  //   update: (ctx, auth, previousProducts) => ProductsViewModel(
  //     auth.token,
  //     auth.userId,
  //     previousProducts == null ? [] : previousProducts.items,
  //   ),
  // ),

  // ChangeNotifierProvider(
  //   create: (_) => Cart(),
  // ),

  // ChangeNotifierProxyProvider<Auth, Orders>(
  //   create: null,
  //   update: (ctx, auth, previousOrders) => Orders(
  //     auth.token,
  //     auth.userId,
  //     previousOrders == null ? [] : previousOrders.orders,
  //   ),
  // ),

];
