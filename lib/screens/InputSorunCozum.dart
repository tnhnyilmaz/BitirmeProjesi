// ignore: file_names
import 'package:bitirme_egitim_sorunlari/Provider/SorunProvider.dart';
import 'package:bitirme_egitim_sorunlari/Provider/dateProvider.dart';
import 'package:bitirme_egitim_sorunlari/compenents/generalAppbar.dart';
import 'package:bitirme_egitim_sorunlari/compenents/inputTextField.dart';
import 'package:bitirme_egitim_sorunlari/compenents/kaydetButton.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/screens/a.dart';
import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputSorunCozum extends StatefulWidget {
  const InputSorunCozum({super.key});

  @override
  State<InputSorunCozum> createState() => _InputSorunCozumState();
}

class _InputSorunCozumState extends State<InputSorunCozum> {
  TextEditingController cozum1 = TextEditingController();
  String? a = "";
  SharedPreferences? prefs;
  String? selectedDate;
  Future<void> getLocalData() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<DateProvider>(context, listen: false).loadSelectedDate();
    Future<void>.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      // prefs artık kullanılabilir
    });
    a;
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
    selectedDate = Provider.of<DateProvider>(context).selectedDate;

    if (selectedDate != null) {
      _saveDailyTopic(selectedDate!);
      // selectedDate'i kullan
      a = selectedDate;
      print("KARDEŞİMSİN BU AAA VALALHİ  : " + selectedDate!);
      _saveDailyTopic(a!);
    }
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
            child: Column(
              children: [
                Container(
                  width: width,
                  height: (selectedSorun.sorunMetni.length < 75)
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
                        _addToFirestore(cozum1.text, selectedSorunID);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('İşlem başarıyla gerçekleştirildi.'),
                            duration: Duration(seconds: 3),
                            elevation: 10,
                            backgroundColor: Colors.green.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Future<void> _saveDailyTopic(String topic) async {
    await prefs?.setString("selectedDate", topic);
  }

  Future<void> _saveTopic(String topic) async {
    await prefs?.setString("date", topic);
  }

  void _addToFirestore(String s1, String sorunID) {
    String kullaniciID = "2";
    //String? temp = prefs?.getString("selectedDate");
    print("AAAAAAAAAA1111111111111111: " + a!);
    if (a == "") {
      String? temp = prefs?.getString("date");
      if (temp != null) {
        a = temp;
      } else {
        return;
      }
      a = temp;
      print("boş geliypr kardeşşş");
    } else {
      print("sıkıntı etmemek gerekir");
      _saveTopic(a!);
    }
    // FirestoreService sınıfını kullanarak Firestore'a ekleme işlemi
    FirestoreService().addToCozum(kullaniciID, s1, sorunID, a!);

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
