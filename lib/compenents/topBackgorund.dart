import 'package:flutter/material.dart';

class TopBackground extends StatelessWidget {
  const TopBackground({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFFBC02D), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Image.network(
            "https://t4.ftcdn.net/jpg/04/50/72/13/360_F_450721320_bmVwBx0lQiyWvQLqkMqAUQHVP88pKtSc.jpg",
            fit: BoxFit.fill,
            width: width,
            height: height,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Merhaba Tuna,",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.logout,
                      size: 30,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
