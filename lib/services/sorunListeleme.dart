import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference sorunlarCollection =
      FirebaseFirestore.instance.collection('sorunlar');

  Future<List<Map<String, dynamic>>> getSorunlar() async {
    QuerySnapshot querySnapshot = await sorunlarCollection.get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
