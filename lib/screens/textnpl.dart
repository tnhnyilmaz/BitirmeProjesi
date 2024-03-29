import 'package:flutter/material.dart';

class nplScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Benzer Sorunlar Analizi'),
        ),
        body: BenzerSorunlarAnalizi(),
      ),
    );
  }
}

class BenzerSorunlarAnalizi extends StatelessWidget {
  final List<String> sorunlar = [
    "Dijital öğrenim araçlarının yetersiz kullanımı.",
    "Öğrenci katılımının düşük olması.",
    "Eğitim materyallerinin güncel olmaması.",
    "Sınıf mevcudiyetinin fazla olması.",
    "Öğrencilere bireysel geri bildirim sağlamada zorluk.",
    "Teknolojik altyapının eksikliği.",
    "Öğrenci motivasyonunun düşük olması.",
    "Öğrenci-öğretmen iletişiminde zorluklar.",
    "Eğitimde çeşitliliğin yetersiz olması.",
    "Eğitim programlarının öğrenci ihtiyaçlarına uygun olmaması.",
    "Öğretmenler arasında eğitim metotlarındaki farklılıklar.",
    "Sınav odaklı değerlendirmenin ağırlıklı olması.",
    "Öğrenciler arasındaki sosyal eşitsizlik.",
    "Sınıflardaki fiziksel düzenin öğrenmeyi engellemesi.",
    "Eğitimde interaktif ve uygulamalı aktivitelerin azlığı."
        "Eğitim müfredatın uygun olmaması",
    "teknolojiyi kullanmama",
    "Sınıf içindeki düşük öğrenci katılımı, etkileşim eksikliğine ve öğrencilerin derse olan ilgisinin azalmasına neden olmaktadır.",
    "Büyük sınıf mevcudiyeti, öğretmenlerin bireysel öğrenci ihtiyaçlarına yeterince odaklanmasını zorlaştırarak öğrenci başarısını olumsuz etkilemektedir.",
    "Öğretmenlerin öğrencilere bireysel geri bildirim sağlama zorluğu, öğrencilerin kişisel gelişimlerini takip etmelerini ve eksikliklerini anlamalarını engellemektedir.",
  ];
  double jaccard(List<String> list1, List<String> list2) {
    final set1 = Set<String>.from(list1);
    final set2 = Set<String>.from(list2);

    final intersection = set1.intersection(set2).length;
    final union = set1.union(set2).length;

    return intersection / union;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> benzerlikSkorlari = {};

    for (int i = 0; i < sorunlar.length; i++) {
      for (int j = i + 1; j < sorunlar.length; j++) {
        double benzerlik =
            jaccard(sorunlar[i].split(' '), sorunlar[j].split(' '));
        benzerlikSkorlari["${i + 1} ve ${j + 1}"] = (benzerlik * 100).round();
      }
    }

    var siraliSkorlar = benzerlikSkorlari.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    var enCokTekrarlanan5Sorun = <String>[];

    for (var i = 0; i < 5 && i < siraliSkorlar.length; i++) {
      var indisler = siraliSkorlar[i].key.split(' ve ');
      var sorun1 = sorunlar[int.parse(indisler[0]) - 1];
      var sorun2 = sorunlar[int.parse(indisler[1]) - 1];

      enCokTekrarlanan5Sorun.add(sorun1);
      enCokTekrarlanan5Sorun.add(sorun2);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "En Çok Tekrarlanan 5 Sorun:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        for (var i = 0; i < enCokTekrarlanan5Sorun.length; i++)
          Text("${i + 1}. Sorun: ${enCokTekrarlanan5Sorun[i]}"),
      ],
    );
  }
}
