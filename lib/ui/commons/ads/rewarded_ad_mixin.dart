import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../utils/ad/consent_manager.dart';
import '../../../utils/app_snack_bar.dart';

mixin RewardedAdMixin<T extends StatefulWidget> on State<T> {
  RewardedAd? _rewardedAd;

  final _adUnitId = Platform.isAndroid
      ? const String.fromEnvironment('ANDROID_REWARDED_AD_UNIT_ID')
      : const String.fromEnvironment('IOS_REWARDED_AD_UNIT_ID');

  @override
  void initState() {
    super.initState();
    ConsentManager.gatherConsent((consentError) {
      if (consentError != null) {
        debugPrint(
            "Consent error: ${consentError.errorCode}: ${consentError.message}");
        _rewardedAd?.dispose();
        _loadRewardedAd();
      }
    });
    _loadRewardedAd();
  }

  void _loadRewardedAd() async {
    if (!await ConsentManager.canRequestAds() || !mounted) {
      return;
    }
    debugPrint('Loading RewardedAd');
    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {},
            onAdImpression: (ad) {},
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _loadRewardedAd();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadRewardedAd();
            },
            onAdClicked: (ad) {},
          );
          debugPrint('RewardedAd loaded.');
          _rewardedAd?.dispose();
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void showRewardedAd(Function(AdWithoutView, RewardItem) onUserEarnedReward) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
      _rewardedAd = null;
    } else {
      debugPrint('InterstitialAd is not ready yet.');
      AppSnackBar.showError(context, 'Ad is not ready yet!');
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }
}
