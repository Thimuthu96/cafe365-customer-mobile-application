import 'package:cafe_365_app/src/core/consts/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/consts/colors.dart';
import '../widgets/appbar_qr_screen.dart';
import 'dining_menu_screen.dart';
import 'dynamic_menu_screen.dart';

class QrScanScreen extends StatefulWidget {
  final String? orderType;
  const QrScanScreen({
    super.key,
    this.orderType,
  });

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = '';

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarQrScreen(),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.blue,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 10),
            //     child: Text('QR Code: $qrText'),
            //   ),
            // ),
            const SizedBox(height: 100),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              height: 50,
              child: ClipRRect(
                child: ElevatedButton(
                  onPressed: () {
                    _scanQRImageFromGallery();
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
                    'Select from gallery',
                    style: TextStyle(
                      fontSize: 16,
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code ?? '';
      });
      debugPrint('QR Code from camera: $qrText');
    });
  }

  void _scanQRImageFromGallery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Pick an image from the gallery
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Decode the QR code from the image
      String? qrContent = await QrCodeToolsPlugin.decodeFrom(pickedFile.path);
      if (qrContent != null) {
        setState(() {
          qrText = qrContent;
        });

        // String loadingUrl = '';
        // String? uuid = (prefs.getString(UUID))?.replaceAll('"', '');
        // widget.orderType == 'guestUsr'
        //     ? loadingUrl = '$qrContent/guest'
        //     : loadingUrl = '$qrContent/${uuid.toString()}';

        widget.orderType == 'guestUsr'
            ? Get.offAll(DynamicMenuScreen(loadingRequestUrl: qrContent))
            : Get.offAll(DiningMenuScreen(loadingRequestUrl: qrContent));

        // Navigator.pushNamed(context, '/dining-web-view', arguments: qrContent);
        debugPrint('QR Code from image: $qrContent');
      } else {
        debugPrint('No QR code found in the image.');
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
