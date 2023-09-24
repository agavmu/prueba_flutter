import 'package:flutter/material.dart';

class CustomAppbarHome extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbarHome({super.key, required this.text, this.leading});

  final Widget text;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25 / 2.5),
        child: AppBar(
            title: text,
            centerTitle: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            leading: leading
            // IconButton(
            //     onPressed: () {}, icon: Icon(Icons.chevron_left_outlined)),
            ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 76);
}
