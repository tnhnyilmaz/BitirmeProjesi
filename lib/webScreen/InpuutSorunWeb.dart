import 'package:bitirme_egitim_sorunlari/compenents/generalAppbar.dart';
import 'package:bitirme_egitim_sorunlari/compenents/inputTextField.dart';
import 'package:bitirme_egitim_sorunlari/compenents/kaydetButton.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
import 'package:flutter/material.dart';

class SorunInputWeb extends StatefulWidget {
  const SorunInputWeb({super.key});

  @override
  State<SorunInputWeb> createState() => _SorunInputWebState();
}

class _SorunInputWebState extends State<SorunInputWeb> {
  static int sayac = 1;
  FirestoreService _firestoreService = FirestoreService();
  StyleTextProject styleTextProject = StyleTextProject();
  TextEditingController sorun1 = TextEditingController();
  TextEditingController sorun2 = TextEditingController();
  TextEditingController sorun3 = TextEditingController();
  TextEditingController sorun4 = TextEditingController();
  TextEditingController sorun5 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GeneralAppBar(
          styleTextProject: styleTextProject, title: "Eğitim Sorunları"),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 120, right: 120),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Wrap(
                          runSpacing: 15,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              "Eğitimde olan sorunları aşağıda bulunan bölmelere maddeler halinde giriniz.",
                              style: const TextStyle(fontSize: 15),
                            ),
                            InputTextField(
                              controller: sorun1,
                              labeltext: "Sorun",
                            ),
                            InputTextField(
                              controller: sorun2,
                              labeltext: "Sorun",
                            ),
                            InputTextField(
                              controller: sorun3,
                              labeltext: "Sorun",
                            ),
                            InputTextField(
                              controller: sorun4,
                              labeltext: "Sorun",
                            ),
                            InputTextField(
                              controller: sorun5,
                              labeltext: "Sorun",
                            ),
                            KaydetButton(
                              text: "Sorunları Kaydet",
                              onPressed: () {
                                _addToFirestore(sorun1.text, sorun2.text,
                                    sorun3.text, sorun4.text, sorun5.text);
                              },
                            ),
                          ],
                        )
                      ]),
                ),
              ],
            )),
      ),
    );
  }

  void _addToFirestore(String s1, String s2, String s3, String s4, String s5) {
    String kullaniciID = "2";

    // FirestoreService sınıfını kullanarak Firestore'a ekleme işlemi
    FirestoreService().addSorun(kullaniciID, s1);
    FirestoreService().addSorun(kullaniciID, s2);
    FirestoreService().addSorun(kullaniciID, s3);
    FirestoreService().addSorun(kullaniciID, s4);
    FirestoreService().addSorun(kullaniciID, s5);
    // Ekleme işleminden sonra text alanlarını temizle
    sorun1.clear();
    sorun2.clear();
    sorun3.clear();
    sorun4.clear();
    sorun5.clear();
  }

  String docID() {
    String sorunName = "sorunid_$sayac";
    sayac++;
    return sorunName;
  }

  double _calculateContainerHeight(String metin) {
    // Burada isteğinize göre metnin uzunluğuna bağlı olarak bir hesaplama yapabilirsiniz.
    // Aşağıdaki örnekte, metin uzunluğuna göre bir katsayı kullanılarak bir hesaplama yapılıyor.
    // Siz kendi ihtiyaçlarınıza uygun bir formül kullanabilirsiniz.
    double katsayi = 0.7; // Örnek bir katsayı
    return metin.length * katsayi;
  }
}
