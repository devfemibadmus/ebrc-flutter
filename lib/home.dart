import 'package:ebrsng/constants/variables.dart';
import 'package:ebrsng/pages/notification.dart';
import 'package:flutter/material.dart';
import 'package:ebrsng/constants/database.dart';
import 'package:ebrsng/authentications/welcome_screen.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Account>(
      future: getAccountFromSharedPrefs(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const WelcomePage();
        } else if (snapshot.hasData) {
          return HomePage();
        }
        return const Center(
            child: CircularProgressIndicator(color: kPrimaryLightColor));
      },
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Semantics(
      label: "Home Page",
      child: FutureBuilder<Account>(
        future: getAccountFromSharedPrefs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const WelcomePage();
          } else if (snapshot.hasData) {
            Account? user = snapshot.data;
            return AdvancedDrawer(
              backdropColor: bgColor,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              controller: _advancedDrawerController,
              animateChildDecoration: true,
              rtlOpening: false,
              disabledGestures: false,
              childDecoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: bgColor,
                    blurRadius: 20.0,
                    spreadRadius: 5.0,
                    offset: const Offset(-20.0, 0.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(30),
              ),
              drawer: SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: ListTileTheme(
                    textColor: Colors.white70,
                    iconColor: Colors.white70,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '@${user!.username}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              Icon(Icons.verified,
                                  color: user.activated
                                      ? Colors.green
                                      : Colors.red),
                            ],
                          ),
                        ),
                        const Divider(
                          color: kPrimaryColor,
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
                          onTap: () async {
                            await refreshAccount().then((value) {
                              Navigator.pushReplacementNamed(context, '/');
                            });
                          },
                          leading: const Icon(Icons.refresh),
                          title: const Text('Refresh'),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/activate');
                          },
                          leading: const Icon(Icons.verified),
                          title: const Text('Activate'),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/cash');
                          },
                          leading: const Text(
                            '₦',
                            style: TextStyle(fontSize: 35),
                          ),
                          title: const Text('Cash Out'),
                        ),
                        const Divider(color: kPrimaryColor),
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
                        const Divider(color: kPrimaryColor),
                        const Spacer(),
                        const ListTile(
                          leading: Text(
                            'v 2.0.0',
                            style: TextStyle(color: kPrimaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.grey.shade100,
                appBar: AppBar(
                  backgroundColor: bgColor,
                  title: const Text('Earn By Rewards NG'),
                  leading: IconButton(
                    onPressed: _handleMenuButtonPressed,
                    icon: ValueListenableBuilder<AdvancedDrawerValue>(
                      valueListenable: _advancedDrawerController,
                      builder: (_, value, __) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            value.visible ? Icons.clear : Icons.menu,
                            key: ValueKey<bool>(value.visible),
                          ),
                        );
                      },
                    ),
                  ),
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
                                const Text(
                                  '₦',
                                  style: TextStyle(
                                      color: kPrimaryColor, fontSize: 22),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  formatNumber(user.earn_balance),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
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
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
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
                                "₦100 minimum withdraw(24hrs)",
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
                                    '₦',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 25),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    formatNumber(user.account_balance),
                                    style: const TextStyle(
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                                    formatNumber(user.coin_balance),
                                    style: const TextStyle(
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
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
              ),
            );
          }
          return const Center(
              child: CircularProgressIndicator(color: kPrimaryLightColor));
        },
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
