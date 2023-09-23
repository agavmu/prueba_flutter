import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar(
      {super.key,
      required this.title,
      this.leading,
      this.titleWidget,
      this.style});

  final String title;
  final TextStyle? style;
  final Widget? leading;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25 / 2.5),
      child: Stack(
        children: [
          Positioned.fill(
              child: titleWidget == null
                  ? Center(child: Text(title, style: style))
                  : Center(
                      child: titleWidget,
                    ))
        ],
      ),
    ));
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 60);
}
