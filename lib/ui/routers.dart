import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/transaction.dart';
import 'package:gym_bar_sales/ui/views/Add/add_bill.dart';
import 'package:gym_bar_sales/ui/views/details/products/categories.dart';
import 'package:gym_bar_sales/ui/views/details/products/products.dart';
import 'package:gym_bar_sales/ui/views/home.dart';
import 'package:gym_bar_sales/ui/views/registeration/login.dart';
import 'package:gym_bar_sales/ui/views/transaction_view.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AddBill());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
//      case '/clients':
//        return MaterialPageRoute(builder:   (_) => Clients());
//      case '/branches':
//        return MaterialPageRoute(builder: (_) => Branches());
      case '/categories':
        var branch = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => Categories(branchName: branch));

      case '/products':
        List<String> args = settings.arguments;
        return MaterialPageRoute(builder: (_) => Products(args: args));
      case '/TransactionView':
        Map productDetails = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => TransactionView(productDetails: productDetails));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
