// ignore_for_file: unused_import, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lokania/src/helpers/localization.dart';
import 'package:lokania/src/helpers/navigation.dart';
import 'package:lokania/src/screens/customer_service/CustomerServiceUI.dart';
import 'package:lokania/src/screens/dashboard/account/AccountUI.dart';
import 'package:lokania/src/screens/dashboard/booking/BookingUI.dart';
import 'package:lokania/src/screens/wallet/WalletUI.dart';
import 'package:lokania/src/utils/colors.dart';
import 'package:lokania/src/utils/sizes.dart';
import 'home/HomeUI.dart';
import 'notification/NotificationUI.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class DashboardUI extends StatefulWidget {
  @override
  _DashboardUIState createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  // default active index
  int currentIndex = 0;

  // app bar title for every tab
  String appBarTitle(context) {
    var lang = AppLocalizations.of(context);
    switch (currentIndex) {
      // first tab
      case 0:
        return "${lang.translate('screen.dashboard.firstAppBar')}";
        break;
      // second tab
      case 1:
        return "${lang.translate('screen.dashboard.secondAppBar')}";
        break;
      // third tab
      case 2:
        return "${lang.translate('screen.dashboard.thirdAppBar')}";
        break;
      // fourth tab
      case 3:
        return "${lang.translate('screen.dashboard.fourhAppBar')}";
        break;
      // if unknown
      default:
        return "";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return Scaffold(
        // if active tab is not account ui
        appBar: currentIndex != 3
            ? AppBar(
                elevation: 0,
                title: Row(
                  children: <Widget>[
                    currentIndex == 0
                        ? Icon(
                            Feather.compass,
                            color: primaryColor,
                            size: FontSize.s15,
                          )
                        : Container(),
                    currentIndex == 0
                        ? Container(
                            width: Sizes.s10,
                          )
                        : Container(),
                    Text(
                      appBarTitle(context),
                      style: TextStyle(
                        fontSize: FontSize.s16,
                        color: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .color
                            .withOpacity(.7),
                      ),
                    )
                  ],
                ),
                actions: currentIndex == 0
                    ? <Widget>[
                        // IconButton(
                        //   icon: Icon(
                        //     FlutterIcons.wallet_mco,
                        //     color: Colors.grey,
                        //   ),
                        //   onPressed: () => openPage(context, WalletUI()),
                        // ),
                        // IconButton(
                        //   icon: Icon(
                        //     FlutterIcons.chat_processing_mco,
                        //     color: Colors.grey,
                        //   ),
                        //   onPressed: () => openPage(context, CustomerServiceUI()),
                        // ),
                      ]
                    : [],
              )
            : null,
        body: IndexedStack(
          index: currentIndex,
          children: <Widget>[
            HomeUI(),
            NotificationUI(),
            BookingUI(),
            AccountUI(),
          ],
        ),
        bottomNavigationBar: BottomNavyBar(
          mainAxisAlignment: MainAxisAlignment.center,
          selectedIndex: currentIndex,
          curve: Curves.easeIn,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            currentIndex = index;
          }),
          items: [
            BottomNavyBarItem(
              textAlign: TextAlign.center,
              icon: Icon(Feather.home),
              title: Text("${lang.translate('screen.dashboard.firstTab')}"),
              activeColor: primaryColor,
              inactiveColor: Colors.black54,
            ),
            BottomNavyBarItem(
              textAlign: TextAlign.center,
              icon: Icon(Feather.bell),
              title: Text("${lang.translate('screen.dashboard.secondTab')}"),
              activeColor: primaryColor,
              inactiveColor: Colors.black54,
            ),
            BottomNavyBarItem(
              textAlign: TextAlign.center,
              icon: Icon(Feather.list),
              title: Text("${lang.translate('screen.dashboard.thirdTab')}"),
              activeColor: primaryColor,
              inactiveColor: Colors.black54,
            ),
            BottomNavyBarItem(
              textAlign: TextAlign.center,
              icon: Icon(Feather.user),
              title: Text("${lang.translate('screen.dashboard.fourthTab')}"),
              activeColor: primaryColor,
              inactiveColor: Colors.black54,
            ),
          ],
        )
        // bottomNavigationBar: SalomonBottomBar(
        //   margin: EdgeInsets.all(10),
        //   itemPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        //   currentIndex: currentIndex,
        //   onTap: (index) => setState(() {
        //     currentIndex = index;
        //   }),
        //   items: [
        //     /// Home
        //     SalomonBottomBarItem(
        //       icon: Icon(Feather.home),
        //       title: Text("${lang.translate('screen.dashboard.firstTab')}"),
        //       selectedColor: primaryColor,
        //     ),

        //     /// Likes
        //     SalomonBottomBarItem(
        //       icon: Icon(Feather.bell),
        //       title: Text("${lang.translate('screen.dashboard.secondTab')}"),
        //       selectedColor: primaryColor,
        //     ),

        //     /// Search
        //     SalomonBottomBarItem(
        //       icon: Icon(Feather.list),
        //       title: Text("${lang.translate('screen.dashboard.thirdTab')}"),
        //       selectedColor: primaryColor,
        //     ),

        //     /// Profile
        //     SalomonBottomBarItem(
        //       icon: Icon(Feather.user),
        //       title: Text("${lang.translate('screen.dashboard.fourthTab')}"),
        //       selectedColor: primaryColor,
        //     ),
        //   ],
        // ),
        );
  }
}
