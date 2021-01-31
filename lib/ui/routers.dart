import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/views/home.dart';
import 'package:gym_bar_sales/ui/views/more/add_product.dart';
import 'package:gym_bar_sales/ui/views/more/clients.dart';
import 'package:gym_bar_sales/ui/views/more/logout.dart';
import 'package:gym_bar_sales/ui/views/more/more.dart';
import 'package:gym_bar_sales/ui/views/more/report.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/more':
        return MaterialPageRoute(builder: (_) => More());
      case '/logout':
        return MaterialPageRoute(builder: (_) => Logout());
      case '/add_product':
        return MaterialPageRoute(builder: (_) => AddProduct());
      case '/report':
        return MaterialPageRoute(builder: (_) => Report());
      case '/clients':
        return MaterialPageRoute(builder: (_) => Clients());

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
