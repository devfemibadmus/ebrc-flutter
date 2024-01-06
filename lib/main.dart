import 'package:ebrsng/authentications/welcome_screen.dart';
import 'package:ebrsng/constants/admob.dart';
import 'package:ebrsng/constants/variables.dart';
import 'package:ebrsng/home.dart';
import 'package:ebrsng/pages/activate.dart';
import 'package:ebrsng/pages/cashout.dart';
import 'package:ebrsng/pages/notification.dart';
import 'package:ebrsng/pages/referral.dart';
import 'package:ebrsng/pages/settings.dart';
import 'package:ebrsng/pages/tasks.dart';
import 'package:ebrsng/pages/website.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AdmobModel(),
      child: MaterialApp(
        routes: {
          '/home': (context) => HomePage(),
          '/': (context) => const SplashScreen(),
          '/task': (context) => const TaskPage(),
          '/cash': (context) => const CashPage(),
          '/index': (context) => const IndexPage(),
          '/welcome': (context) => const WelcomePage(),
          '/website': (context) => const WebsitePage(),
          '/referral': (context) => const ReferralPage(),
          '/activate': (context) => const ActivatePage(),
          '/settings': (context) => const SettingsPage(),
          '/notification': (context) => const NotificationPage(),
        },
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.grey.shade900,
          ),
          fontFamily: 'Dongle',
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              textStyle: const TextStyle(
                  fontFamily: 'IBMPlexSansCondensed', fontSize: 18),
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontFamily: 'Dongle', fontSize: 20),
            labelMedium: TextStyle(fontFamily: 'Dongle', fontSize: 20),
            headlineLarge: TextStyle(fontFamily: 'Roboto_Mono', fontSize: 28),
            titleLarge: TextStyle(fontFamily: 'Oswald', fontSize: 25),
            titleMedium: TextStyle(fontFamily: 'Oswald', fontSize: 18),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 90, 90, 90),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/ebrsng.png'),
              const SizedBox(height: 20),
              const Text('EBRSNG',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
              const SizedBox(height: 10),
              const Text('Earn By Rewards NG',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                  color: Color.fromARGB(255, 201, 239, 199)),
            ],
          ),
        ),
      ),
    );
  }
}
