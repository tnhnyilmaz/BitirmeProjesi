import 'package:bitirme_egitim_sorunlari/Provider/AuthProvider.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/services/auth_Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController lastnameCont = TextEditingController();

  StyleTextProject styleTextProject = StyleTextProject();
  AuthService _authService = AuthService();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    String? userId =
        Provider.of<KullaniciProvider>(context, listen: false).userId;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 176, 7), Colors.amberAccent],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child: topTexts(),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: mailPasswordField(context)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column topTexts() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kayıt Ol!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.w800,
            shadows: [
              Shadow(
                offset: const Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
        ),
        // const SizedBox(
        //   height: 2,
        // ),
        Text(
          "Sorun ve çözümlerde pay sahibi ol!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w200,
            shadows: [
              Shadow(
                offset: const Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column mailPasswordField(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: emailCont,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: const Color(0xFFe7edeb),
              hintText: "E-Mail",
              prefixIcon: Icon(
                Icons.email,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: passwordCont,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: const Color(0xFFe7edeb),
                hintText: "Password",
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.grey[600],
                ),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(_obscureText
                        ? Icons.visibility
                        : Icons.visibility_off_outlined))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: nameCont,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: const Color(0xFFe7edeb),
              hintText: "İsim",
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: lastnameCont,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: const Color(0xFFe7edeb),
              hintText: "Soyisim",
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ElevatedButton(
                onPressed: () {
                  _authService.signUp(nameCont.text, lastnameCont.text,
                      passwordCont.text, emailCont.text, false, context);
                  Navigator.pushNamed(context, "/");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                child: const Text(
                  "Kayıt Ol",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/");
              },
              child: Text(
                "Üye misiniz? Giriş Yap!",
                style: styleTextProject.loginText,
              ))
        ]);
  }
}
