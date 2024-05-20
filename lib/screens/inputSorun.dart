import 'package:bitirme_egitim_sorunlari/Provider/AuthProvider.dart';
import 'package:bitirme_egitim_sorunlari/Provider/dateProvider.dart';
import 'package:bitirme_egitim_sorunlari/compenents/generalAppbar.dart';
import 'package:bitirme_egitim_sorunlari/compenents/inputTextField.dart';
import 'package:bitirme_egitim_sorunlari/compenents/kaydetButton.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/model/kullanicilar.dart';
import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SorunInput extends StatefulWidget {
  const SorunInput({super.key});

  @override
  State<SorunInput> createState() => _SorunInputState();
}

class _SorunInputState extends State<SorunInput> {
  static int sayac = 1;
  String? a = "";
  SharedPreferences? prefs;
  Future<void> getLocalData() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  initState() {
    super.initState();
    Provider.of<DateProvider>(context, listen: false).loadSelectedDate();
    Future<void>.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      // prefs artık kullanılabilir
    });
    a;
  }

  FirestoreService _firestoreService = FirestoreService();

  String id = "";
  String? selectedDate;
  StyleTextProject styleTextProject = StyleTextProject();
  TextEditingController sorun1 = TextEditingController();
  TextEditingController sorun2 = TextEditingController();
  TextEditingController sorun3 = TextEditingController();
  TextEditingController sorun4 = TextEditingController();
  TextEditingController sorun5 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Kullanicilar? kullanici =
        Provider.of<KullaniciProvider>(context).kullanicilar;
    selectedDate = Provider.of<DateProvider>(context).selectedDate;

    if (selectedDate != null) {
      _saveDailyTopic(selectedDate!);
      // selectedDate'i kullan
      a = selectedDate;
      print("KARDEŞİMSİN BU AAA VALALHİ  : " + selectedDate!);
      _saveDailyTopic(a!);
    }
    id = kullanici!.id;
    return Scaffold(
      appBar: GeneralAppBar(
          styleTextProject: styleTextProject, title: "Eğitim Sorunları"),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Column(
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('İşlem başarıyla gerçekleştirildi.'),
                                  duration: Duration(seconds: 3),
                                  elevation: 10,
                                  backgroundColor:
                                      Colors.green.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ]),
              ],
            )),
      ),
    );
  }

  Future<void> _saveDailyTopic(String topic) async {
    await prefs?.setString("selectedDate", topic);
  }

  Future<void> _saveTopic(String topic) async {
    await prefs?.setString("date", topic);
  }

  void _addToFirestore(String s1, String s2, String s3, String s4, String s5) {
    String kullaniciID = id;
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

    FirestoreService().addSorunTopics(a!, kullaniciID, s1);
    FirestoreService().addSorunTopics(a!, kullaniciID, s2);
    FirestoreService().addSorunTopics(a!, kullaniciID, s3);
    FirestoreService().addSorunTopics(a!, kullaniciID, s4);
    FirestoreService().addSorunTopics(a!, kullaniciID, s5);
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
