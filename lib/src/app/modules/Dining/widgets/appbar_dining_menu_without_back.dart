import 'package:cafe_365_app/src/core/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../mainscreen/views/order-type-screen.dart';

class AppbarDiningMenuWithoutBack extends StatelessWidget
    implements PreferredSizeWidget {
  const AppbarDiningMenuWithoutBack({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xfff9fafc),
      elevation: 0,
      leadingWidth: 80,
      leading: TextButton(
        onPressed: () {
          Get.offAll(OrderTypeScreen());
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
        padding: const EdgeInsets.only(left: 80),
        child: Image.asset(
          'assets/images/Logo.png',
          scale: 4,
        ),
      ),
    );
  }
}
