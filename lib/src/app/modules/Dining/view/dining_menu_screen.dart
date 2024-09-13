import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/appbar_dynamic_menu_screen.dart';
import '../widgets/appbar_qr_screen.dart';

class DiningMenuScreen extends StatefulWidget {
  const DiningMenuScreen({
    super.key,
    required this.loadingRequestUrl,
  });

  final String loadingRequestUrl;

  @override
  State<DiningMenuScreen> createState() => _DiningMenuScreenState();
}

class _DiningMenuScreenState extends State<DiningMenuScreen> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    controller
      ..loadRequest(Uri.parse(widget.loadingRequestUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          Navigator.pushNamed(context, '/').then((value) => false),
      child: Scaffold(
        backgroundColor: Colors.white,
        //appbar
        appBar: const AppbarDynamicMenuScreen(),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
