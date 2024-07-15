import 'dart:io';

import 'package:bitirme_egitim_sorunlari/Provider/SorunProvider.dart';
import 'package:bitirme_egitim_sorunlari/Provider/dateProvider.dart';
import 'package:bitirme_egitim_sorunlari/compenents/generalAppbar.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/screens/a.dart';
import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String a = "";
  SharedPreferences? prefs;

  Map<String, List<String>> kategorilendirilmisMaddeler = {};
  List<String> secilenMaddeler = [];

  Map<String, String> sorunIdMap = {};
  // ALT CONTAINERLARIN ÇIKIP ÇIKMAMAMSINI KONTROL EDEN DEĞİŞKENİMİZ

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
    _isExpandedList = List.generate(5, (index) => false);
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

  List<String> _response = [];

  Future<void> _saveTopic(String topic) async {
    await prefs?.setString("date", topic);
  }

  Future<void> _sendIssuesToGemini(String issues) async {
    const apiKey = 'YOUR-API-KEY';
    final url = Uri.parse('https://api.gemini.com/v1/completions');
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final content = [
      Content.text(
          'Verileri kategorilere ayır ve en çok bahsedilen 5 kategoriyi seç. Sonra her kategoriden bir maddeyi bana geri döndür fakat başlık atmadan sadece firebaseden çekilen maddeleri döndür.Yani kategori başlığı değil maddelerden birini döndür maddelerin balına sonuna hiçbir şey ekleme sadece sana gönderdiğim maddeleri gönder. :\n\n$issues')
    ];
    final responsee = await model.generateContent(content);
    print(responsee.text);
    if (responsee.text!.isNotEmpty) {
      setState(() {
        _response = responsee.text!.split('\n');
        print("dasdasdasdasd" + _response.toString());
        print('_response: ${_response.join('\n')}\n');
        for (var sorun in sorunlar) {
          for (var item in _response) {
            String trimmedSorunMetni = sorun['sorunMetni'].trim();
            String trimmedItem = item.trim();

            print(
                'SorunMetni: $trimmedSorunMetni ile item: $trimmedItem karşılaştırılıyor.');
            if (trimmedSorunMetni == trimmedItem) {
              top5SorunIdMap[trimmedItem] = sorun['documentID'];
              print("sorunID MAP : " + top5SorunIdMap.toString());
            }
          }
        }
      });
    } else {
      setState(() {
        _response = ['Gemini yanıtı alınamadı.'];
      });
    }
  }

  String _filterIssues(String text) {
    // Başlıkları sil
    text = text.replaceAll(RegExp(r'^##.*?\n'), '');

    // "" ve "#" işaretlerini sil
    text = text.replaceAll(r'^"|"$|#', '');

    return text.trim();
  }

  Future<void> _getSorunlar() async {
    if (a.isEmpty) {
      return;
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestoreService.getSorunlar(a);
    List<Map<String, dynamic>> sorunlar = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['documentID'] = doc.id;
      return data;
    }).toList();

    setState(() {
      this.sorunlar = sorunlar;

      // SorunIdMap'i doldurun
      for (var sorun in sorunlar) {
        sorunIdMap[sorun['sorunMetni']] = sorun['documentID'];
        print("içerden gelmece " + sorunIdMap.toString());
      }
    });

    // Sorunları birleştirip Gemini'ye gönder
    String issues = sorunlar.map((sorun) => sorun['sorunMetni']).join('\n');
    await _sendIssuesToGemini(issues);
    _response.removeWhere((item) => item.isEmpty || item.startsWith("#"));
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
    return Scaffold(
      appBar: GeneralAppBar(
          styleTextProject: styleTextProject, title: "Tüm Sorunları"),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
          itemCount: _response.length,
          itemBuilder: (context, index) {
            int sayac = index + 1;
            return Padding(
              padding: const EdgeInsets.only(left: 150, right: 150),
              child: GestureDetector(
                onTap: () {},
                child: Card(
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        height: (_response[index].length < 75)
                            ? width * 0.1
                            : styleTextProject
                                .calculateContainerHeight(_response[index]),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: _isExpandedList[index]
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))
                                : BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
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
                                  _response[index],
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  String responseItem = _response[index].trim();
                                  String selectedSorunID =
                                      sorunIdMap[responseItem] ??
                                          "SIKINTI DAYI";
                                  print(
                                      'Selected Sorun ID: $selectedSorunID for item: $responseItem');
                                  Provider.of<SelectedSorunProvider>(context,
                                          listen: false)
                                      .setSelectedSorun(SorunModel(
                                          documentID: selectedSorunID,
                                          kullaniciID: "2",
                                          sorunMetni: _response[index]));
                                  Navigator.pushNamed(
                                    context,
                                    '/SorunCozum',
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.red[300],
                                      borderRadius: BorderRadius.circular(15)),
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
                                  String responseItem = _response[index].trim();
                                  String selectedSorunID =
                                      sorunIdMap[responseItem] ??
                                          "SIKINTI DAYI";
                                  print(
                                      'Selected Sorun ID: $selectedSorunID for item: $responseItem');
                                  Provider.of<SelectedSorunProvider>(context,
                                          listen: false)
                                      .setSelectedSorun(SorunModel(
                                          documentID: selectedSorunID,
                                          kullaniciID: "2",
                                          sorunMetni: _response[index]));
                                  Navigator.pushNamed(
                                      context, "/CozumListeleme");
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.green[300],
                                      borderRadius: BorderRadius.circular(15)),
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
              ),
            );
          },
        ),
      ),
    );
  }

  double _calculateContainerHeight(String metin) {
    // Burada isteğinize göre metnin uzunluğuna bağlı olarak bir hesaplama yapabilirsiniz.
    // Aşağıdaki örnekte, metin uzunluğuna göre bir katsayı kullanılarak bir hesaplama yapılıyor.
    // Siz kendi ihtiyaçlarınıza uygun bir formül kullanabilirsiniz.
    double katsayi = 0.7; // Örnek bir katsayı
    return metin.length * katsayi;
  }
}
