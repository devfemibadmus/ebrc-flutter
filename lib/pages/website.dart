import 'package:ebrsng/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

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
      label: "This is our website page, contact us @ebrsng on telegram",
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Website"),
        ),
        body: error == true
            ? body
            : WebViewPlus(
                initialUrl: websiteUrl.toString(),
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('http://') ||
                      request.url.startsWith('https://')) {
                    return NavigationDecision.navigate;
                  }
                  // If the URL is not a http(s) link, do not allow navigation
                  return NavigationDecision.prevent;
                },
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
