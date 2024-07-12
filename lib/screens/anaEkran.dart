import 'package:bitirme_egitim_sorunlari/Provider/AuthProvider.dart';
import 'package:bitirme_egitim_sorunlari/compenents/anaEkranContainer.dart';
import 'package:bitirme_egitim_sorunlari/compenents/topBackgorund.dart';
import 'package:bitirme_egitim_sorunlari/services/auth_Service.dart';
import 'package:flutter/material.dart';

class AnaEkran extends StatelessWidget {
  const AnaEkran({super.key});

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
            child: TopBackground(),
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
                    child: Column(
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
                                child: const HomeContainer(
                                  imageUrl:
                                      "https://i.pinimg.com/originals/83/36/1c/83361cca2748eaf1a208530109974c1c.png",
                                  text: 'Sorun Belirt',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/SorunListeleme');
                                },
                                child: const HomeContainer(
                                    text: "Tüm Sorunlar",
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
              "Çalıştay Günlüğü, kullanıcıların günlük olarak belirlenen konular üzerinden sorunlarını paylaşarak ve çözüm önerileri sunarak işbirliği yapmalarını amaçlar.",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Text(
              "Platform, toplulukların ortak sorunlarına kolektif çözümler üretmelerine ve bu çözümler üzerinde etkileşimde bulunmalarına olanak tanır. Bu sayede kullanıcılar, daha etkili ve yaratıcı çözüm yolları bularak günlük yaşamda karşılaştıkları sorunları gidermeye çalışır.",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
