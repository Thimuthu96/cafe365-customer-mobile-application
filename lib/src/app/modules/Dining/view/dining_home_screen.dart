import 'package:flutter/material.dart';

import '../../../../core/consts/colors.dart';
import '../../../widgets/dining_appbar_home.dart';

class DiningHomeScreen extends StatelessWidget {
  const DiningHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DiningAppBarHome(),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 25,
              ),
              height: 600,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/images/qrScanBanner.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 50,
                child: ClipRRect(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/qr-scan",
                          arguments: 'guestUsr');
                    },
                    style: ButtonStyle(
                      side: WidgetStateProperty.all<BorderSide>(
                        const BorderSide(color: PRIMARY_COLOR, width: 2.0),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Scan QR',
                      style: TextStyle(
                        fontSize: 16,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
