import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/views/more/clients.dart';
import 'package:gym_bar_sales/ui/views/more/logout.dart';
import 'package:gym_bar_sales/ui/views/more/report.dart';
import 'package:gym_bar_sales/ui/views/panel.dart';
import 'package:gym_bar_sales/ui/views/settings.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Panel());
      case '/logout':
        return MaterialPageRoute(builder: (_) => Logout());
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings());
      case '/report':
        return MaterialPageRoute(builder: (_) => Report());
      case '/clients':
        return MaterialPageRoute(builder: (_) => Clients());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
