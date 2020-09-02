import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_bar_sales/core/locator.dart';
import 'package:gym_bar_sales/ui/routers.dart';
import 'package:provider/provider.dart';
import 'core/view_models/product_model.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ));
  }
}
