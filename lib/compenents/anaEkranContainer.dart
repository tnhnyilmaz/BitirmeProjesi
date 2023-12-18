import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  final String text;
  final String imageUrl;
  const HomeContainer({super.key, required this.text, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.2,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 176, 7),
              Colors.amberAccent
            ],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 15, bottom: 8, right: 15),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            Expanded(
              flex: 2,
              child: Image.network(imageUrl),
            ),
          ],
        ),
      ),
    );
  }
}
