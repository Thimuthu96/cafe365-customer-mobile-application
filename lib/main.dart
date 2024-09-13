import 'package:cafe_365_app/src/core/consts/constants.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'src/app/modules/cart/controller/cartController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  await _setUp();
  runApp(MyApp());
}

Future<void> _setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = STRIPE_PUBLISHABLE_KEY;
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    //change status bar color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(255, 198, 198, 198)),
    );

    return Builder(
      builder: (context) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          onGenerateRoute: CustomRouter.generateRoute,
          scaffoldMessengerKey: cartController.scaffoldMessengerKey,
        );
      },
    );
  }
}
