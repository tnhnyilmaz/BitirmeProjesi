import 'package:bitirme_egitim_sorunlari/const/textStyle.dart';
import 'package:flutter/material.dart';

class KaydetButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const KaydetButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context as BuildContext).size.width;
    double height = MediaQuery.of(context as BuildContext).size.height;
    StyleTextProject styleTextProject = StyleTextProject();
    return SizedBox(
      width: width,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
          ),
          child: Text(text, style: styleTextProject.SorunKaydetButton)),
    );
  }
}
