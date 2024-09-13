import 'package:cafe_365_app/src/app/modules/mainscreen/views/order-type-screen.dart';

import '../../login/views/login.dart';
import '../../mainscreen/views/main-screen.dart';
import '../../../../core/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/auth_middleware.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthController _authController;
  bool animate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authController = Get.put(AuthController());
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 300),
              child: Image.asset(
                'assets/images/loginLogo.png',
                scale: 1,
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  Text(
                    'Food at Your Fingertips',
                    style: TextStyle(
                        fontSize: 18, letterSpacing: 3, color: Colors.black87),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Easy | Fast | Delicious',
                    style: TextStyle(
                        fontSize: 12, letterSpacing: 8, color: PRIMARY_COLOR),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your Taste',
                    style: TextStyle(fontSize: 14, letterSpacing: 8),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future checkAuth() async {
    // await Future.delayed(
    //   const Duration(milliseconds: 500),
    // );
    // setState(() => animate = true);
    await Future.delayed(
      const Duration(milliseconds: 2500),
    );

    Get.offAll(OrderTypeScreen());

    // await Future(
    //   () {
    //     if (_authController.isAuth == true) {
    //       Get.offAll(const MainScreen());
    //     } else {
    //       Get.offAll(LoginPage());
    //     }
    //   },
    // );

    // ignore: use_build_context_synchronously
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => const Login()),
    //   (route) => false,
    // );
  }
}
