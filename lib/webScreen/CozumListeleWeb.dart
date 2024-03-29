import 'package:bitirme_egitim_sorunlari/Provider/SorunProvider.dart';
import 'package:bitirme_egitim_sorunlari/compenents/generalAppbar.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/screens/a.dart';
import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CozumListelemeWeb extends StatefulWidget {
  const CozumListelemeWeb({super.key});

  @override
  State<CozumListelemeWeb> createState() => _CozumListelemeState();
}

class _CozumListelemeState extends State<CozumListelemeWeb> {
  List<Map<String, dynamic>> cozumler = [];
  FirestoreService _firestoreService = FirestoreService();
  String? selectedSorunDocumentID;

  @override
  void initState() {
    super.initState();
    _getCozumler();
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

  Future<void> _getCozumler() async {
    // Provider aracılığıyla seçilen sorunu al
    SorunModel? selectedSorun =
        Provider.of<SelectedSorunProvider>(context, listen: false)
            .selectedSorun;

    if (selectedSorun != null) {
      String sorunID = selectedSorun.documentID!;
      print("sorun: ${selectedSorun.sorunMetni}");
      print("SORUNID AMK : ${{sorunID}}");
      cozumler = await _firestoreService.getCozum(sorunID);
      setState(() {}); // setState ile widget'ı güncelle
      print("da");
    }
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
                                            cozumler[index]['cozumMetni'],
                                            style: styleTextProject.ListeSorun,
                                          ),
                                        )
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
          ),
        ));
  }
}