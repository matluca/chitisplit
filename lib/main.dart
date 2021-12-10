import 'package:flutter/material.dart';
import 'package:chitisplit/pages/home.dart';
import 'package:chitisplit/pages/add-person-to-group.dart';
import 'package:chitisplit/pages/settings.dart';

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
        '/add-person-to-group': (context) => AddPersonToGroup(),
        '/settings': (context) => Settings(),
      },
    );
  }
}
