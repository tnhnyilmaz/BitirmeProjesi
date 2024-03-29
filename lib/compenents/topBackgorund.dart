import 'package:bitirme_egitim_sorunlari/Provider/AuthProvider.dart';
import 'package:bitirme_egitim_sorunlari/model/kullanicilar.dart';
import 'package:bitirme_egitim_sorunlari/services/auth_Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBackground extends StatelessWidget {
  const TopBackground({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AuthService _authService = AuthService();
    TextEditingController title = TextEditingController();
    bool a;
    Kullanicilar? kullanici =
        Provider.of<KullaniciProvider>(context).kullanicilar;
    bool isAdmin = kullanici?.role ?? true;

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
            "https://t4.ftcdn.net/jpg/04/50/72/13/360_F_450721320_bmVwBx0lQiyWvQLqkMqAUQHVP88pKtSc.jpg",
            fit: BoxFit.fill,
            width: width,
            height: height,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Merhaba ${kullanici?.isim ?? ''},",
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
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

        isAdmin ? konuField(title) : gununKonusuText(),
        isAdmin ? konuField(title) : variableKonuText()
        //  konuField(title),
      ],
    );
  }

  Padding variableKonuText() {
    return const Padding(
      padding: EdgeInsets.only(top: 70, left: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          " topic",
          style: TextStyle(
              color: Colors.black, fontSize: 40, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  Padding gununKonusuText() {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Günün Konusu:",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Padding konuField(TextEditingController title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: TextField(
          controller: title,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: const Color(0xFFFBC02D),
            hintText: "Bugünün konusunu giriniz..",
            prefixIcon: const Icon(
              Icons.sms_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
