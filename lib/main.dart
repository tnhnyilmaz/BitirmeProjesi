import 'package:egitim/screens/InputSorunCozum.dart';
import 'package:egitim/screens/anaEkran.dart';
import 'package:egitim/screens/cozumListeleme.dart';
import 'package:egitim/screens/deneme.dart';
import 'package:egitim/screens/inputSorun.dart';
import 'package:egitim/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/AnaEkran': (context) => const AnaEkran(),
        '/InputSorun': (context) => const SorunInput(),
        '/SorunCozum': (context) => const InputSorunCozum(),
        '/SorunListeleme': (context) => deneme(),
        '/CozumListeleme': (context) => const CozumListeleme(),
      },
    );
  }
}
