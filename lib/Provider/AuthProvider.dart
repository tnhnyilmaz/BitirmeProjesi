import 'package:bitirme_egitim_sorunlari/model/kullanicilar.dart';
import 'package:bitirme_egitim_sorunlari/services/auth_Service.dart';
import 'package:flutter/foundation.dart';

class KullaniciProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Kullanicilar? _kullanicilar;
  Kullanicilar? get kullanicilar => _kullanicilar;

  void setUser(Kullanicilar kullanicilar) {
    _kullanicilar = kullanicilar;
    notifyListeners();
  }
}
