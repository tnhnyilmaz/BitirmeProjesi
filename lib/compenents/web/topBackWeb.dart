import 'package:bitirme_egitim_sorunlari/Provider/AuthProvider.dart';
import 'package:bitirme_egitim_sorunlari/model/kullanicilar.dart';
import 'package:bitirme_egitim_sorunlari/services/auth_Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBackgroundWeb extends StatelessWidget {
  const TopBackgroundWeb({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AuthService _authService = AuthService();

    Kullanicilar? kullanici =
        Provider.of<KullaniciProvider>(context).kullanicilar;

    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFFBC02D), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Image.network(
            "https://i.hizliresim.com/s6z9fwu.jpg",
            fit: BoxFit.fill,
            width: width,
            height: height,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Merhaba ${kullanici?.isim ?? ''},",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      _authService.signOut(context);
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: 30,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
