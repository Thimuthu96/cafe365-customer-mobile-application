import 'package:flutter/material.dart';

class DiningAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const DiningAppBarHome({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AppBar(
        backgroundColor: const Color(0xfff9fafc),
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width / 1,
        leading: Image.asset(
          'assets/images/Logo.png',
          scale: 1,
        ),
      ),
    );
  }
}
