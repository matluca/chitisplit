import 'package:flutter/material.dart';
import 'package:chitisplit/pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppChiTiSplit();
  }
}

class AppChiTiSplit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => Home(),
      },
    );
  }
}
