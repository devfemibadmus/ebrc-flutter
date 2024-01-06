import 'package:ebrsng/constants/variables.dart';
import 'package:ebrsng/constants/database.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
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
      label: "Play game tic-tac-toe webview and earn if you win",
      child: FutureBuilder<Account>(
        future: getAccountFromSharedPrefs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //Account? user = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: const Text("Tic Tac Toe"),
              ),
              body: error == true
                  ? body
                  : WebViewPlus(
                      onWebResourceError: (error) {
                        //print("An error occurred: ${error.description}");
                        webError();
                      },
                      initialUrl: tictactoeUrl.toString(),
                      javascriptMode: JavascriptMode.unrestricted,
                    ),
            );
          }
          return const Center(
              child: CircularProgressIndicator(color: kPrimaryLightColor));
        },
      ),
    );
  }

  void webError() {
    setState(() {
      error = true;
    });
  }
}
