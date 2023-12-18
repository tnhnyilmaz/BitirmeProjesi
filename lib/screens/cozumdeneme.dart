import 'package:bitirme_egitim_sorunlari/Provider/SorunProvider.dart';
import 'package:bitirme_egitim_sorunlari/compenents/generalAppbar.dart';
import 'package:bitirme_egitim_sorunlari/compenents/inputTextField.dart';
import 'package:bitirme_egitim_sorunlari/compenents/kaydetButton.dart';
import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:bitirme_egitim_sorunlari/screens/a.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SorunCozum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SorunModel selectedSorun =
        Provider.of<SelectedSorunProvider>(context).selectedSorun!;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController cozumController = TextEditingController();
    StyleTextProject styleTextProject = StyleTextProject();

    return Scaffold(
      appBar: GeneralAppBar(
        styleTextProject: styleTextProject,
        title: "Sorun Çöz",
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: width,
                height: height * 0.2,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    selectedSorun.sorunMetni,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              InputTextField(
                controller: cozumController,
                labeltext: "Sorun",
              ),
              const SizedBox(height: 15),
              KaydetButton(
                text: "Çözümü Kaydet",
                onPressed: () {
                  // Burada çözümü kaydetme işlemleri gerçekleştirilebilir
                  String cozumMetni = cozumController.text;
                  // Çözümü kullanmak için işlemler yapabilirsiniz
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
