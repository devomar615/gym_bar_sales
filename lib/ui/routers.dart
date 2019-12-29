import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/views/details/branches/branches.dart';
import 'package:gym_bar_sales/ui/views/details/clients/clients.dart';
import 'package:gym_bar_sales/ui/views/details/products/categories.dart';
import 'package:gym_bar_sales/ui/views/home.dart';
import 'package:gym_bar_sales/ui/views/registeration/login.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/clients':
        return MaterialPageRoute(builder: (_) => Clients());
      case '/branches':
        return MaterialPageRoute(builder: (_) => Branches());
      case '/categories':
        return MaterialPageRoute(builder: (_) => Categories());
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
