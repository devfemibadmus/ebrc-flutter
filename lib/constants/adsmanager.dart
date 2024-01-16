import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdmob {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3805485538389573/8680759580';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3805485538389573/9008611388';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3805485538389573/5644081441';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}

class AdManager {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;

  static final AdManager _instance = AdManager._internal();

  factory AdManager() {
    return _instance;
  }

  AdManager._internal();

  void preloadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: GoogleAdmob.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void preloadRewardedAd() {
    RewardedAd.load(
      adUnitId: GoogleAdmob.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void preloadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: GoogleAdmob.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('BannerAd loaded');
        },
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    );
    _bannerAd!.load();
  }

  void showInterstitialAd() {
    InterstitialAd? interstitialAd = _interstitialAd;

    if (interstitialAd != null) {
      interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          preloadInterstitialAd(); // Preload a new interstitial ad
        },
      );
      interstitialAd.show();
    }
  }

  void showRewardedAd() {
    RewardedAd? rewardedAd = _rewardedAd;

    if (rewardedAd != null) {
      rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          preloadRewardedAd(); // Preload a new rewarded ad
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          print('Failed to show rewarded ad: $error');
        },
      );
      rewardedAd.show(
        onUserEarnedReward: (Ad ad, RewardItem reward) {
          if (ad is RewardedAd) {
            print('User earned reward: $reward');
          }
        },
      );
    }
  }

  InterstitialAd? getInterstitialAd() {
    return _interstitialAd;
  }

  RewardedAd? getRewardedAd() {
    return _rewardedAd;
  }

  BannerAd? getBannerAd() {
    return _bannerAd;
  }
}
