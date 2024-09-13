import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/appbar_dining_menu_without_back.dart';

class DynamicMenuScreen extends StatefulWidget {
  const DynamicMenuScreen({
    super.key,
    required this.loadingRequestUrl,
  });

  final String loadingRequestUrl;

  @override
  State<DynamicMenuScreen> createState() => _DynamicMenuScreenState();
}

class _DynamicMenuScreenState extends State<DynamicMenuScreen> {
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
        appBar: const AppbarDiningMenuWithoutBack(),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
