import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../core/consts/colors.dart';

class DefaultNavigationBar extends StatefulWidget {
  final Function(int) getIndex;
  const DefaultNavigationBar({
    Key? key,
    required this.getIndex,
  }) : super(key: key);

  @override
  State<DefaultNavigationBar> createState() => _DefaultNavigationBarState();
}

class _DefaultNavigationBarState extends State<DefaultNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: Platform.isIOS
            ? const EdgeInsets.symmetric(horizontal: 25, vertical: 12)
            : const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: GNav(
          backgroundColor: PRIMARY_COLOR,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: const Color.fromARGB(113, 65, 248, 166),
          gap: 5,
          padding: const EdgeInsets.all(15),
          onTabChange: (index) {
            widget.getIndex(index);
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
              active: true,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GButton(
              icon: Icons.qr_code,
              text: 'Dining',
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GButton(
              icon: Icons.shopping_cart,
              text: 'Cart',
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
