import 'package:flutter/material.dart';
import 'package:chitisplit/pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const AppChiTiSplit();
  }
}

class AppChiTiSplit extends StatelessWidget {
  const AppChiTiSplit({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => const Home(),
      },
    );
  }
}
