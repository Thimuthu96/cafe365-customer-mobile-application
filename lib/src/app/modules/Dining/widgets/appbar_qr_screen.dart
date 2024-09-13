import 'package:flutter/material.dart';

class AppBarQrScreen extends StatelessWidget implements PreferredSizeWidget {
  const AppBarQrScreen({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AppBar(
        backgroundColor: const Color(0xfff9fafc),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black54,
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 90),
          child: Image.asset(
            'assets/images/Logo.png',
            scale: 4,
          ),
        ),
      ),
    );
  }
}
