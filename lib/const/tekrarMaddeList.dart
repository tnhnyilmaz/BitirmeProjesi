class TekrarMadde {
  Map<String, List<String>> kategoriler = {
    'Dijital Öğrenim': ['Dijital', 'Teknoloji'],
    'Öğrenci Katılımı': ['Öğrenci', 'Katılım'],
    'Sınıf Mevcudiyeti': ['Sınıf', 'Mevcut', 'kalabalık', 'fazla'],
    'Öğretmen Sayısı': ['Öğretmen', 'Sayı', 'kalite'],
    'Müfredat Zorluğu': ['Müfredat', 'Zorluk'],
  };

  Map<String, int> kategoriSayac = {};

  void kategoriyeGoreSayaciArtir(String sorun) {
    for (var entry in kategoriler.entries) {
      var kategoriAdi = entry.key;
      var anahtarKelimeler = entry.value;

      for (var kelime in anahtarKelimeler) {
        if (sorun.toLowerCase().contains(kelime.toLowerCase())) {
          kategoriSayac[kategoriAdi] = (kategoriSayac[kategoriAdi] ?? 0) + 1;
          break;
        }
      }
    }
  }

  void enCokTekrarlananKategorileriBul(List<String> sorunlar) {
    var siraliKategoriler = kategoriSayac.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    var enCokTekrarlanan5Kategori = <String>[];

    for (var i = 0; i < 5 && i < siraliKategoriler.length; i++) {
      var kategoriAdi = siraliKategoriler[i].key;
      var ilkSorun = sorunlar.firstWhere(
          (sorun) => kategorilereGoreKontrol(sorun, kategoriAdi),
          orElse: () => 'Bir sorun bulunamadı.');

      enCokTekrarlanan5Kategori.add(kategoriAdi);
      enCokTekrarlanan5Kategori.add(ilkSorun);
    }

    print("En Çok Tekrarlanan 5 Kategori ve İlk Sorunları:");
    for (var i = 0; i < 10; i += 2) {
      print(
          "${i ~/ 2 + 1}. Kategori: ${enCokTekrarlanan5Kategori[i]}, İlk Sorun: ${enCokTekrarlanan5Kategori[i + 1]}");
    }
  }

  bool kategorilereGoreKontrol(String sorun, String kategori) {
    var anahtarKelimeler = kategoriler[kategori] ?? [];
    for (var kelime in anahtarKelimeler) {
      if (sorun.toLowerCase().contains(kelime.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}
