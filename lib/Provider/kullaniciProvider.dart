import 'package:bitirme_egitim_sorunlari/model/kullanicilar.dart';
import 'package:flutter/material.dart';

class KullaniciProvider extends ChangeNotifier {
  Kullanicilar? _kullanicilar;
  Kullanicilar? get kullanicilar => _kullanicilar;
}
