import 'package:bitirme_egitim_sorunlari/Provider/AuthProvider.dart';
import 'package:bitirme_egitim_sorunlari/Provider/SorunProvider.dart';
import 'package:bitirme_egitim_sorunlari/Provider/dateProvider.dart';
import 'package:bitirme_egitim_sorunlari/firebase_options.dart';
import 'package:bitirme_egitim_sorunlari/screens/InputSorunCozum.dart';
import 'package:bitirme_egitim_sorunlari/screens/anaEkran.dart';
import 'package:bitirme_egitim_sorunlari/screens/cozumListeleme.dart';
import 'package:bitirme_egitim_sorunlari/screens/inputSorun.dart';
import 'package:bitirme_egitim_sorunlari/screens/login.dart';
import 'package:bitirme_egitim_sorunlari/screens/register.dart';
import 'package:bitirme_egitim_sorunlari/screens/sorunListeleme.dart';
import 'package:bitirme_egitim_sorunlari/webScreen/AnaEkranWeb.dart';
import 'package:bitirme_egitim_sorunlari/webScreen/CozumListeleWeb.dart';
import 'package:bitirme_egitim_sorunlari/webScreen/InpuutSorunWeb.dart';
import 'package:bitirme_egitim_sorunlari/webScreen/inputSorunCozumWeb.dart';
import 'package:bitirme_egitim_sorunlari/webScreen/loginWeb.dart';
import 'package:bitirme_egitim_sorunlari/webScreen/registerWeb.dart';
import 'package:bitirme_egitim_sorunlari/webScreen/sorunListeleneWeb.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SelectedSorunProvider()),
        ChangeNotifierProvider(create: (context) => KullaniciProvider()),
        ChangeNotifierProvider(create: (context) => DateProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (kIsWeb) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                    builder: (context) => const LoginWeb());
              case '/AnaEkran':
                return MaterialPageRoute(
                    builder: (context) => const AnaEkranWeb());
              case '/InputSorun':
                return MaterialPageRoute(builder: (context) => SorunInputWeb());
              case '/SorunCozum':
                return MaterialPageRoute(
                    builder: (context) => InputSorunCozumWeb());
              case '/SorunListeleme':
                return MaterialPageRoute(
                    builder: (context) => SorunListelemeWeb());
              case '/CozumListeleme':
                return MaterialPageRoute(
                    builder: (context) => const CozumListelemeWeb());
              case '/Register':
                return MaterialPageRoute(
                    builder: (context) => RegisterScreenWeb());
              default:
                return MaterialPageRoute(
                    builder: (context) => const LoginWeb());
            }
          } else {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (context) => const Login());
              case '/AnaEkran':
                return MaterialPageRoute(
                    builder: (context) => const AnaEkran());
              case '/InputSorun':
                return MaterialPageRoute(builder: (context) => SorunInput());
              case '/SorunCozum':
                return MaterialPageRoute(
                    builder: (context) => InputSorunCozum());
              case '/SorunListeleme':
                return MaterialPageRoute(
                    builder: (context) => SorunListeleme());
              case '/CozumListeleme':
                return MaterialPageRoute(
                    builder: (context) => const CozumListeleme());
              case '/Register':
                return MaterialPageRoute(
                    builder: (context) => RegisterScreen());
              default:
                return MaterialPageRoute(builder: (context) => const Login());
            }
          }
        },
      ),
    );
  }
}
