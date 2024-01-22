import 'package:ebrc/constants/variables.dart';
import 'package:ebrc/pages/notification.dart';
import 'package:flutter/material.dart';
import 'package:ebrc/constants/database.dart';
import 'package:ebrc/authentications/welcome_screen.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Account>(
      future: getAccountFromSharedPrefs(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const WelcomePage();
        } else if (snapshot.hasData) {
          return const HomePage();
        }
        return const Center(
            child: CircularProgressIndicator(color: kPrimaryLightColor));
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Account> accountFuture;

  @override
  void initState() {
    super.initState();
    accountFuture = getAccountFromSharedPrefs();
  }

  Future<void> refreshData() async {
    setState(() {
      accountFuture = getAccountFromSharedPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Semantics(
      label: "Home Page",
      child: FutureBuilder<Account>(
        future: accountFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot);
            print("snapshot");
            return const WelcomePage();
          } else if (snapshot.hasData) {
            Account? user = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                backgroundColor: bgColor,
                title: const Text('Earn By Rewards Coin',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // ₦ Balance
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: h <= 500 ? h / 2 : h / 3.5,
                      margin: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₦',
                                style: TextStyle(color: bgColor, fontSize: 22),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                formatNumber(user!.earnBalance ?? 0),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: bgColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            height: 30,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationPage()));
                            },
                            color: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'History',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    // Total Balance
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: h <= 500 ? h / 2 : h / 3.5,
                      margin: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "coins 10,000 make ₦5,000",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'coin',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 25),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  formatNumber(user.coinBalance ?? 0),
                                  style: const TextStyle(
                                    fontSize: 37,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              drawer: Drawer(
                child: Column(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: bgColor,
                      ),
                      child: UserAccountsDrawerHeader(
                        margin: EdgeInsets.zero,
                        accountName: Text(
                          '@${user.username}',
                          style: const TextStyle(
                              fontSize: 18, color: kPrimaryColor),
                        ),
                        accountEmail: Text(
                          '${user.email}',
                          style: const TextStyle(
                              fontSize: 14, color: kPrimaryColor),
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('Referrals'),
                      onTap: () {
                        Navigator.pushNamed(context, '/referral');
                      },
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/notification');
                      },
                      leading: const Icon(Icons.notifications),
                      title: const Text('Notifications'),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/task');
                      },
                      leading: const Icon(Icons.task),
                      title: const Text('Tasks'),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/cash');
                      },
                      leading: const Text(
                        '₦',
                        style: TextStyle(fontSize: 20),
                      ),
                      title: const Text('Cash Out'),
                    ),
                    Divider(color: bgColor),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                    ),
                    ListTile(
                      onTap: () {
                        logOut();
                        Navigator.pushReplacementNamed(context, '/welcome');
                      },
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/website');
                      },
                      leading: const Icon(Icons.support),
                      title: const Text('Website'),
                    ),
                    Divider(color: bgColor),
                    const Spacer(),
                    ListTile(
                      leading: Text(
                        'v 1.0.4',
                        style: TextStyle(color: bgColor),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
              child: CircularProgressIndicator(color: kPrimaryLightColor));
        },
      ),
    );
  }
}
