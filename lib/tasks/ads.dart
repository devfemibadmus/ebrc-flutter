import 'package:ebrsng/constants/adsmanager.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdScreen extends StatefulWidget {
  final AdManager adManager;

  const AdScreen({super.key, required this.adManager});

  @override
  _AdScreenState createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Show preloaded interstitial ad
                widget.adManager.showInterstitialAd();
              },
              child: const Text('Show Interstitial Ad'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Show preloaded rewarded ad
                widget.adManager.showRewardedAd();
              },
              child: const Text('Show Rewarded Ad'),
            ),
            const SizedBox(height: 16),
            if (widget.adManager.getBannerAd() != null)
              Container(
                alignment: Alignment.bottomCenter,
                width: widget.adManager.getBannerAd()!.size.width.toDouble(),
                height: widget.adManager.getBannerAd()!.size.height.toDouble(),
                child: AdWidget(ad: widget.adManager.getBannerAd()!),
              ),
          ],
        ),
      ),
    );
  }
}
