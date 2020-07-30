import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gym_bar_sales/core/locator.dart';
import 'package:gym_bar_sales/ui/routers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'core/view_models/product_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  permission() async => await Permission.storage.request();

  permission();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(MyApp());
  setupLocator();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ProductModel())],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          title: 'Gym Bar',
          theme: ThemeData(fontFamily: 'Tajawal'),
          onGenerateRoute: Routers.generateRoute,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        ));
  }
}
