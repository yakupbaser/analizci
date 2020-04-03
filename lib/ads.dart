import 'package:firebase_admob/firebase_admob.dart';

class Ads {
  static const String appId =
      'xxxxxxxxxxx'; //
  static const String bannerId =
      ''; //
  static const String interStitialId = 'xxxxxxxxx';
  static const String rewardedId = '';

  static BannerAd _bannerAd;

  static void initializeDirebaseAdmob() {
    FirebaseAdMob.instance.initialize(appId: appId);
  }

  static void disposeBanner() {
    print('Dispose Banner');
    _bannerAd?.dispose();
  }

  static MobileAdTargetingInfo _makemobilAdTargetingInfo() {
    return MobileAdTargetingInfo(
      keywords: ['tutorials', 'udemy'],
      childDirected: false,
      testDevices: [],
      nonPersonalizedAds: false, //gdpr related
    );
  }

  ///
  /// Banner
  ///
  static void _initBanner() {
    _bannerAd = BannerAd(
        adUnitId: BannerAd.testAdUnitId, //BannerAd.testAdUnitId, //bannerId,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          print('BannerAd event = ' + event.toString());
        },
        targetingInfo: _makemobilAdTargetingInfo());
  }

  static showBanner(bool Function() _isMounted) async {
    _initBanner();

    await Future.delayed(Duration(seconds: 1, microseconds: 500));
    _bannerAd.load().then((loaded) {
      if (loaded & _isMounted()) {
        _bannerAd.show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
      } else {
        disposeBanner();
      }
    });
  }

  ///
  /// InterstitialAd
  ///
  static InterstitialAd interstitialAd;

  static void initInterStitialAd() {
    interstitialAd = InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: _makemobilAdTargetingInfo(),
        listener: (MobileAdEvent event) {
          print('InterstitialAd event = ' + event.toString());
        });
    interstitialAd.load();
  }

  static Future showInterstitialAd() async {
    if (await interstitialAd.isLoaded()) {
      await interstitialAd?.show();
    }
  }

  ///
  /// RewardedAd
  ///
  static bool isRewardedAdLoaded = false;

  static void loadRewardedAd(
      void Function(RewardedVideoAdEvent event,
              {String rewardType, int rewardAmount})
          listener) {
    RewardedVideoAd.instance.listener = listener;
    RewardedVideoAd.instance.load(
      adUnitId: RewardedVideoAd.testAdUnitId,
      targetingInfo: _makemobilAdTargetingInfo(),
    );
  }

  static bool showRewardedAd() {
    if (isRewardedAdLoaded) {
      RewardedVideoAd.instance.show();
      isRewardedAdLoaded = false;
      return true;
    } else {
      return false;
    }
  }
}
