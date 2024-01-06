import 'package:flutter/material.dart';
import 'package:ebrsng/constants/variables.dart';
import 'package:ebrsng/constants/database.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Notification Page",
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notification History'),
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
                              user.notifications[index].type == 'pending'
                                  ? user.notifications[index].amount.toString()
                                  : user.notifications[index].type != "withdraw"
                                      ? '+${user.notifications[index].amount}'
                                      : '-${user.notifications[index].amount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color:
                                    user.notifications[index].type == 'pending'
                                        ? Colors.black
                                        : user.notifications[index].type !=
                                                "withdraw"
                                            ? Colors.green
                                            : Colors.red,
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: user.notifications[index].comment
                                        .contains('SPAM')
                                    ? Colors.red
                                    : null,
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
