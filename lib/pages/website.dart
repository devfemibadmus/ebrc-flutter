import 'package:ebrc/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebsitePage extends StatefulWidget {
  const WebsitePage({super.key});

  @override
  WebsitePageState createState() => WebsitePageState();
}

class WebsitePageState extends State<WebsitePage> {
  Widget body = const Center(
    child: Text(
      "Unable to connect to the internet.",
      style: TextStyle(color: Colors.red),
    ),
  );
  bool error = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "This is our website page, contact us @ebrc on telegram",
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Website"),
        ),
        body: error == true
            ? body
            : WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(const Color(0x00000000))
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onWebResourceError: (WebResourceError error) {
                        webError();
                      },
                      onNavigationRequest: (NavigationRequest request) {
                        return NavigationDecision.navigate;
                      },
                    ),
                  )
                  ..loadRequest(websiteUrl),
              ),
      ),
    );
  }

  void webError() {
    setState(() {
      error = true;
    });
  }
}
