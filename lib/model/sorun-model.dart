class Sorun {
  String sorunID;
  final String sorunMetni;
  final String kullaniciID;

  Sorun({
    this.sorunID = '',
    required this.sorunMetni,
    required this.kullaniciID,
  });
  Map<String, dynamic> toJson() => {
        'sorunID': sorunID,
        'sorunMetni': sorunMetni,
        'kullaniciID': kullaniciID
      };
}
