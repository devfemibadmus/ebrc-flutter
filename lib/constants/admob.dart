import 'package:ebrsng/constants/variables.dart';
import 'package:ebrsng/constants/database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobModel with ChangeNotifier {
  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;

  void showRewardedAd() {
    if (rewardedAd == null) {
      loadRewardedAd();
    } else {
      rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          rewardUser(int.parse(reward.amount.toString()));
        },
      );
    }
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      loadInterstitialAd();
    } else {
      interstitialAd!.show();
    }
  }

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: GoogleAdmob.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              rewardedAd = null;
              showInterstitialAd();
            },
          );
          rewardedAd = ad;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: GoogleAdmob.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              interstitialAd = null;
            },
          );
          interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void dispose() {
    // COMPLETE: Dispose an InterstitialAd object
    interstitialAd!.dispose();

    // COMPLETE: Dispose a RewardedAd object
    rewardedAd!.dispose();

    super.dispose();
  }
}
