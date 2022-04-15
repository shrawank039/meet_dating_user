import 'dart:io' show Platform;
import 'package:google_mobile_ads/google_mobile_ads.dart';


InterstitialAd? _interstitialAd;
int _numInterstitialLoadAttempts = 0;
const String testDevice = 'YOUR_DEVICE_ID';
const bool test = true;
RewardedAd? _rewardedAd;
int _numRewardedLoadAttempts = 0;
const int maxFailedLoadAttempts = 3;

class Ads {

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  void createInterstitialAd() {
    if (!test) {
      InterstitialAd.load(
          adUnitId: Platform.isAndroid
              ? 'ca-app-pub-5334606472230524/8912260113'
              : 'ca-app-pub-5334606472230524/8912260113',
          request: request,
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              print('$ad loaded');
              _interstitialAd = ad;
              _numInterstitialLoadAttempts = 0;
              _interstitialAd!.setImmersiveMode(true);
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('InterstitialAd failed to load: $error.');
              _numInterstitialLoadAttempts += 1;
              _interstitialAd = null;
              if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
                createInterstitialAd();
              }
            },
          ));
    }
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void createRewardedAd() {
    if (!test) {
      RewardedAd.load(
          adUnitId: Platform.isAndroid
              ? 'ca-app-pub-3940256099942544/5224354917'
              : 'ca-app-pub-3940256099942544/1712485313',
          request: request,
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              print('$ad loaded.');
              _rewardedAd = ad;
              _numRewardedLoadAttempts = 0;
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('RewardedAd failed to load: $error');
              _rewardedAd = null;
              _numRewardedLoadAttempts += 1;
              if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
                createRewardedAd();
              }
            },
          ));
    }
  }

  void showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    _rewardedAd = null;
  }


  void disable(ad) {
    try {
      ad?.dispose();
    } catch (e) {
      print("no ad found");
    }
  }

}

// import 'dart:io';
// import 'package:firebase_admob/firebase_admob.dart';
//
// // You can also test with your own ad unit IDs by registering your device as a
// // test device. Check the logs for your device's ID value.
// const String testDevice = 'YOUR_DEVICE_ID';
//
// //Admob App id's with '~' sign
// String androidAdAppId = FirebaseAdMob.testAppId;
// String iosAdAppId = FirebaseAdMob.testAppId;
// //Banner unit id's with '/' sign
// String androidBannerAdUnitId = BannerAd.testAdUnitId;
// String iosBannerAdUnitId = BannerAd.testAdUnitId;
// //Interstitial unit id's with '/' sign
// String androidInterstitialAdUnitId = InterstitialAd.testAdUnitId;
// String iosInterstitialAdUnitId = InterstitialAd.testAdUnitId;
//
// class Ads {
//
//   MobileAdTargetingInfo targetingInfo() => MobileAdTargetingInfo(
//         contentUrl: 'https://flutter.io',
//         childDirected: false,
//         testDevices: testDevice != null
//             ? <String>[testDevice]
//             : null, // Android emulators are considered test devices
//       );
//
//   BannerAd myBanner() => BannerAd(
//         adUnitId: Platform.isIOS ? iosBannerAdUnitId : androidBannerAdUnitId,
//         size: AdSize.smartBanner,
//         targetingInfo: targetingInfo(),
//         listener: (MobileAdEvent event) {
//           print("BannerAd event is $event");
//         },
//       );
//   InterstitialAd myInterstitial() => InterstitialAd(
//         adUnitId: Platform.isAndroid
//             ? androidInterstitialAdUnitId
//             : iosInterstitialAdUnitId,
//         targetingInfo: targetingInfo(),
//         listener: (MobileAdEvent event) {
//           // adEvent = event;
//           print("------------------------------InterstitialAd event is $event");
//         },
//       );
//
//   void disable(ad) {
//     try {
//       ad?.dispose();
//     } catch (e) {
//       print("no ad found");
//     }
//   }
// }
