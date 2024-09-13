import '../../../widgets/appbar_without_back_button.dart';
import '../../../../core/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithOutBackButton(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ordersuccess.png',
              scale: 1,
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/main-screen");
                },
                child: const Text(
                  "Back to home",
                  style: TextStyle(fontSize: 16, color: PRIMARY_COLOR),
                ))
          ],
        ),
      ),
    );
  }
}
