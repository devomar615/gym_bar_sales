import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_bar_sales/provider_setup.dart';
import 'package:gym_bar_sales/ui/routers.dart';
import 'package:gym_bar_sales/ui/views/panel.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: providers,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // initialRoute: '/',
          title: 'Gym Bar',
          theme: ThemeData(fontFamily: 'Tajawal'),
          home: Panel(),
          onGenerateRoute: Routers.generateRoute,
        ));
  }
}
