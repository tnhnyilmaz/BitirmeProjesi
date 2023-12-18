import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField(
      {super.key, required this.controller, required this.labeltext});
  final TextEditingController controller;
  final String labeltext;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(width: 5)),
          labelText: labeltext,
        ),
      ),
    );
  }
}
