import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:muvin/src/pages/home_page.dart';
import 'package:muvin/src/pages/peliculaDetalle.dart';

void main() async => {
      WidgetsFlutterBinding.ensureInitialized(),

      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]),

      runApp(MyApp()) // To turn off landscape mode
    };

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(
              subtitle1:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      debugShowCheckedModeBanner: false,
      title: 'Muvin',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => PeliculaDetalle()
      },
    );
  }
}
