import 'dart:async';

import 'package:ebrc/constants/adsmanager.dart';
import 'package:ebrc/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdScreen extends StatefulWidget {
  final AdManager adManager;

  const AdScreen({Key? key, required this.adManager}) : super(key: key);

  @override
  _AdScreenState createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  late Timer _adReloadTimer;

  @override
  void initState() {
    super.initState();

    // Start the timer to reload ads every 30 seconds (adjust the duration as needed)
    _adReloadTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      widget.adManager.preloadInterstitialAd();
      widget.adManager.preloadRewardedAd();
      widget.adManager.preloadBannerAd();
    });
  }

  @override
  void dispose() {
    // Dispose of the timer when the widget is disposed
    _adReloadTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Screen'),
      ),
      body: Center(
        child: widget.adManager.getBannerAd() != null
            ? Container(
                alignment: Alignment.bottomCenter,
                width: widget.adManager.getBannerAd()!.size.width.toDouble(),
                height: widget.adManager.getBannerAd()!.size.height.toDouble(),
                child: AdWidget(ad: widget.adManager.getBannerAd()!),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          widget.adManager.showRewardedAd();
        },
        // isExtended: true,
        child: Icon(
          Icons.add,
          color: bgColor,
        ),
      ),
    );
  }
}
