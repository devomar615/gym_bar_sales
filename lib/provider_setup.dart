import 'package:gym_bar_sales/core/services/bill_services.dart';
import 'package:gym_bar_sales/core/services/home_services.dart';
import 'package:gym_bar_sales/core/view_models/client_model.dart';
import 'package:gym_bar_sales/core/view_models/employee_model.dart';
import 'package:gym_bar_sales/core/view_models/product_model.dart';
import 'package:gym_bar_sales/core/view_models/total_model.dart';
import 'package:gym_bar_sales/core/view_models/transaction_model.dart';
import 'package:provider/provider.dart';
import 'core/view_models/category_model.dart';

final String _branch = "فرع القرية الذكية";

var providers = [
  Provider(create: (_) => _branch),
  ChangeNotifierProvider(create: (_) => CategoryModel()),
  ChangeNotifierProvider(create: (_) => ProductModel()),
  ChangeNotifierProvider(create: (_) => EmployeeModel()),
  ChangeNotifierProvider(create: (_) => ClientModel()),
  ChangeNotifierProvider(create: (_) => TransactionModel()),
  ChangeNotifierProvider(create: (_) => TotalModel()),
  ChangeNotifierProvider(create: (_) => BillServices()),
  ChangeNotifierProvider(create: (_) => HomeServices()),
];
