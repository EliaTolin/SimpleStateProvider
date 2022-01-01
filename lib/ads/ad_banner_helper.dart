import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_state_provider/ads/ad_constant.dart';

class AdBannerHelper extends ChangeNotifier {
  bool isBottomBannerAdLoaded = false;

  late BannerAd _banner;

  void createBannerAd() {
    _banner = BannerAd(
      adUnitId: AdConstant.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBottomBannerAdLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _banner.load();
  }

  void adDispose() {
    _banner.dispose();
  }

  AdSize getSizeBanner() {
    return _banner.size;
  }

  BannerAd getBanner() {
    return _banner;
  }
}
