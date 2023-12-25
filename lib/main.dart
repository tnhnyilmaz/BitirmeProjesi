import 'package:bitirme_egitim_sorunlari/Provider/AuthProvider.dart';
import 'package:bitirme_egitim_sorunlari/Provider/SorunProvider.dart';
import 'package:bitirme_egitim_sorunlari/firebase_options.dart';
import 'package:bitirme_egitim_sorunlari/screens/InputSorunCozum.dart';
import 'package:bitirme_egitim_sorunlari/screens/anaEkran.dart';
import 'package:bitirme_egitim_sorunlari/screens/cozumListeleme.dart';
import 'package:bitirme_egitim_sorunlari/screens/inputSorun.dart';
import 'package:bitirme_egitim_sorunlari/screens/login.dart';
import 'package:bitirme_egitim_sorunlari/screens/register.dart';
import 'package:bitirme_egitim_sorunlari/screens/sorunListeleme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SelectedSorunProvider()),
        ChangeNotifierProvider(create: (context) => KullaniciProvider()),
        // Diğer provider'ları buraya ekleyebilirsiniz
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const Login(),
          '/AnaEkran': (context) => const AnaEkran(),
          '/InputSorun': (context) => SorunInput(),
          '/SorunCozum': (context) => InputSorunCozum(),
          '/SorunListeleme': (context) => SorunListeleme(),
          '/CozumListeleme': (context) => const CozumListeleme(),
          '/Register': (context) => RegisterScreen(),
        },
      ),
    );
  }
}
