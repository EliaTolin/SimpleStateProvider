import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;
  InterstitialAd? _interstitialAd;
  int num_of_attempt_load = 0;

  AdState(this.initialization);

  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  String get interstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  final BannerAdListener _addBannerListener = BannerAdListener(
    onAdLoaded: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) =>
        print('Ad failed to load: ${ad.adUnitId}, $error.'),
    onAdImpression: (ad) => print('Ad impression: ${ad.adUnitId}.'),
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
  );
  BannerAdListener get adListener => _addBannerListener;

  Future<void> createInterstialAd() async {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        _interstitialAd = ad;
        num_of_attempt_load = 0;
      }, onAdFailedToLoad: (LoadAdError error) {
        num_of_attempt_load++;
        _interstitialAd = null;
        if (num_of_attempt_load <= 2) {
          createInterstialAd();
        }
      }),
    );
  }

  void showInterad() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
      print("ad onAdShowedFullScreen");
    }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print("ad Disposed");
      ad.dispose();
    }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print("$ad OnAdFailed $error");
      ad.dispose();
      createInterstialAd();
    });

    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
