// ignore: file_names
import 'package:bitirme_egitim_sorunlari/Provider/SorunProvider.dart';
import 'package:bitirme_egitim_sorunlari/compenents/generalAppbar.dart';
import 'package:bitirme_egitim_sorunlari/compenents/inputTextField.dart';
import 'package:bitirme_egitim_sorunlari/compenents/kaydetButton.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/screens/a.dart';
import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputSorunCozum extends StatefulWidget {
  const InputSorunCozum({super.key});

  @override
  State<InputSorunCozum> createState() => _InputSorunCozumState();
}

class _InputSorunCozumState extends State<InputSorunCozum> {
  TextEditingController cozum1 = TextEditingController();
  TextEditingController cozum2 = TextEditingController();
  TextEditingController cozum3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SorunModel selectedSorun =
        Provider.of<SelectedSorunProvider>(context).selectedSorun!;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String selectedsorunID = selectedSorun.documentID ?? '';

    StyleTextProject styleTextProject = StyleTextProject();
    return Scaffold(
        appBar: GeneralAppBar(
            styleTextProject: styleTextProject, title: "Sorun Çöz"),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: width,
                  height: height * 0.2,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 10),
                    child: Text(
                      selectedSorun.sorunMetni,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )),
                ),
                const SizedBox(
                  height: 25,
                ),
                Wrap(
                  runSpacing: 15,
                  children: [
                    InputTextField(
                      controller: cozum1,
                      labeltext: "Çözüm",
                    ),
                    InputTextField(
                      controller: cozum2,
                      labeltext: "Çözüm",
                    ),
                    InputTextField(
                      controller: cozum3,
                      labeltext: "Çözüm",
                    ),
                    KaydetButton(
                      text: "Çözümleri Kaydet",
                      onPressed: () {
                        _addToFirestore(cozum1.text, cozum2.text, cozum3.text,
                            selectedsorunID);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void _addToFirestore(String s1, String s2, String s3, String sorunID) {
    String kullaniciID = "2";
    // FirestoreService sınıfını kullanarak Firestore'a ekleme işlemi
    FirestoreService().addToCozum(kullaniciID, s1, sorunID);
    FirestoreService().addToCozum(kullaniciID, s2, sorunID);
    FirestoreService().addToCozum(kullaniciID, s3, sorunID);
    // Ekleme işleminden sonra text alanlarını temizle
    cozum1.clear();
    cozum2.clear();
    cozum3.clear();
  }
}
