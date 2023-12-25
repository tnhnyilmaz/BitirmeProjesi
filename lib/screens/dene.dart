import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
import 'package:flutter/material.dart';
// FirestoreService'ın olduğu yolu ayarlayın

class SorunListesi extends StatefulWidget {
  @override
  _SorunListesiState createState() => _SorunListesiState();
}

class _SorunListesiState extends State<SorunListesi> {
  FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> sorunlar = [];

  @override
  void initState() {
    super.initState();
    _getSorunlar();
  }

  Future<void> _getSorunlar() async {
    // List<Map<String, dynamic>> sorunlar = await _firestoreService.getSorunlar();
    setState(() {
      this.sorunlar = sorunlar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sorun Listesi"),
      ),
      body: ListView.builder(
        itemCount: sorunlar.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(sorunlar[index]['sorunMetni']),
            subtitle: Text('Kullanıcı ID: ${sorunlar[index]['kullaniciID']}'),
          );
        },
      ),
    );
  }
}
