import 'package:bitirme_egitim_sorunlari/Provider/AuthProvider.dart';
import 'package:bitirme_egitim_sorunlari/Provider/SorunProvider.dart';
import 'package:bitirme_egitim_sorunlari/Provider/dateProvider.dart';
import 'package:bitirme_egitim_sorunlari/compenents/generalAppbar.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/model/kullanicilar.dart';
import 'package:bitirme_egitim_sorunlari/screens/a.dart';
import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CozumListelemeWeb extends StatefulWidget {
  const CozumListelemeWeb({super.key});

  @override
  State<CozumListelemeWeb> createState() => _CozumListelemeState();
}

class _CozumListelemeState extends State<CozumListelemeWeb> {
  List<Map<String, dynamic>> cozumler = [];
  List<Map<String, dynamic>> cozumIdGet = [];
  FirestoreService _firestoreService = FirestoreService();
  String? selectedSorunDocumentID;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String sorunID = '';
  String cozumID = '';
  String a = "";
  List<bool> isSupportedList = [];
  SharedPreferences? prefs;
  List<String> likedCozumler = [];
  bool isLiked = false;
  bool _islike = false;

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
      await _getCozumler();
    } else if (a.isNotEmpty) {
      await _getCozumler();
    } else {
      print("DateProvider'dan veri alınamadı veya veri boş.");
    }
  }

  void _sortCozumlerByDestek() {
    cozumler.sort((a, b) {
      int destekSayisiA =
          int.tryParse(a['destekSayisi']?.toString() ?? '0') ?? 0;
      int destekSayisiB =
          int.tryParse(b['destekSayisi']?.toString() ?? '0') ?? 0;
      return destekSayisiB.compareTo(destekSayisiA);
    });
  }

  Future<void> _saveTopic(String topic) async {
    await prefs?.setString("date", topic);
  }

  bool isSupported(int index) {
    return isSupportedList[index];
  }

  Future<void> _getCozumler() async {
    SorunModel? selectedSorun =
        Provider.of<SelectedSorunProvider>(context, listen: false)
            .selectedSorun;

    if (selectedSorun != null) {
      sorunID = selectedSorun.documentID ?? '';
      print("Selected sorunID: $sorunID");
      print("Topic (a): $a");

      if (sorunID.isNotEmpty && a.isNotEmpty) {
        List<Map<String, dynamic>> newCozumler =
            await _firestoreService.getCozum(sorunID, a);

        // Çözümleri beğeni sayısına göre sıralamak için beğeni sayısını al
        for (var cozum in newCozumler) {
          String cozumID = cozum['documentID'];
          QuerySnapshot likedSnapshot = await _firestore
              .collection("topics")
              .doc(a)
              .collection("sorunlar")
              .doc(sorunID)
              .collection("cozumler")
              .doc(cozumID)
              .collection("liked")
              .get();
          int likeCount = likedSnapshot.docs.length;
          cozum['likeCount'] = likeCount; // Beğeni sayısını çözüme ekle
        }

        // Çözümleri beğeni sayısına göre sırala
        newCozumler.sort((a, b) => b['likeCount'].compareTo(a['likeCount']));

        isSupportedList = List.generate(newCozumler.length, (index) => false);

        setState(() {
          cozumler = newCozumler;
          print(cozumler);
        }); // Widget'ı güncelle
      } else {
        print("Sorun ID veya 'a' boş");
      }
    } else {
      print("Seçilen sorun null");
    }
  }

  Future<void> getIDCozum() async {
    if (sorunID.isNotEmpty) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestoreService.getIDCozum(sorunID);
      cozumIdGet = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['documentID'] = doc.id; // Belge ID'sini ekle
        print("ğğğğğğğğüüüüüüüüüüüüüüüüü");
        print(data);
        return data;
      }).toList();
    } else {
      print("Sorun ID boş, cozumIdGet alınamıyor");
    }
  }

  Future<void> _toggleLike(String cozumID, String kullaniciID) async {
    isLiked = likedCozumler.contains(cozumID);

    if (isLiked) {
      // Beğeniyi geri çek
      await _firestoreService.unlikeCozum(cozumID, kullaniciID, sorunID, a);
      setState(() {
        likedCozumler.remove(cozumID);
      });
    } else {
      // Beğen
      await _firestoreService.likeCozum(cozumID, kullaniciID, sorunID, a);
      setState(() {
        likedCozumler.add(cozumID);
      });
    }

    // Çözümleri yeniden getir
    await _getCozumler();
  }

  @override
  Widget build(BuildContext context) {
    SorunModel selectedSorun =
        Provider.of<SelectedSorunProvider>(context).selectedSorun!;
    Kullanicilar? kullanici =
        Provider.of<KullaniciProvider>(context).kullanicilar;
    String userID = kullanici!.id;

    StyleTextProject styleTextProject = StyleTextProject();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: GeneralAppBar(
            styleTextProject: styleTextProject, title: "Çözümler"),
        body: Padding(
          padding: const EdgeInsets.only(left: 150, right: 150),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: width,
                    height: (selectedSorun.sorunMetni.length < 50)
                        ? height * 0.2
                        : styleTextProject
                            .calculateContainerHeight(selectedSorun.sorunMetni),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.amber),
                    child: Center(
                        child: Padding(
                      padding: styleTextProject.DetaySorunPadding,
                      child: Text(
                        selectedSorun.sorunMetni,
                        style: styleTextProject.DetaySorun,
                      ),
                    )),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: cozumler.length,
                  itemBuilder: (context, index) {
                    int sayac = index + 1;
                    String? cozumID = cozumler[index]['documentID'];
                    return FutureBuilder<bool>(
                      future: _firestoreService.isCozumLiked(
                          cozumID!, userID, sorunID, a),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          bool isLiked = snapshot.data ?? false;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: Card(
                                child: Column(
                                  children: [
                                    Container(
                                      width: width,
                                      height: height * 0.1,
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "$sayac-",
                                                  style: styleTextProject
                                                      .ListelemeSayac,
                                                )),
                                            Expanded(
                                              flex: 6,
                                              child: Text(
                                                cozumler[index]['cozumMetni'] ??
                                                    "boş",
                                                style:
                                                    styleTextProject.ListeSorun,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  if (cozumID != null) {
                                                    _toggleLike(cozumID,
                                                        userID); // Pass non-null cozumID
                                                  } else {
                                                    print(
                                                        "Error: cozumID is null");
                                                  }
                                                },
                                                icon: Icon(isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border),
                                                color:
                                                    isLiked ? Colors.red : null)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
