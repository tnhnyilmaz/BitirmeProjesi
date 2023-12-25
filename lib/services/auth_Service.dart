import 'package:bitirme_egitim_sorunlari/Provider/AuthProvider.dart';
import 'package:bitirme_egitim_sorunlari/model/kullanicilar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("kullanicilar");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(String name, String lastname, String password,
      String email, BuildContext context) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        registerUser(name, lastname, password, email);
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  Future<void> registerUser(
      String name, String lastname, String password, String email) async {
    await userCollection.doc().set({
      "email": email,
      "password": password,
      "isim": name,
      "soyisim": lastname
    });
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;
        await getUserDataFromFirestore(userId, context);
        Fluttertoast.showToast(
            msg: "GİRİŞ BAŞARILI", toastLength: Toast.LENGTH_LONG);
        Navigator.pushNamed(context, '/AnaEkran');
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> getUserDataFromFirestore(
      String userId, BuildContext context) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("kullanicilar")
          .doc(userId)
          .get();

      // ignore: unnecessary_null_comparison
      if (userDoc != null) {
        // Firestore'dan gelen belgeden ad ve soyadı al
        String name = userDoc["isim"];
        String lastName = userDoc["soyisim"];
        String email = userDoc["email"];

        // Kullanıcı bilgilerini AuthProvider üzerinden güncelle
        Provider.of<KullaniciProvider>(context, listen: false).setUser(
          Kullanicilar(email: email, isim: name, soyisim: lastName, id: userId),
        );
      }
    } catch (e) {
      print("Firestore kullanıcı bilgilerini alma hatası: $e");
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await firebaseAuth.signOut().then((value) {
        Navigator.pushNamed(context, "/");
      });
      // Çıkış başarılı olduğunda ek işlemler yapabilirsiniz.
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<Map<String, dynamic>?> getKullaniciByEmail(String email) async {
    try {
      // Firestore sorgusu ile email'e göre kullanıcıyı getir
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('kullanicilar')
          .where('email', isEqualTo: email)
          .get();

      // Eğer kullanıcı bulunduysa, belgeyi al ve içeriğini geri döndür
      if (querySnapshot.size > 0) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        return userDoc.data() as Map<String, dynamic>;
      } else {
        // Kullanıcı bulunamadıysa null döndür
        return null;
      }
    } catch (e) {
      print("Kullanıcı getirme hatası: $e");
      return null;
    }
  }

  // Future<void> getUserDataFromFirestore(
  //     String userId, BuildContext context) async {
  //   try {
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection("kullanicilar")
  //         .doc(userId)
  //         .get();

  //     if (userDoc.exists) {
  //       // Firestore'dan gelen belgeden ad ve soyadı al
  //       String name = userDoc["isim"];
  //       String lastName = userDoc["soyisim"];
  //       String email = userDoc["email"];

  //       // Kullanıcı bilgilerini AuthProvider üzerinden güncelle
  //       Provider.of<KullaniciProvider>(context, listen: false).setUser(
  //           Kullanicilar(
  //               email: email, isim: name, soyisim: lastName, id: userId));
  //     }
  //   } catch (e) {
  //     print("Firestore kullanıcı bilgilerini alma hatası: $e");
  //   }
  // }
}
