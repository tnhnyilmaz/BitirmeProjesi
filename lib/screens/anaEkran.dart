import 'package:egitim/compenents/anaEkranContainer.dart';
import 'package:egitim/compenents/topBackgorund.dart';
import 'package:flutter/material.dart';

class AnaEkran extends StatelessWidget {
  const AnaEkran({super.key});

  @override
  Widget build(BuildContext context) {
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
