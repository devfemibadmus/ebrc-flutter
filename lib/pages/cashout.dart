import 'package:ebrsng/constants/variables.dart';
import 'package:ebrsng/constants/database.dart';
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
  late WebViewController webViewController;
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
                  "${user!.account_name}, ${user.account_number}, ${user.account_uname}";

              if (error == true) {
                return const Center(
                  child: Text(
                    "Unable to connect to the internet.",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (user.account_editable == true) {
                return const Center(
                  child: Text(
                    "Go to settings and set your bank details to recieve payments.",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (user.pending_cashout == true) {
                return const Center(
                  child: Text(
                    "Oops! you have a pending withdraw check your notification or await 24hrs for the payment.",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return Stack(
                  children: <Widget>[
                    WebView(
                      zoomEnabled: false,
                      onWebResourceError: (error) {
                        //print("An error occurred: ${error.description}");
                        webError();
                      },
                      initialUrl: cashOutUrl.toString(),
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (controller) {
                        setState(
                          () {
                            webViewController = controller;
                          },
                        );
                      },
                      onPageFinished: (url) {
                        setState(() {
                          webloaded = true;
                        });
                        webViewController.runJavascript(
                          """
                      function fillLoginData() {
                        document.getElementById('username').value='${user.username}';
                        document.getElementById('password').value='${user.password}';
                        document.getElementById('banking').innerHTML='$bank';
                        setCurrentBalance(${user.account_balance});
                      }
                      fillLoginData();
                    """,
                        );
                      },
                    ),
                    webloaded == false
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: kPrimaryLightColor))
                        : Stack(),
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
