import 'package:egitim/const/textStyle.dart';
import 'package:flutter/material.dart';

class KaydetButton extends StatelessWidget {
  final String text;
  const KaydetButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    StyleTextProject styleTextProject = StyleTextProject();
    return SizedBox(
      width: Sizing().width,
      child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
          ),
          child: Text(text, style: styleTextProject.SorunKaydetButton)),
    );
  }
}
