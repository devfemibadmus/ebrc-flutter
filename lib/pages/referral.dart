import 'package:ebrsng/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:ebrsng/constants/database.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  ReferralPageState createState() => ReferralPageState();
}

class ReferralPageState extends State<ReferralPage> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Referral page, it display a list of people you've referral",
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Referrals History'),
        ),
        body: FutureBuilder<Account?>(
          future: getAccountFromSharedPrefs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Account? user = snapshot.data;
              int length = user!.notifications.length;
              return ListView.builder(
                itemCount: length,
                itemBuilder: (context, index) {
                  if (user.notifications[index].referral == 'nobody' ||
                      user.notifications[index].referral == '') {
                    //
                  } else {
                    return Card(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                user.notifications[index].referral,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                user.notifications[index].comment,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.notifications[index].date,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              );
            }
            return const Center(
                child: CircularProgressIndicator(color: kPrimaryLightColor));
          },
        ),
      ),
    );
  }
}
