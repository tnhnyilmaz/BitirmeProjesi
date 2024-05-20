import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KonuProvider extends ChangeNotifier {
  String? _gununKonusu;

  String? get gununKonusu => _gununKonusu;

  Future<void> getGununKonusu() async {
    final document =
        await FirebaseFirestore.instance.collection('gunun_konusu').doc().get();
    if (document.exists) {
      _gununKonusu = document.data()?['gunun_konusu'];
      notifyListeners();
    }
  }
}
