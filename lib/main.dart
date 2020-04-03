import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:analizci/navigasyon.dart';


	
  Future main() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(MyApp());
  }



Widget MyApp() {
  return MaterialApp(
      // onUnknownRoute: (RouteSettings settings) => MaterialPageRoute(builder: (context) => NavigasyonIslemleri()),
    debugShowCheckedModeBanner: false,
    home:NavigasyonIslemleri(),
    theme: ThemeData.dark(),
    );
 
}
