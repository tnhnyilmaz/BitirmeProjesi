import 'package:egitim/compenents/generalAppbar.dart';
import 'package:egitim/compenents/inputTextField.dart';
import 'package:egitim/compenents/kaydetButton.dart';
import 'package:egitim/const/textStyle.dart';
import 'package:flutter/material.dart';

class InputSorunCozum extends StatelessWidget {
  const InputSorunCozum({super.key});

  @override
  Widget build(BuildContext context) {
    StyleTextProject styleTextProject = StyleTextProject();
    return Scaffold(
        appBar: GeneralAppBar(
            styleTextProject: styleTextProject, title: "Sorun Çöz"),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: Sizing().width,
                  height: Sizing().height * 0.2,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                      child: Text(
                    "SORUN",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  )),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Wrap(
                  runSpacing: 15,
                  children: [
                    InputTextField(),
                    InputTextField(),
                    InputTextField(),
                    KaydetButton(text: "Çözümleri Kaydet"),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
