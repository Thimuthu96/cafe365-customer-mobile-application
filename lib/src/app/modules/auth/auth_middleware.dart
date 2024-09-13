// ignore_for_file: use_build_context_synchronously

import 'package:cafe_365_app/src/app/modules/mainscreen/views/main-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login/views/login.dart';
import '../register/controller/user_controller.dart';

class AuthController extends GetxController {
  //create instance of Authcontroller
  static AuthController instance = Get.find();
  bool isAuth = false;

  //email, password, username from firebase
  late Rx<User?> user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    user = Rx<User?>(auth.currentUser);
    user.bindStream(auth.userChanges()); //app notify when user login, logout

    ever(user, _checkAuth); //listening user
  }

  _checkAuth(User? user) async {
    if (user == null) {
      debugPrint('Need to login');
      isAuth = false;
    } else {
      debugPrint('User logged in');
      isAuth = true;
    }
  }

  // void userSignUp(String email, password) async {
  //   try {
  //     await auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     Get.offAll(LoginPage());
  //   } catch (err) {
  //     Get.snackbar(
  //       'About user',
  //       'User message',
  //       snackPosition: SnackPosition.BOTTOM,
  //       titleText: const Text(
  //         'Account creation failed!',
  //         style: TextStyle(
  //           color: Colors.white,
  //         ),
  //       ),
  //       messageText: Text(
  //         err.toString(),
  //         style: const TextStyle(
  //           color: Colors.white,
  //         ),
  //       ),
  //     );
  //   }
  // }

  void userLogin(BuildContext context, String email, password) async {
    final UserController userController = Get.put(UserController());
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      await userController.fetchUserId(context, email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Login successful!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: Duration(milliseconds: 2000),
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        closeIconColor: Colors.blueGrey,
      ));
      Get.offAll(const MainScreen());
    } catch (err) {
      Get.snackbar(
        'About user',
        'Login message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[700],
        titleText: const Text(
          'Login Failed!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          err.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  void userLogout() async {
    await auth.signOut();
    await Future(
      () {
        Get.snackbar(
          'About user',
          'Logout message',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[400],
          titleText: const Text(
            'Success!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          messageText: const Text(
            'Logged out successfully!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
    Get.offAll(LoginPage());
  }
}
