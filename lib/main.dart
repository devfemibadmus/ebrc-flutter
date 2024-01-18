import 'package:ebrc/authentications/welcome_screen.dart';
import 'package:ebrc/constants/adsmanager.dart';
import 'package:ebrc/constants/variables.dart';
import 'package:ebrc/home.dart';
import 'package:ebrc/pages/cashout.dart';
import 'package:ebrc/pages/notification.dart';
import 'package:ebrc/pages/referral.dart';
import 'package:ebrc/pages/settings.dart';
import 'package:ebrc/pages/website.dart';
import 'package:ebrc/tasks/ads.dart';
import 'package:flutter/material.dart';

void main() {
  final AdManager adManager = AdManager();
  runApp(
    MaterialApp(
      routes: {
        '/home': (context) => HomePage(),
        '/': (context) => const SplashScreen(),
        '/task': (context) => AdScreen(
              adManager: adManager,
            ),
        '/cash': (context) => const CashPage(),
        '/index': (context) => const IndexPage(),
        '/welcome': (context) => const WelcomePage(),
        '/website': (context) => const WebsitePage(),
        '/referral': (context) => const ReferralPage(),
        '/settings': (context) => const SettingsPage(),
        '/notification': (context) => const NotificationPage(),
      },
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: bgColor,
        ),
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            textStyle: const TextStyle(fontSize: 18),
            backgroundColor: bgColor,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        /*
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontFamily: 'Dongle', fontSize: 20),
            labelMedium: TextStyle(fontFamily: 'Dongle', fontSize: 20),
            headlineLarge: TextStyle(fontFamily: 'Roboto_Mono', fontSize: 28),
            titleLarge: TextStyle(fontFamily: 'Oswald', fontSize: 25),
            titleMedium: TextStyle(fontFamily: 'Oswald', fontSize: 18),
          ),
          */
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kPrimaryLightColor,
          iconColor: bgColor,
          prefixIconColor: bgColor,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final AdManager adManager = AdManager();
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
    // Preload ads when the app starts
    adManager.preloadInterstitialAd();
    adManager.preloadRewardedAd();
    adManager.preloadBannerAd();
    return Scaffold(
      body: Container(
        color: bgColor,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Text('EBRC',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
              SizedBox(height: 10),
              Text('Earn By Rewards NG',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 20),
              CircularProgressIndicator(
                  color: Color.fromARGB(255, 201, 239, 199)),
            ],
          ),
        ),
      ),
    );
  }
}
