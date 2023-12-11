import 'package:egitim/services/sorunListeleme.dart';
import 'package:flutter/material.dart';

class deneme extends StatelessWidget {
  deneme({super.key});

  bool isExpanded = false;
  final FirestoreService firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Sorunları'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: firestoreService.getSorunlar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          }
          return ListView(
            children: snapshot.data!.map((data) {
              return ListTile(
                title: Text(data['sorunMetni']),
                subtitle: Text(
                    'Sorun ID: ${data['sorunID']} | Kullanıcı ID: ${data['kullaniciID']}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class MyCard extends StatefulWidget {
  final String title;

  const MyCard({super.key, required this.title});

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Container(
              color: Colors.grey,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,
                    height: 35,
                    color: Colors.amber,
                    child: const Center(child: Text("Sorun Öner")),
                  ),
                  Container(
                    width: 150,
                    height: 35,
                    color: Colors.amber,
                    child: const Center(child: Text("Tüm çözümler")),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
