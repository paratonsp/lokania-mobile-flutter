// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:lokania/src/helpers/navigation.dart';
import 'package:lokania/src/screens/registration/RegisterUI.dart';
import 'package:lokania/src/utils/themes.dart';
import 'package:lokania/src/screens/localization/LocalizationUI.dart';
import 'package:lokania/src/utils/sizes.dart';

class SplashscreenUI extends StatefulWidget {
  @override
  _SplashscreenUIState createState() => _SplashscreenUIState();
}

class _SplashscreenUIState extends State<SplashscreenUI> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2500), () {
      openRemovePage(context, RegisterUI());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(gradient: customGradient()),
        child: Center(
          child: Image.asset(
            "assets/images/icons/hotel.png",
            height: Sizes.s80,
          ),
        ),
      ),
    );
  }
}
