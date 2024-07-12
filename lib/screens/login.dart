import 'package:bitirme_egitim_sorunlari/Provider/AuthProvider.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/services/auth_Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

AuthService authService = AuthService();
bool _obscureText = true;

class _LoginState extends State<Login> {
  StyleTextProject styleText = StyleTextProject();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                flex: 2,
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
                    child: mailPasswordField(context),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
            obscureText: _obscureText,
            keyboardType: TextInputType.emailAddress,
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
          TextButton(
              onPressed: () {},
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Şİfrenizi mi unuttunuz?",
                    style: styleText.loginText,
                  ))),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ElevatedButton(
                onPressed: () async {
                  if (emailCont.text.isEmpty || passwordCont.text.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("HATA!"),
                            content: Text("Lütfen Tüm Alanları Doldurunuz!"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Dialog'u kapat
                                  Navigator.pushNamed(context, "/");
                                },
                                child: const Text(
                                  "Tamam",
                                ),
                              ),
                            ],
                          );
                        });
                  } else {
                    authService
                        .signIn(emailCont.text, passwordCont.text, context)
                        .then((kullanici) {
                      Provider.of<KullaniciProvider>(context, listen: false)
                          .setUser(kullanici!);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                child: const Text(
                  "Giriş",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Register');
                },
                child: Text(
                  "Hesabınız Yok mu? Kayıt Ol!",
                  style: styleText.loginText,
                )),
          )
        ]);
  }

  Column topTexts() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Giriş Yap",
          style: TextStyle(
            color: Colors.white,
            fontSize: 46,
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
        const SizedBox(
          height: 5,
        ),
        Text(
          "Sorun ve çözümlerde pay sahibi ol!,\nSorunları Birlikte Çöz!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w300,
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
}
