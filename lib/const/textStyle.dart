// ignore_for_file: non_constant_identifier_names, avoid_web_libraries_in_flutter

import 'dart:js';

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
  TextStyle ListelemeSayac =
      const TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  TextStyle ListeSorun =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
}

class Sizing {
  double width = MediaQuery.of(context as BuildContext).size.width;
  double height = MediaQuery.of(context as BuildContext).size.height;
}
