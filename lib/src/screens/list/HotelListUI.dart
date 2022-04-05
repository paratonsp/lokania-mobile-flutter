// ignore_for_file: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lokania/src/helpers/localization.dart';
import 'package:lokania/src/helpers/navigation.dart';
import 'package:lokania/src/models/HotelModel.dart';
import 'package:lokania/src/screens/detail/DetailUI.dart';
import 'package:lokania/src/screens/filter/FilterUI.dart';
import 'package:lokania/src/screens/maps/MapsUI.dart';
import 'package:lokania/src/screens/search_option/SearchOptionUI.dart';
import 'package:lokania/src/screens/sort/SortUI.dart';
import 'package:lokania/src/services/local_service.dart';
import 'package:lokania/src/utils/colors.dart';
import 'package:lokania/src/utils/sizes.dart';
import 'package:lokania/src/widgets/cards.dart';

class HotelListUI extends StatefulWidget {
  final String location;
  HotelListUI({this.location});
  @override
  _HotelListUIState createState() => _HotelListUIState();
}

class _HotelListUIState extends State<HotelListUI> {
  bool _loaded = false;
  List<Hotel> _hotels = [];
  String userLocation;

  @override
  void initState() {
    super.initState();
    setState(() {
      userLocation = widget.location;
    });
    LocalService.loadHotels(false).then((value) {
      setState(() {
        _loaded = true;
        _hotels = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0.0,
        title: InkWell(
          onTap: () async {
            final res = await openPage(
              context,
              SearchOptionUI(
                location: userLocation,
              ),
            );
            if (res != null) {
              setState(() {
                userLocation = res;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(
                Radius.circular(Sizes.s15),
              ),
            ),
            width: double.maxFinite,
            height: Sizes.s40,
            padding: EdgeInsets.all(Sizes.s10),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: FontSize.s18,
                    color: Colors.black,
                  ),
                  Container(
                    width: Sizes.s10,
                  ),
                  Flexible(
                    child: Text(
                      "${userLocation ?? lang.translate('screen.hotelList.searchHint')}",
                      style: TextStyle(
                        fontSize: FontSize.s15,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FlutterIcons.filter_mco),
            onPressed: () => openPage(context, FilterUI()),
          ),
          IconButton(
            icon: Icon(FlutterIcons.sort_mco),
            onPressed: () => openPage(context, SortUI()),
          ),
        ],
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    final res = await openPage(
                      context,
                      SearchOptionUI(
                        location: userLocation,
                      ),
                    );

                    if (res != null) {
                      // setState(() {});
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey.withOpacity(.3),
                      ),
                    )),
                    margin: EdgeInsets.only(top: Sizes.s5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Sun, 26 Aug",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: FontSize.s12,
                                  ),
                                ),
                                Container(height: Sizes.s5),
                                Text(
                                  "12:00 PM",
                                  style: TextStyle(
                                    fontSize: FontSize.s10,
                                  ),
                                ),
                                Container(height: Sizes.s5),
                              ],
                            ),
                          ),
                          flex: 1,
                        ),
                        Container(
                          height: Sizes.s40,
                          width: 1,
                          color: Colors.grey.withOpacity(.5),
                          margin: EdgeInsets.only(bottom: Sizes.s5),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Sun, 26 Aug",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: FontSize.s12,
                                  ),
                                ),
                                Container(height: Sizes.s5),
                                Text(
                                  "12:00 PM",
                                  style: TextStyle(
                                    fontSize: FontSize.s10,
                                  ),
                                ),
                                Container(height: Sizes.s5),
                              ],
                            ),
                          ),
                          flex: 1,
                        ),
                        Container(
                          width: 1,
                          height: Sizes.s40,
                          color: Colors.grey.withOpacity(.5),
                          margin: EdgeInsets.only(bottom: Sizes.s5),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "2 ${lang.translate('screen.hotelList.room')}",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: FontSize.s12,
                                  ),
                                ),
                                Container(height: Sizes.s5),
                                Text(
                                  "4 ${lang.translate('screen.hotelList.guest')}",
                                  style: TextStyle(
                                    fontSize: FontSize.s10,
                                  ),
                                ),
                                Container(height: Sizes.s5),
                              ],
                            ),
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _loaded
                      ? ListView.builder(
                          padding: EdgeInsets.only(top: Sizes.s20),
                          itemCount: _hotels.length,
                          itemBuilder: (context, index) {
                            return HotelListCard(
                              onTap: () => openPage(
                                context,
                                DetailUI(hotel: _hotels[index]),
                              ),
                              hotel: _hotels[index],
                            );
                          },
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(top: Sizes.s20),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return HotelListLoader();
                          },
                        ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  constraints: BoxConstraints(
                    maxWidth: Sizes.s185,
                  ),
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(.85),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Sizes.s20),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: Sizes.s30),
                  height: Sizes.s30,
                  child: InkWell(
                    onTap: () => openPage(context, MapsUI()),
                    child: Center(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: FontSize.s14,
                        ),
                        SizedBox(
                          width: Sizes.s5,
                        ),
                        Text(
                          "${lang.translate('screen.hotelList.mapButton')}",
                          style: TextStyle(
                            fontSize: FontSize.s16,
                          ),
                        )
                      ],
                    )),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
