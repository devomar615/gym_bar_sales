import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/views/Add/add_bill.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AddBill());
//      case '/clients':
//        return MaterialPageRoute(builder:   (_) => Clients());
//      case '/branches':
//        return MaterialPageRoute(builder: (_) => Branches());
//      case '/categories':
//        var branch = settings.arguments;
//        return MaterialPageRoute(
//            builder: (_) => Categories(branchName: branch));

//      case '/products':
//        List<String> args = settings.arguments;
//        return MaterialPageRoute(builder: (_) => Products(args: args));
//      case '/TransactionView':
//        Map productDetails = settings.arguments;
//        return MaterialPageRoute(builder: (_) => TransactionView(productDetails: productDetails));
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
