class SorunModel {
  String? documentID;
  String kullaniciID;
  String sorunMetni;

  SorunModel({
    required this.documentID,
    required this.kullaniciID,
    required this.sorunMetni,
  });

  factory SorunModel.fromFirestore(
      Map<String, dynamic> data, String documentID) {
    return SorunModel(
      documentID: documentID,
      kullaniciID: data['kullaniciID'] ?? '',
      sorunMetni: data['sorunMetni'] ?? '',
    );
  }
}
