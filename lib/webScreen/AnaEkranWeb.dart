import 'package:bitirme_egitim_sorunlari/Provider/AuthProvider.dart';
import 'package:bitirme_egitim_sorunlari/compenents/web/anaEkranContainerWeb.dart';
import 'package:bitirme_egitim_sorunlari/compenents/web/topBackWeb.dart';
import 'package:bitirme_egitim_sorunlari/services/auth_Service.dart';
import 'package:flutter/material.dart';

class AnaEkranWeb extends StatelessWidget {
  const AnaEkranWeb({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();
    KullaniciProvider kullaniciProvider = KullaniciProvider();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Expanded(
            flex: 2,
            child: TopBackgroundWeb(),
          ),
          Expanded(
            flex: 4,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 100,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            runSpacing: 15,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/InputSorun');
                                },
                                child: const HomeContainerWeb(
                                  imageUrl:
                                      "https://i.hizliresim.com/35osmyk.png",
                                  text: '   Sorun Belirt',
                                ),
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/SorunListeleme');
                                },
                                child: const HomeContainerWeb(
                                    text: "   Tüm Sorunlar",
                                    imageUrl:
                                        "https://cdn-icons-png.flaticon.com/512/1547/1547559.png"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          altContainer()
        ],
      ),
    );
  }

  Container altContainer() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(70),
          topLeft: Radius.circular(70),
        ),
        color: Colors.amber,
      ),
      child: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              "Amaçlanan Nedir?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              "Temel hedefimiz, kullanıcılarımıza çeşitli eğitim konularında karşılaştığı sorunları birlikte belirleyip çözebilmeleri için bir platform sağlamayı hedefliyoruz.",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Text(
              "Sorunlarını paylaşan kullanıcılarımıza, topluluk içinde çözüm önerilerini sağlayan kullanıcılarımız tarafından gerekli merciiler tarafından etkileşime geçmek.",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
