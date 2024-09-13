import 'package:flutter/material.dart';

import '../../../../core/consts/colors.dart';
import '../../../widgets/dining_appbar_home.dart';
import '../widgets/diningConfiremationDialog.dart';

class Confirmationscreen extends StatefulWidget {
  const Confirmationscreen({super.key});

  @override
  State<Confirmationscreen> createState() => _ConfirmationscreenState();
}

class _ConfirmationscreenState extends State<Confirmationscreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showEntranceConfirmation(context);
    });
  }

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
                      Navigator.pushNamed(context, "/qr-scan");
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

  showEntranceConfirmation(BuildContext context) {
    DiningConfirmationDialog(
      context,
      "Confirmation!",
      "Are you sure switch to dining order mode?",
      () {
        // goCheckout();
      },
      () {
        Navigator.pushNamed(context, "/main-screen");
      },
    );
  }
}
