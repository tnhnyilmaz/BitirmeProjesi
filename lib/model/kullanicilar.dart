class Kullanicilar {
  final String isim;
  final String soyisim;
  final String email;
  final String id;

  Kullanicilar(
      {required this.email,
      required this.isim,
      required this.soyisim,
      required this.id});

  Map<String, dynamic> toJson() =>
      {"isim": isim, "soyisim": soyisim, "email": email};

  factory Kullanicilar.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return Kullanicilar(
      email: data['email'],
      isim: data['isim'],
      soyisim: data['soyisim'],
      id: documentId,
    );
  }
}
