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

              if (error == true) {
                return const Center(
                  child: Text(
                    "Unable to connect to the internet.",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (user!.accountEditable == true) {
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
                return const Center(
                  child: Text(
                    "Send CashOut to devfemibadmus@gmail.com with your account email address and username",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
            }
            return const Center(
              child: Text(
                "Unable to connect to the internet.",
                style: TextStyle(color: Colors.red),
              ),
            );
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
