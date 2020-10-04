import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/ui/views/bill.dart';
import 'package:gym_bar_sales/ui/views/more/add_product.dart';
import 'package:gym_bar_sales/ui/views/more/clients/all_clients.dart';
import 'package:gym_bar_sales/ui/views/more/clients/client_profile.dart';
import 'package:gym_bar_sales/ui/views/more/clients/clients.dart';
import 'package:gym_bar_sales/ui/views/more/clients/filtered_clients.dart';
import 'package:gym_bar_sales/ui/views/more/logout.dart';
import 'package:gym_bar_sales/ui/views/more/more.dart';
import 'package:gym_bar_sales/ui/views/more/report.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Bill());
      case '/more':
        return MaterialPageRoute(builder: (_) => More());
      case '/logout':
        return MaterialPageRoute(builder: (_) => Logout());
      case '/add_product':
        return MaterialPageRoute(builder: (_) => AddProduct());
      case '/report':
        return MaterialPageRoute(builder: (_) => Report());

      case '/clients':
        var branch = settings.arguments;
        return MaterialPageRoute(builder: (_) => Clients());

      case '/all_clients':
        var branch = settings.arguments;
        return MaterialPageRoute(builder: (_) => AllClients(branchName: branch));

      case '/filtered_clients':
        List<String> args = settings.arguments;
        return MaterialPageRoute(builder: (_) => FilteredClients(args: args));

      case '/client_profile':
        Client clients = settings.arguments;
        return MaterialPageRoute(builder: (_) => ClientProfile(client: clients));

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
