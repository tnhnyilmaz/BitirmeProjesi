import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static int sayac = 2;

  // Sorunları aldığımız ekrandaki verilerimizi firestore database'ye kaydetmek için kullandığımız method

  Future<QuerySnapshot<Map<String, dynamic>>> getSorunlar() async {
    // Firestore'dan sorunları al ve QuerySnapshot'ı döndür
    return await FirebaseFirestore.instance.collection("sorunlar").get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getIDCozum(String sorunId) async {
    return await FirebaseFirestore.instance
        .collection("sorunlar")
        .doc(sorunId)
        .collection("cozumler")
        .get();
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

  Future<List<Map<String, dynamic>>> getCozum(String sorunID) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("sorunlar")
              .doc(sorunID)
              .collection("cozumler")
              .get();

      return querySnapshot.docs
          .map<Map<String, dynamic>>(
              (doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      // Hata durumunda burada işlemler yapabilirsiniz.
      print("getCozum Hatası: $e");
      return []; // Boş liste veya isteğe bağlı başka bir değer dönebilirsiniz.
    }
  }

  Future<void> addToCozum(
      String kullaniciId, String cozumMetni, String sorunID) async {
    final docSorun = FirebaseFirestore.instance
        .collection("sorunlar")
        .doc(sorunID)
        .collection("cozumler");
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
}
