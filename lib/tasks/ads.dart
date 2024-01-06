import 'package:ebrsng/constants/admob.dart';
import 'package:ebrsng/constants/variables.dart';
import 'package:ebrsng/constants/database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class Ads extends StatefulWidget {
  const Ads({Key? key}) : super(key: key);

  @override
  State<Ads> createState() => AdsState();
}

class AdsState extends State<Ads> {
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();

    // COMPLETE: Load a banner ad
    BannerAd(
      adUnitId: GoogleAdmob.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdClosed: (ad) {
          ad.dispose();
          _bannerAd = null;
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Watch ads as task",
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ads Page"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_bannerAd != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: 72.0,
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (context.read<AdmobModel>().interstitialAd == null) {
                    context.read<AdmobModel>().loadInterstitialAd();
                  } else {
                    context.read<AdmobModel>().interstitialAd!.show().then(
                      (value) {
                        rewardUser(int.parse('5'));
                      },
                    );
                  }
                },
                child: const Text("Show Interstitial Ad"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (context.read<AdmobModel>().rewardedAd == null) {
                    context.read<AdmobModel>().loadRewardedAd();
                  } else {
                    context.read<AdmobModel>().rewardedAd!.show(
                      onUserEarnedReward: (ad, reward) {
                        rewardUser(int.parse(reward.amount.toString()));
                      },
                    );
                  }
                },
                child: const Text("Show Rewarded Ad"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
