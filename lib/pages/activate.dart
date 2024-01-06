import 'package:ebrsng/constants/database.dart';
import 'package:flutter/material.dart';
import 'package:ebrsng/constants/variables.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivatePage extends StatefulWidget {
  const ActivatePage({super.key});

  @override
  ActivatePageState createState() => ActivatePageState();
}

class ActivatePageState extends State<ActivatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "account activation page",
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Activation"),
        ),
        body: FutureBuilder<Account>(
          future: getAccountFromSharedPrefs(),
          builder: (context, snapshot) {
            Account? user = snapshot.data;
            if (snapshot.hasData) {
              if (user!.activated) {
                return const Center(
                  child: Text("Your Account Already Activated."),
                );
              } else {
                //
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: const Text(
                        'Contact any of below two customer care to activate your account',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        const url = 'whatsapp://send?phone=234 9167638142';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Whatsapp',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        const url = 'tg://resolve?domain=ebrsngcustomerservice';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0088cc),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Telegram',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryLightColor),
            );
          },
        ),
      ),
    );
  }
}
