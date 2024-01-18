import 'package:ebrc/constants/variables.dart';
import 'package:ebrc/constants/database.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CashPage extends StatefulWidget {
  const CashPage({super.key});

  @override
  CashPageState createState() => CashPageState();
}

class CashPageState extends State<CashPage> {
  bool error = false;
  bool webloaded = false;
  Widget web = Container();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Cashout Page",
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cash Out"),
        ),
        body: FutureBuilder<Account>(
          future: getAccountFromSharedPrefs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Account? user = snapshot.data;
              String bank =
                  "${user!.accountName}, ${user.accountNumber}, ${user.accountUname}";

              if (error == true) {
                return const Center(
                  child: Text(
                    "Unable to connect to the internet.",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (user.accountEditable == true) {
                return const Center(
                  child: Text(
                    "Go to settings and set your bank details to recieve payments.",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (user.pendingCashout == true) {
                return const Center(
                  child: Text(
                    "Oops! you have a pending withdraw check your notification or await 24hrs for the payment.",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return Stack(
                  children: <Widget>[
                    WebViewWidget(
                      controller: WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..setBackgroundColor(const Color(0x00000000))
                        ..setNavigationDelegate(
                          NavigationDelegate(
                            onProgress: (int progress) {
                              setState(() {
                                webloaded = false;
                              });
                            },
                            onPageStarted: (String url) {
                              setState(() {
                                webloaded = false;
                              });
                            },
                            onPageFinished: (String url) {
                              setState(() {
                                webloaded = true;
                              });
                            },
                            onWebResourceError: (WebResourceError error) {
                              webError();
                            },
                            onNavigationRequest: (NavigationRequest request) {
                              return NavigationDecision.navigate;
                            },
                          ),
                        )
                        ..loadRequest(cashOutUrl)
                        ..runJavaScript(
                          """
                      function fillLoginData() {
                        document.getElementById('username').value='${user.username}';
                        document.getElementById('password').value='${user.password}';
                        document.getElementById('banking').innerHTML='$bank';
                        setCurrentBalance(${user.accountBalance});
                      }
                      fillLoginData();
                    """,
                        ),
                    ),
                    webloaded == false
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: kPrimaryLightColor))
                        : const Stack(),
                  ],
                );
              }
            }
            return const Center(
                child: CircularProgressIndicator(color: kPrimaryLightColor));
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
