import 'package:bitirme_egitim_sorunlari/screens/a.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static int sayac = 2;

  // Sorunları aldığımız ekrandaki verilerimizi firestore database'ye kaydetmek için kullandığımız method

  Future<void> addSorun(
      String kullaniciID, String sorunMetni, String customDocumentId) async {
    // Belirlediğiniz customDocumentId kullanarak bir referans oluşturun
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("sorunlar").doc(customDocumentId);

    // Oluşturduğunuz referans ile veriyi ekleyin
    await docRef.set({
      "kullaniciID": kullaniciID,
      "sorunMetni": sorunMetni,
    });
  }

  Future<List<Map<String, dynamic>>> getSorunlar() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("sorunlar").get();

    return querySnapshot.docs
        .map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> addToCozum(
      String kullaniciId, String cozumMetni, String sorunID) async {
    final docSorun = FirebaseFirestore.instance.collection("cozumler");
    try {
      await docSorun.add({
        'kullaniciID': kullaniciId,
        'cozumMetni': cozumMetni,
        'sorunID': sorunID
      });
      sayac++;
    } catch (e) {
      // Hata durumunda bir şeyler yapabilirsiniz.
      print('Firestore hatası: $e');
    }
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
}

class SorunService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<SorunModel?> getSorun(String belgeID) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('sorunlar').doc(belgeID).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return SorunModel.fromFirestore(data, snapshot.id);
      } else {
        print("Belge bulunamadı.");
        return null;
      }
    } catch (e) {
      print("Firestore hatası: $e");
      return null;
    }
  }
}

class CozumService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCozum(
      String kullaniciID, String cozumMetni, String sorunID) async {
    try {
      await _firestore.collection("cozumler").add({
        'kullaniciID': kullaniciID,
        'cozumMetni': cozumMetni,
        'sorunID': sorunID,
      });
    } catch (e) {
      print('Firestore hatası: $e');
    }
  }

  Future<List<SorunModel>> getCozumlerForSorun(String sorunID) async {
    try {
      // Veritabanından çözümleri al
      QuerySnapshot querySnapshot = await _firestore
          .collection("cozumler")
          .where('sorunID', isEqualTo: sorunID)
          .get();

      // QuerySnapshot içindeki her belgeyi SorunModel'e dönüştür
      List<SorunModel> cozumler = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return SorunModel.fromFirestore(data, doc.id);
      }).toList();

      return cozumler;
    } catch (e) {
      print("Firestore hatası: $e");
      return [];
    }
  }
}
