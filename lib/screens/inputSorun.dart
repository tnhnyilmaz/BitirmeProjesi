import 'package:egitim/compenents/generalAppbar.dart';
import 'package:egitim/compenents/inputTextField.dart';
import 'package:egitim/compenents/kaydetButton.dart';
import 'package:egitim/const/textStyle.dart';
import 'package:flutter/material.dart';

class SorunInput extends StatefulWidget {
  const SorunInput({super.key});

  @override
  State<SorunInput> createState() => _SorunInputState();
}

class _SorunInputState extends State<SorunInput> {
  @override
  Widget build(BuildContext context) {
    StyleTextProject styleTextProject = StyleTextProject();
    return Scaffold(
      appBar: GeneralAppBar(
          styleTextProject: styleTextProject, title: "Eğitim Sorunları"),
      body: const SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Wrap(
                        runSpacing: 15,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "Eğitimde olan sorunları aşağıda bulunan bölmelere maddeler halinde giriniz.",
                            style: TextStyle(fontSize: 15),
                          ),
                          InputTextField(),
                          InputTextField(),
                          InputTextField(),
                          InputTextField(),
                          InputTextField(),
                          KaydetButton(text: "Sorunları Kaydet"),
                        ],
                      )
                    ]),
              ],
            )),
      ),
    );
  }
}
