import 'package:egitim/const/textStyle.dart';
import 'package:flutter/material.dart';

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GeneralAppBar(
      {Key? key, required this.styleTextProject, required this.title})
      : super(key: key);

  final StyleTextProject styleTextProject;
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(title, style: styleTextProject.Appbar1),
      backgroundColor: Colors.amber,
    );
  }
}
