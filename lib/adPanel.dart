import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:analizci/ads.dart';


class AdPanel extends StatefulWidget {
  @override
  _AdPanelState createState() => _AdPanelState();
}

class _AdPanelState extends State<AdPanel> {

bool Function() isMounted(){
  return(){
    return true;
  };
}  

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Ads.showBanner(isMounted());
    Ads.showInterstitialAd();
  }

@override
  void dispose() {
    // TODO: implement dispose
    Ads.disposeBanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
     height: AdSize.banner.height.toDouble(), 
    );
  }
}