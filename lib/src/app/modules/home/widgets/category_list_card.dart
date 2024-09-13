import 'package:flutter/material.dart';

import '../../../../core/consts/colors.dart';

class CategoryListCard extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTapCard;

  CategoryListCard({
    Key? key,
    required this.title,
    required this.isActive,
    required this.onTapCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color txtColor = isActive ? Colors.white : TITLE_COLOR;
    return GestureDetector(
      onTap: onTapCard,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color:
              isActive ? PRIMARY_COLOR : const Color.fromARGB(68, 2, 180, 32),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: txtColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
