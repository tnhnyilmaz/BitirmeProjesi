class SorunModel {
  final String documentID;
  final String sorunMetni;
  final String kullaniciID;

  SorunModel({
    required this.documentID,
    required this.sorunMetni,
    required this.kullaniciID,
  });

  factory SorunModel.fromMap(Map<String, dynamic> map) {
    return SorunModel(
      documentID: map['documentID'] ?? '', // Boş gelirse varsayılan değeri atar
      sorunMetni: map['sorunMetni'] ?? '',
      kullaniciID: map['kullaniciID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'documentID': documentID,
        'sorunMetni': sorunMetni,
        'kullaniciID': kullaniciID,
      };
}
