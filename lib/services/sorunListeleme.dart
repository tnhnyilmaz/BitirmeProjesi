import 'package:bitirme_egitim_sorunlari/Provider/dateProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirestoreService {
  static int sayac = 2;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<QuerySnapshot<Map<String, dynamic>>> getSorunlar(String konu) async {
    // Firestore'dan sorunları al ve QuerySnapshot'ı döndür
    return await FirebaseFirestore.instance
        .collection("topics")
        .doc(konu)
        .collection("sorunlar")
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getIDCozum(String sorunId) async {
    return await FirebaseFirestore.instance
        .collection("sorunlar")
        .doc(sorunId)
        .collection("cozumler")
        .get();
  }

  Future<void> addSorunTopics(
      String konu, String kullaniciID, String sorunMetni) async {
    DocumentReference konuRef =
        FirebaseFirestore.instance.collection("topics").doc(konu);

    await konuRef.collection("sorunlar").add({
      "kullaniciID": kullaniciID,
      "sorunMetni": sorunMetni,
      "timestamp": Timestamp.now()
    });
  }

  Future<void> addSorun(String kullaniciID, String sorunMetni) async {
    // Belirlediğiniz customDocumentId kullanarak bir referans oluşturun
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("sorunlar").doc();

    // Oluşturduğunuz referans ile veriyi ekleyin
    await docRef.set({
      "kullaniciID": kullaniciID,
      "sorunMetni": sorunMetni,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> titleRecord(String title, BuildContext context) async {
    final userCollection = FirebaseFirestore.instance.collection("topics");
    DateTime nowa = DateTime.now().toLocal();
    print("TR ŞEKLİ TARİH BİLADER: $nowa");
    String konuDate = nowa.toString();
    Provider.of<DateProvider>(context, listen: false).setDate(konuDate);
    await userCollection.doc(konuDate).set({"title": title, "date": konuDate});
  }

  // Future<List<Map<String, dynamic>>> getTopicsBySelectedDate(
  //     BuildContext context) async {
  //   final userCollection = FirebaseFirestore.instance.collection("topics");
  //   String? selectedDate =
  //       Provider.of<DateProvider>(context, listen: false).selectedDate;
  //   QuerySnapshot querySnapshot =
  //       await userCollection.where("date", isEqualTo: selectedDate).get();
  // }
  Future<String> getDailyTopic(String date) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('topics').doc(date).get();
    if (snapshot.exists) {
      var topicData = snapshot.data() as Map<String, dynamic>;
      return topicData['title'];
    }
    return "";
  }

  Future<DocumentSnapshot> getTopics(String selectedDate) async {
    return await FirebaseFirestore.instance
        .collection("topics")
        .doc(selectedDate)
        .get();
  }

  Future<List<Map<String, dynamic>>> getCozum(
      String sorunID, String konu) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("topics")
        .doc(konu)
        .collection("sorunlar")
        .doc(sorunID)
        .collection("cozumler")
        .get();

    return querySnapshot.docs.map<Map<String, dynamic>>((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['documentID'] = doc.id; // Belge ID'sini ekle
      return data;
    }).toList();
  }

  Future<void> addToCozum(String kullaniciId, String cozumMetni, String sorunID,
      String konu) async {
    final docSorun = FirebaseFirestore.instance
        .collection("topics")
        .doc(konu)
        .collection("sorunlar")
        .doc(sorunID)
        .collection("cozumler");
    try {
      await docSorun.add({
        'kullaniciID': kullaniciId,
        'cozumMetni': cozumMetni,
        'sorunID': sorunID,
      });

      sayac++;
    } catch (e) {
      // Hata durumunda bir şeyler yapabilirsiniz.
      print('Firestore hatası: $e');
    }
  }

  Future<String> getDocId(String endpoint) async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('sorunlar')
        .doc(endpoint)
        .get();
    String selectedSorunID = document.id;
    print("SEÇİLEN SORUNID:  ${selectedSorunID}");
    return selectedSorunID;
  }

  // Tıkladığımız soruna ait olan çözümleri getiren method
  Future<List<Map<String, dynamic>>> getCozumler(String sorunMetni) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("cozumler")
        .where('sorunMetni', isEqualTo: sorunMetni)
        .get();

    return querySnapshot.docs
        .map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getCozumlerForSorun(String sorunID) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("cozumler")
        .where('sorunID', isEqualTo: sorunID)
        .get();

    return querySnapshot.docs
        .map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> likeCozum(
      String cozumID, String userID, String sorunID, String konu) async {
    await _firestore
        .collection("topics")
        .doc(konu)
        .collection("sorunlar")
        .doc(sorunID)
        .collection("cozumler")
        .doc(cozumID)
        .collection("liked")
        .doc(userID)
        .set({
      'likedAt': userID,
    });
  }

  Future<void> unlikeCozum(
      String cozumID, String userID, String sorunID, String konu) async {
    await _firestore
        .collection("topics")
        .doc(konu)
        .collection("sorunlar")
        .doc(sorunID)
        .collection("cozumler")
        .doc(cozumID)
        .collection("liked")
        .doc(userID)
        .delete();
  }

  Future<List<String>> getUserLikedCozumler(String cozumID, String userID,
      String sorunID, String konu, String kullaniciID) async {
    try {
      // Firestore'dan kullanıcının beğendiği çözümleri al
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection("topics")
          .doc(konu)
          .collection("sorunlar")
          .doc(sorunID)
          .collection("cozumler")
          .doc(cozumID)
          .collection("liked")
          .where('kullaniciID', isEqualTo: kullaniciID)
          .get();

      // Alınan belgeleri işle ve beğenilen çözüm ID'lerini bir listeye ekle
      List<String> likedCozumler = [];
      querySnapshot.docs.forEach((doc) {
        likedCozumler.add(doc['cozumID']);
      });

      return likedCozumler;
    } catch (e) {
      print("getUserLikedCozumler Error: $e");
      return [];
    }
  }

  Future<bool> isCozumLiked(
      String cozumID, String userID, String sorunID, String konu) async {
    DocumentSnapshot doc = await _firestore
        .collection("topics")
        .doc(konu)
        .collection("sorunlar")
        .doc(sorunID)
        .collection("cozumler")
        .doc(cozumID)
        .collection("liked")
        .doc(userID)
        .get();
    return doc.exists;
  }
}
