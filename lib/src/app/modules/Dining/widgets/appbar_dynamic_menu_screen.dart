import 'package:flutter/material.dart';

import '../../../../core/consts/colors.dart';

class AppbarDynamicMenuScreen extends StatelessWidget
    implements PreferredSizeWidget {
  const AppbarDynamicMenuScreen({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AppBar(
        backgroundColor: const Color(0xfff9fafc),
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/main-screen');
          },
          child: const Row(
            children: [
              Icon(
                Icons.logout_outlined,
                size: 18, // Adjusted size
                color: PRIMARY_COLOR,
              ),
              Flexible(
                child: Text(
                  'Exit',
                  style: TextStyle(
                    fontSize: 12,
                    color: PRIMARY_COLOR,
                  ),
                ),
              ),
            ],
          ),
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
