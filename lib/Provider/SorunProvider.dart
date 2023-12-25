import 'package:bitirme_egitim_sorunlari/screens/a.dart';
import 'package:flutter/material.dart';

class SelectedSorunProvider extends ChangeNotifier {
  SorunModel? _selectedSorun;

  SorunModel? get selectedSorun => _selectedSorun;

  void setSelectedSorun(SorunModel sorun) {
    _selectedSorun = sorun;
    notifyListeners();
  }

  String? _selectedSorunDocumentID;
  String? get selectedSorunDocumentID => _selectedSorunDocumentID;

  void setSelectedSorunDocumentID(String documentID) {
    _selectedSorunDocumentID = documentID;
    notifyListeners();
  }
}
