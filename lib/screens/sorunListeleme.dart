import 'package:bitirme_egitim_sorunlari/Provider/SorunProvider.dart';
import 'package:bitirme_egitim_sorunlari/Provider/dateProvider.dart';
import 'package:bitirme_egitim_sorunlari/compenents/generalAppbar.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/screens/a.dart';
import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SorunListeleme extends StatefulWidget {
  const SorunListeleme({super.key});

  @override
  State<SorunListeleme> createState() => _SorunListelemeState();
}

class _SorunListelemeState extends State<SorunListeleme> {
  FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> sorunlar = [];
  late List<bool> _isExpandedList;
  Map<String, int> sorunCountMap = {};
  List<MapEntry<String, int>> top5SorunCount = [];
  Map<String, dynamic> top5SorunIdMap = {};
  String a = "";
  SharedPreferences? prefs;

  Future<void> getLocalData() async {
    prefs = await SharedPreferences.getInstance();
    String? localDate = prefs?.getString("date");
    if (localDate != null) {
      setState(() {
        a = localDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLocalData();
    _initializeData();
    _isExpandedList = List.generate(10, (index) => false);
  }

  Future<void> _initializeData() async {
    await Provider.of<DateProvider>(context, listen: false).loadSelectedDate();
    String selectedDate =
        Provider.of<DateProvider>(context, listen: false).selectedDate ?? "";
    if (selectedDate.isNotEmpty) {
      setState(() {
        a = selectedDate;
      });
      await _saveTopic(selectedDate);
      await _getSorunlar();
    } else if (a.isNotEmpty) {
      await _getSorunlar();
    } else {
      // İsteğe bağlı: Burada varsayılan bir değer atayabilir veya bir hata işleyebilirsiniz.
      print("DateProvider'dan veri alınamadı veya veri boş.");
    }
  }

  Future<void> _saveTopic(String topic) async {
    await prefs?.setString("date", topic);
  }

  Future<void> _getSorunlar() async {
    if (a.isEmpty) {
      // Varsayılan bir değer atayabilir veya hata işleyebilirsiniz.
      return;
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestoreService.getSorunlar(a);
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
  }

  String _getDocumentIdBySorunMetni(String sorunMetni) {
    String? documentId;
    for (var sorun in sorunlar) {
      if (sorun['sorunMetni'] == sorunMetni) {
        documentId = sorun['documentID'];
        break;
      }
    }
    return documentId ?? '';
  }

  Future<void> _handleRefresh() async {
    await _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    String selectedDate =
        Provider.of<DateProvider>(context).selectedDate ?? "BOŞ ÇIKIYOR";
    if (selectedDate != "BOŞ ÇIKIYOR") {
      _saveTopic(selectedDate);
      a = selectedDate;
      _saveTopic(a);
    }
    print(a);
    StyleTextProject styleTextProject = StyleTextProject();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> top5SorunMetinleri =
        top5SorunCount.map((entry) => entry.key).toList();

    return Scaffold(
        appBar: GeneralAppBar(
            styleTextProject: styleTextProject, title: "Tüm Sorunları"),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView.builder(
            itemCount: top5SorunMetinleri.length,
            itemBuilder: (context, index) {
              int sayac = index + 1;
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            width: width,
                            height: (top5SorunMetinleri[index].length < 50)
                                ? width * 0.2
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
                                    MainAxisAlignment.spaceAround,
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
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.red[300],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.list),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Sorun Çöz")
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
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
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.green[300],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: const Row(
                                        children: [
                                          Text("Tüm Çözümler"),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(Icons.checklist_rtl_outlined),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ));
            },
          ),
        ));
  }
}
