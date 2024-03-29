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

class InputSorunCozumWeb extends StatefulWidget {
  const InputSorunCozumWeb({super.key});

  @override
  State<InputSorunCozumWeb> createState() => _InputSorunCozumWebState();
}

class _InputSorunCozumWebState extends State<InputSorunCozumWeb> {
  TextEditingController cozum1 = TextEditingController();
  TextEditingController cozum2 = TextEditingController();
  TextEditingController cozum3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCozumler();
  }

  void _getCozumler() async {
    // Provider aracılığıyla seçilen sorunu al
    SorunModel? selectedSorun =
        Provider.of<SelectedSorunProvider>(context, listen: false)
            .selectedSorun;

    if (selectedSorun != null) {
      String sorunID = selectedSorun.documentID!;
      print("SORUNID AMK : $sorunID");
      if (selectedSorun.documentID != null) {
        print("select: ${selectedSorun.documentID}");
      } else {
        print("Document ID is null.");
      }
      print(
          "select: ${selectedSorun.sorunMetni}"); // Sorun metni örneği, sizin kullanmanız gereken özelliği belirtir
      setState(() {}); // setState ile widget'ı güncelle
    } else {
      print("Selected Sorun is null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    StyleTextProject styleTextProject = StyleTextProject();
    SorunModel? selectedSorun =
        Provider.of<SelectedSorunProvider>(context, listen: false)
            .selectedSorun;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String selectedSorunID = selectedSorun!.documentID!;
    print("select: ${selectedSorunID}");

    return Scaffold(
        appBar: GeneralAppBar(
            styleTextProject: styleTextProject, title: "Sorun Çöz"),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 150, right: 150),
              child: Column(
                children: [
                  Container(
                    width: width,
                    height: (selectedSorun.sorunMetni.length < 50)
                        ? width * 0.2
                        : styleTextProject
                            .calculateContainerHeight(selectedSorun.sorunMetni),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 10),
                      child: Text(
                        selectedSorun!.sorunMetni,
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
                      KaydetButton(
                        text: "Çözümleri Kaydet",
                        onPressed: () {
                          _addToFirestore(cozum1.text, cozum2.text, cozum3.text,
                              selectedSorunID);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void _addToFirestore(String s1, String s2, String s3, String sorunID) {
    String kullaniciID = "2";
    // FirestoreService sınıfını kullanarak Firestore'a ekleme işlemi
    FirestoreService().addToCozum(kullaniciID, s1, sorunID);

    // Ekleme işleminden sonra text alanlarını temizle
    cozum1.clear();
  }

  double _calculateContainerHeight(String metin) {
    // Burada isteğinize göre metnin uzunluğuna bağlı olarak bir hesaplama yapabilirsiniz.
    // Aşağıdaki örnekte, metin uzunluğuna göre bir katsayı kullanılarak bir hesaplama yapılıyor.
    // Siz kendi ihtiyaçlarınıza uygun bir formül kullanabilirsiniz.
    double katsayi = 0.7; // Örnek bir katsayı
    return metin.length * katsayi;
  }
}
