import 'package:ebrsng/constants/admob.dart';
import 'package:ebrsng/constants/variables.dart';
import 'package:ebrsng/constants/database.dart';
import 'package:ebrsng/tasks/ads.dart';
import 'package:ebrsng/tasks/tictactoe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Tasks page, here are list of task to do",
      child: FutureBuilder<Account>(
        future: getAccountFromSharedPrefs(),
        builder: ((context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            context.read<AdmobModel>().loadRewardedAd();
            context.read<AdmobModel>().loadInterstitialAd();
            Account? user = snapshot.data;
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 201, 239, 199),
              appBar: AppBar(
                title: const Text("Task Page"),
              ),
              body: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTile(
                    initiallyExpanded: true,
                    title: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            tasks[index].title,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            "Price: ${tasks[index].price}",
                            style: const TextStyle(color: Colors.green),
                          ),
                        )
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(tasks[index].comment),
                      ),
                      TextButton(
                        style: user!.reward_ads && tasks[index].level == 0 ||
                                user.coin_balance >= 50 &&
                                    tasks[index].level == 1 ||
                                user.user_referral && tasks[index].level == 2 ||
                                user.super_referral &&
                                    tasks[index].level == 3 ||
                                user.might_referral &&
                                    tasks[index].level == 4 ||
                                user.premium_referral &&
                                    tasks[index].level == 5 ||
                                user.tic_tac_toe_2 && tasks[index].level == 6 ||
                                user.tic_tac_toe_3 && tasks[index].level == 7
                            ? null
                            : ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                                minimumSize:
                                    MaterialStateProperty.all(const Size(0, 0)),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(4)),
                              ),
                        onPressed: () {
                          if (user.reward_ads && tasks[index].level == 0) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Ads()));
                          } else if (user.coin_balance >= 50 &&
                              tasks[index].level == 1) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const TicTacToePage()));
                          } else if (user.user_referral &&
                              tasks[index].level == 2) {
                            showAlert(
                                context,
                                "User Referral",
                                "Code has been copied to clipboard.",
                                true,
                                user.username);
                          } else if (user.super_referral &&
                              tasks[index].level == 3) {
                            showAlert(
                                context,
                                "Super Referral",
                                "Code has been copied to clipboard.",
                                true,
                                "${user.username}superreferral");
                          } else if (user.might_referral &&
                              tasks[index].level == 4) {
                            showAlert(
                                context,
                                "Might Referral",
                                "Code has been copied to clipboard.",
                                true,
                                "${user.username}mightreferral");
                          } else if (user.premium_referral &&
                              tasks[index].level == 5) {
                            showAlert(
                                context,
                                "Premium Referral",
                                "Code has been copied to clipboard.",
                                true,
                                "${user.username}premiumreferral");
                          } else if (user.tic_tac_toe_2 &&
                              tasks[index].level == 6) {
                            showAlert(
                                context,
                                "Tic Tac Toe",
                                "This game is currently not available try updating your app.",
                                false,
                                user.username);
                          } else if (user.tic_tac_toe_3 &&
                              tasks[index].level == 7) {
                            showAlert(
                              context,
                              "Tic Tac Toe",
                              "This game is currently not available try updating your app.",
                              false,
                              user.username,
                            );
                          } else {
                            null;
                          }
                        },
                        child: Text(
                          tasks[index].button,
                          style: user.reward_ads && tasks[index].level == 0 ||
                                  user.coin_balance >= 50 &&
                                      tasks[index].level == 1 ||
                                  user.user_referral &&
                                      tasks[index].level == 2 ||
                                  user.super_referral &&
                                      tasks[index].level == 3 ||
                                  user.might_referral &&
                                      tasks[index].level == 4 ||
                                  user.premium_referral &&
                                      tasks[index].level == 5 ||
                                  user.tic_tac_toe_2 &&
                                      tasks[index].level == 6 ||
                                  user.tic_tac_toe_3 && tasks[index].level == 7
                              ? null
                              : const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryLightColor),
            );
          }
        }),
      ),
    );
  }
}

class Tasks {
  int level;
  String title;
  String price;
  String button;
  String comment;

  Tasks({
    required this.level,
    required this.title,
    required this.price,
    required this.button,
    required this.comment,
  });
}

List<Tasks> tasks = [
  Tasks(
    level: 0,
    title: 'Reward Ads',
    price: 'coin',
    button: 'Watch ads',
    comment:
        'Watch a video ads, get reward and get credited coin(S). Hence make sure ads stays at least 20secs before closing. You can do this task daily as many time as possible.',
  ),
  Tasks(
    level: 1,
    title: 'Tik-Tac-Toe',
    price: '₦50',
    button: 'Play game',
    comment:
        'play tik-tac-toe game with the computer for 50 coins if you win you will be credited ₦50. You can do this task as many time as possible.',
  ),
  Tasks(
    level: 2,
    title: 'User Referral',
    price: '₦200',
    button: 'Share referral code',
    comment:
        'for every user you referral using this referral code you will be credited ₦200. You can do this task daily as many time as possible.',
  ),
  Tasks(
    level: 3,
    title: 'Super Referral',
    price: '₦400',
    button: 'Share referral code',
    comment:
        'for every user you referral using this referral code you will be credited ₦400, Hence before this can be activated you must have referred up-to 20 users. You can do this task as many time as possible.',
  ),
  Tasks(
    level: 4,
    title: 'Might Referral',
    price: '₦600',
    button: 'Share referral code',
    comment:
        'for every user you referral using this referral code you will be credited ₦600, Hence before this can be activated you must have referred up-to 40 users. You can do this task as many time as possible.',
  ),
  Tasks(
    level: 5,
    title: 'Premium Referral',
    price: '₦1,000',
    button: 'Share referral code',
    comment:
        'for every user you referral using this referral code you will be credited ₦700 and the referred will be credited ₦200, Hence before this can be activated you must have referred up-to 55 users. You can do this task as many time as possible.',
  ),
  Tasks(
    level: 6,
    title: 'Tik-Tac-Toe',
    price: '₦1,000',
    button: 'Play game',
    comment:
        'play tik-tac-toe game with a user here, the winner will be credited ₦1,000, Hence before this can be activated you must have referred up-to 100 users. You can do this task as many time as possible.',
  ),
  Tasks(
    level: 7,
    title: 'Tik-Tac-Toe',
    price: '₦100',
    button: 'Play game',
    comment:
        'play tik-tac-toe game with a user here, the winner will be credited ₦100. You can do this task as many time as possible.',
  ),
];
