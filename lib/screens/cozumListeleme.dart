import 'package:bitirme_egitim_sorunlari/Provider/SorunProvider.dart';
import 'package:bitirme_egitim_sorunlari/compenents/generalAppbar.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/screens/a.dart';
import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CozumListeleme extends StatefulWidget {
  const CozumListeleme({super.key});

  @override
  State<CozumListeleme> createState() => _CozumListelemeState();
}

class _CozumListelemeState extends State<CozumListeleme> {
  List<Map<String, dynamic>> cozumler = [];
  List<Map<String, dynamic>> cozumIdGet = [];
  FirestoreService _firestoreService = FirestoreService();
  String? selectedSorunDocumentID;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String sorunID = '';
  String cozumID = '';
  List<bool> isSupportedList = [];

  @override
  void initState() {
    super.initState();
    _getCozumler();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isSupported(int index) {
    return isSupportedList[index];
  }

  void _updateCount(
      String cozumDocumentID, bool increment, String sorunID, int index) async {
    CollectionReference cozumlerCollection =
        _firestore.collection("sorunlar").doc(sorunID).collection("cozumler");

    try {
      await cozumlerCollection.doc(cozumDocumentID).update({
        'count': increment ? FieldValue.increment(1) : FieldValue.increment(-1),
      });
      print('Count güncellendi!');

      setState(() {
        if (increment) {
          cozumler[index]['destekSayisi']++;
        } else {
          cozumler[index]['destekSayisi']--;
        }

        // Çözüm ID'sini kullanarak isSupportedList'i güncelle
        int updatedIndex = cozumIdGet
            .indexWhere((element) => element['documentID'] == cozumDocumentID);
        if (updatedIndex != -1) {
          isSupportedList[updatedIndex] = !isSupportedList[updatedIndex];
        }
      });
    } catch (e) {
      print('Count güncelleme hatası: $e');
    }
  }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final selectedSorunDocumentID =
  //       Provider.of<SelectedSorunProvider>(context).selectedSorunDocumentID!;

  //   if (selectedSorunDocumentID != null) {
  //     setState(() {
  //       this.selectedSorunDocumentID = selectedSorunDocumentID;
  //     });
  //   }
  // }
  void _sortCozumlerByDestek() {
    cozumler.sort((a, b) => int.parse(b['destekSayisi'].toString())
        .compareTo(int.parse(a['destekSayisi'].toString())));
  }

  // _getCozumler metodunu aşağıdaki gibi güncelleyin
  Future<void> _getCozumler() async {
    SorunModel? selectedSorun =
        Provider.of<SelectedSorunProvider>(context, listen: false)
            .selectedSorun;

    if (selectedSorun != null) {
      sorunID = selectedSorun.documentID!;
      cozumler = await _firestoreService.getCozum(sorunID);

      // Cozumler listesini destek sayısına göre sırala
      _sortCozumlerByDestek();
      isSupportedList = List.generate(cozumler.length, (index) => false);

      setState(() {}); // setState ile widget'ı güncelle
    }
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestoreService.getIDCozum(sorunID);
    cozumIdGet = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['documentID'] = doc.id; // Belge ID'sini ekle
      return data;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final SorunModel selectedSorun =
        Provider.of<SelectedSorunProvider>(context).selectedSorun!;
    StyleTextProject styleTextProject = StyleTextProject();
    double width = MediaQuery.of(context as BuildContext).size.width;
    double height = MediaQuery.of(context as BuildContext).size.height;
    return Scaffold(
        appBar: GeneralAppBar(
            styleTextProject: styleTextProject, title: "Çözümler"),
        body: Column(
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
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            "$sayac-",
                                            style:
                                                styleTextProject.ListelemeSayac,
                                          )),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          cozumler[index]['cozumMetni'],
                                          style: styleTextProject.ListeSorun,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
          ],
        ));
  }
}
