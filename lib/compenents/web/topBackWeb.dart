import 'package:bitirme_egitim_sorunlari/Provider/AuthProvider.dart';
import 'package:bitirme_egitim_sorunlari/Provider/dateProvider.dart';
import 'package:bitirme_egitim_sorunlari/model/kullanicilar.dart';
import 'package:bitirme_egitim_sorunlari/services/auth_Service.dart';
import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopBackgroundWeb extends StatefulWidget {
  const TopBackgroundWeb({super.key});

  @override
  State<TopBackgroundWeb> createState() => _TopBackgroundWebState();
}

class _TopBackgroundWebState extends State<TopBackgroundWeb> {
  String? topicTitle = "Günün Konusu Henüz Belirlenmedi!";
  String? selectedDate = "";
  SharedPreferences? prefs;
  Future<void> getLocalData() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      // prefs artik kullanilabilir
    });
    getTopic();
    topicTitle;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (topicTitle == "Günün Konusu Henüz Belirlenmedi!") {
      selectedDate = Provider.of<DateProvider>(context).selectedDate;
      if (selectedDate != null) {
        getTopic();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AuthService authService = AuthService();
    FirestoreService firestoreService = FirestoreService();
    TextEditingController title = TextEditingController();
    Kullanicilar? kullanici =
        Provider.of<KullaniciProvider>(context).kullanicilar;
    bool isAdmin = kullanici?.role ?? true;
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFFBC02D), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Image.network(
            "https://i.hizliresim.com/s6z9fwu.jpg",
            fit: BoxFit.fill,
            width: width,
            height: height,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Merhaba ${kullanici?.isim ?? ''},",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      authService.signOut(context);
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: 30,
                    )),
              ],
            ),
          ),
        ),
        // isAdmin ? konuField(title) : gununKonusuText(),
        isAdmin ? konuField(title) : variableKonuText()
      ],
    );
  }

  Future<void> getTopic() async {
    if (selectedDate != null && selectedDate!.isNotEmpty) {
      final snapshot = await FirestoreService().getTopics(selectedDate!);
      if (snapshot.exists) {
        var topicData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          topicTitle = topicData['title'];
          print("ARTIK YAZ ŞUNU BİLADER : $topicTitle");
        });
      }
    }
  }

  SingleChildRenderObjectWidget variableKonuText() {
    String? temp = prefs?.getString('daily_topic');
    if (temp != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 150, left: 40),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            temp,
            style: const TextStyle(
                color: Colors.black, fontSize: 40, fontWeight: FontWeight.w900),
          ),
        ),
      );
    } else {
      // Eğer temp null ise, bir yerde hata olduğunu ve bunu düzeltmeniz gerektiğini belirten bir Widget döndürebilirsiniz.
      return const SizedBox
          .shrink(); // Boş bir widget döndürmek için kullanabilirsiniz.
    }
  }

  Padding gununKonusuText() {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Günün Konusu:",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Future<void> _saveDailyTopic(String topic) async {
    await prefs?.setString('daily_topic', topic);
  }

  Padding konuField(TextEditingController title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: TextField(
          controller: title,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: const Color(0xFFFBC02D),
            hintText: "Bugünün konusunu giriniz..",
            prefixIcon: const Icon(
              Icons.sms_rounded,
              color: Colors.black,
            ),
          ),
          onSubmitted: (title) {
            FirestoreService firestoreService = FirestoreService();
            firestoreService.titleRecord(title, context);
            DateTime nowa = DateTime.now().toLocal();
            print("TR ŞEKLİ TARİH BİLADER: $nowa");
            String konuDate = nowa.toString();
            _saveDailyTopic(title);
            print("konu $title");
          },
        ),
      ),
    );
  }
}
