// ignore_for_file: non_constant_identifier_names, avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';

class StyleTextProject {
  TextStyle Appbar1 = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );
  TextStyle SorunKaydetButton = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
  TextStyle DetaySorun =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle ListelemeSayac =
      const TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  TextStyle ListeSorun = const TextStyle(
      wordSpacing: 1, fontSize: 12, fontWeight: FontWeight.bold);
  TextStyle loginText = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Color.fromARGB(255, 2, 114, 243));
  EdgeInsets DetaySorunPadding = const EdgeInsets.only(left: 16, right: 10);

  double calculateContainerHeight(String metin) {
    double katsayi = 0.7; // Örnek bir katsayı
    return metin.length * katsayi;
  }
}
