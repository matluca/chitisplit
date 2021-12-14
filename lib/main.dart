import 'package:flutter/material.dart';
import 'package:chitisplit/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // For Android
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // For Web
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDVHhwYrsWnvb42plaZ1p1C1g1fzDPDvq4",
          authDomain: "chi-ti-split.firebaseapp.com",
          projectId: "chi-ti-split",
          storageBucket: "chi-ti-split.appspot.com",
          messagingSenderId: "213902996727",
          appId: "1:213902996727:web:13831f2e91caa8827b8ff2",
          databaseURL: "https://chi-ti-split.firebaseio.com"));

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text(snapshot.error.toString(),
              textDirection: TextDirection.ltr);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const AppChiTiSplit();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Center(
            child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ));
      },
    );
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
