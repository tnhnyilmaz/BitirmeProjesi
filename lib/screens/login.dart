import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            ),
          ),
          TextButton(
              onPressed: () {},
              child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Şİfrenizi mi unuttunuz?",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 2, 114, 243)),
                  ))),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/AnaEkran');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                child: const Text(
                  "Giriş",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
          "Eğitimde Yeni Yolculuklar,\nSorunları Birlikte Çöz!",
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
