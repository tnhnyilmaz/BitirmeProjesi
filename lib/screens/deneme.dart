// import 'package:bitirme_egitim_sorunlari/services/sorunListeleme.dart';
// import 'package:flutter/material.dart';

// class deneme extends StatelessWidget {
//   deneme({super.key});

//   bool isExpanded = false;
//   final FirestoreService firestoreService = FirestoreService();
//   final TextEditingController kullaniciIdController = TextEditingController();
//   final TextEditingController sorunMetniController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firestore Input Page'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: kullaniciIdController,
//               decoration: InputDecoration(labelText: 'Kullanıcı ID'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: sorunMetniController,
//               decoration: InputDecoration(labelText: 'Sorun Metni'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 _addToFirestore();
//               },
//               child: Text('Firestore\'a Ekle'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _addToFirestore() {
//     String kullaniciId = kullaniciIdController.text;
//     String sorunMetni = sorunMetniController.text;

//     // FirestoreService sınıfını kullanarak Firestore'a ekleme işlemi
//     FirestoreService().addSorun(kullaniciId, sorunMetni,"da");

//     // Ekleme işleminden sonra text alanlarını temizle
//     kullaniciIdController.clear();
//     sorunMetniController.clear();
//   }
// }

// class MyCard extends StatefulWidget {
//   final String title;

//   const MyCard({super.key, required this.title});

//   @override
//   _MyCardState createState() => _MyCardState();
// }

// class _MyCardState extends State<MyCard> {
//   bool _isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         children: [
//           ListTile(
//             title: Text(widget.title),
//             trailing: IconButton(
//               icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
//               onPressed: () {
//                 setState(() {
//                   _isExpanded = !_isExpanded;
//                 });
//               },
//             ),
//           ),
//           if (_isExpanded)
//             Container(
//               color: Colors.grey,
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: 150,
//                     height: 35,
//                     color: Colors.amber,
//                     child: const Center(child: Text("Sorun Öner")),
//                   ),
//                   Container(
//                     width: 150,
//                     height: 35,
//                     color: Colors.amber,
//                     child: const Center(child: Text("Tüm çözümler")),
//                   )
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
