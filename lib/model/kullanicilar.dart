class Kullanicilar {
  final String isim;
  final String soyisim;
  final String email;
  final String id;
  bool role;

  Kullanicilar(
      {required this.email,
      required this.isim,
      required this.soyisim,
      required this.id,
      required this.role});

  Map<String, dynamic> toJson() =>
      {"isim": isim, "soyisim": soyisim, "email": email, "role": role};

  factory Kullanicilar.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return Kullanicilar(
      email: data['email'],
      isim: data['isim'],
      soyisim: data['soyisim'],
      role: data['role'],
      id: documentId,
    );
  }
}
