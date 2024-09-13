// ignore_for_file: use_build_context_synchronously

import 'package:cafe_365_app/src/app/modules/auth/auth_middleware.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/consts/colors.dart';
import '../../../../core/consts/constants.dart';
import '../../../widgets/default_appbar_home.dart';
import '../../cart/controller/cartController.dart';
import '../../register/controller/user_controller.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController userController = Get.put(UserController());
  final CartController cartController = Get.put(CartController());
  final AuthController authController = Get.put(AuthController());
  late double points;
  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userController.userName.value = prefs.getString(USER_NAME) ?? "";
    String? uuid = (prefs.getString(UUID))?.replaceAll('"', '');
    //get loyalty points
    await userController.fetchUserLoyaltyPoints(context, uuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefautAppBarHome(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/images/profilepic.jpg',
                        scale: 2,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userController.userName.value.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: TITLE_COLOR,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Points : ${userController.userPoints.value}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: TITLE_COLOR,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: PRIMARY_COLOR,
                      width: 1,
                      style: BorderStyle.solid)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BG_COLOR,
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/my-orders");
                },
                child: const Text(
                  "My Orders",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: PRIMARY_COLOR,
                      width: 1,
                      style: BorderStyle.solid)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BG_COLOR,
                  elevation: 0,
                ),
                onPressed: () {},
                child: const Text(
                  "Wishlists",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextButton(
              onPressed: () async {
                await Future(() {
                  AuthController.instance.userLogout();
                });
                Navigator.pushNamed(context, "/login");
              },
              child: const Text(
                "Logout",
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
