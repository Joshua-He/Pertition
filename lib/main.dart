import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pertition/HomePage/HomePage.dart';
import 'package:pertition/MapPage/MapPage.dart';
import 'package:pertition/SignUp/SignUpForm.dart';
import 'package:pertition/SplashPage/SplashPage.dart';
import 'package:pertition/constants.dart';

int global1 = 1;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //MobileAds.instance.initialize();
  runApp(MyApp());
}

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'Pertition',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
      ),
      home: SplashPage(),
      routes: {
        '/splash': (context) => SplashPage(),
        '/home': (context) => HomePage(),
        '/map': (context) => MapPage(),
        '/signupform': (context) => SignUpForm(),
      },
    );
  }
}
