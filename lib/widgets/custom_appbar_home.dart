import 'package:flutter/material.dart';

class CustomAppbarHome extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbarHome({super.key, required this.text});

  final Widget text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 25 / 2.5),
            child: Center(
              child: Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  padding: const EdgeInsets.only(top: 35),
                  child: Center(child: text),
                ),
              ),
            )));
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 120);
}
