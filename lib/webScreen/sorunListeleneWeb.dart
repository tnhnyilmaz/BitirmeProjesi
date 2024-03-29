import 'package:bitirme_egitim_sorunlari/Provider/SorunProvider.dart';
import 'package:bitirme_egitim_sorunlari/compenents/generalAppbar.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/screens/a.dart';
import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SorunListelemeWeb extends StatefulWidget {
  const SorunListelemeWeb({super.key});

  @override
  State<SorunListelemeWeb> createState() => _SorunListelemeWebState();
}

class _SorunListelemeWebState extends State<SorunListelemeWeb> {
  FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> sorunlar = [];
  late List<bool> _isExpandedList;
  Map<String, int> sorunCountMap = {};
  List<MapEntry<String, int>> top5SorunCount = [];
  Map<String, dynamic> top5SorunIdMap = {};

  // ALT CONTAINERLARIN ÇIKIP ÇIKMAMAMSINI KONTROL EDEN DEĞİŞKENİMİZ

  @override
  void initState() {
    super.initState();
    _isExpandedList = List.generate(10, (index) => false);
    _getSorunlar();
    //LİSTEMİZİ BURADA İLK DEFA BAŞLATIYORUZ. LİSTE BOYUTUNA GÖRE BOYUTLANIYOR VE
    //FALSE ATANIYOR.
  }

  Future<void> _getSorunlar() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestoreService.getSorunlar();
    List<Map<String, dynamic>> sorunlar = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['documentID'] = doc.id; // Belge ID'sini ekle
      return data;
    }).toList();

    // Sorunları saymak için kullanılacak harita
    Map<String, int> sorunCountMap = {};

    // Sorunları döngü kullanarak say
    sorunlar.forEach((sorun) {
      String sorunMetni = sorun['sorunMetni'];
      sorunCountMap[sorunMetni] = sorunCountMap.containsKey(sorunMetni)
          ? sorunCountMap[sorunMetni]! + 1
          : 1;
    });
    Map<String, String> sorunMetniToIdMap = {};

    for (var sorun in sorunlar) {
      sorunMetniToIdMap[sorun['sorunMetni']] = sorun['documentID'];
    }
    for (var entry in top5SorunCount) {
      top5SorunIdMap[entry.key] = sorunMetniToIdMap[entry.key];
    }

    // Sorun sayımlarını sırala
    List<MapEntry<String, int>> sortedSorunCount = sorunCountMap.entries
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Top 5 sorun sayımı al
    top5SorunCount = sortedSorunCount.take(5).toList();

    setState(() {
      this.sorunlar = sorunlar;
      _isExpandedList = List.generate(sorunlar.length, (index) => false);
    });

    for (var entry in top5SorunCount) {
      top5SorunIdMap[entry.key] = _getDocumentIdBySorunMetni(entry.key);
      print("AAAAAAAAAAAAAAAAAA: ${top5SorunIdMap}");
    }

    // List<String> top5SorunMetinleri = top5SorunCount
    // .map((entry) => "${entry.key} - ${top5SorunIdMap[entry.key]}")
    // .toList();
  }

  String _getDocumentIdBySorunMetni(String sorunMetni) {
    // Burada, sorunMetni'ye göre ilgili dokümanın ID'sini almanız gerekiyor.
    // Bu işlemi Firestore'dan çekme veya başka bir kaynaktan sağlama mantığına göre uygulamalısınız.
    // Bu sadece bir örnektir ve gerçek uygulamanıza uyacak şekilde uyarlamalısınız.
    // Örneğin, sorunlar listesinde sorunMetni'ye göre arama yapabilirsiniz.
    String? documentId;
    for (var sorun in sorunlar) {
      if (sorun['sorunMetni'] == sorunMetni) {
        documentId = sorun['documentID'];
        break;
      }
    }
    return documentId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    StyleTextProject styleTextProject = StyleTextProject();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> top5SorunMetinleri =
        top5SorunCount.map((entry) => entry.key).toList();

    //List<String> top5ID=top5SorunIdMap.ma
    print("metinler: ${top5SorunMetinleri}");
    return Scaffold(
        appBar: GeneralAppBar(
            styleTextProject: styleTextProject, title: "Tüm Sorunları"),
        body: ListView.builder(
          itemCount: top5SorunMetinleri.length,
          itemBuilder: (context, index) {
            int sayac = index + 1;
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(left: 150, right: 150),
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            width: width,
                            height: (top5SorunMetinleri[index].length < 50)
                                ? height * 0.2
                                : styleTextProject.calculateContainerHeight(
                                    top5SorunMetinleri[index]),
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: _isExpandedList[index]
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))
                                    : BorderRadius.circular(15)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "$sayac-",
                                      style: styleTextProject.ListelemeSayac,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      top5SorunMetinleri[index],
                                      style: styleTextProject.ListeSorun,
                                    ),
                                  ),
                                  Expanded(
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isExpandedList[index] =
                                                  !_isExpandedList[index];
                                            });
                                          },
                                          icon: Icon(_isExpandedList[index]
                                              ? Icons.expand_less
                                              : Icons.expand_more)))
                                ],
                              ),
                            ),
                          ),
                          if (_isExpandedList[index])
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(15))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      String selectedSorunID = top5SorunIdMap[
                                          top5SorunMetinleri[index]];
                                      Provider.of<SelectedSorunProvider>(
                                              context,
                                              listen: false)
                                          .setSelectedSorun(SorunModel(
                                              documentID: selectedSorunID,
                                              kullaniciID: "2",
                                              sorunMetni:
                                                  top5SorunMetinleri[index]));
                                      Navigator.pushNamed(
                                        context,
                                        '/SorunCozum',
                                      );
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.amber,
                                      ),
                                      child: const Center(
                                          child: Text("Sorun Öner")),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print("PRİNTTTTTTT: ${sorunlar[index]}");
                                      String selectedSorunID = top5SorunIdMap[
                                          top5SorunMetinleri[index]];
                                      Provider.of<SelectedSorunProvider>(
                                              context,
                                              listen: false)
                                          .setSelectedSorun(SorunModel(
                                              documentID: selectedSorunID,
                                              kullaniciID: "2",
                                              sorunMetni:
                                                  top5SorunMetinleri[index]));
                                      Navigator.pushNamed(
                                          context, "/CozumListeleme");
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.amber,
                                      ),
                                      child: const Center(
                                          child: Text("Tüm çözümler")),
                                    ),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ));
  }

  double _calculateContainerHeight(String metin) {
    // Burada isteğinize göre metnin uzunluğuna bağlı olarak bir hesaplama yapabilirsiniz.
    // Aşağıdaki örnekte, metin uzunluğuna göre bir katsayı kullanılarak bir hesaplama yapılıyor.
    // Siz kendi ihtiyaçlarınıza uygun bir formül kullanabilirsiniz.
    double katsayi = 0.7; // Örnek bir katsayı
    return metin.length * katsayi;
  }
}
