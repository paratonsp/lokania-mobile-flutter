// ignore_for_file: unused_import, unused_field, unused_local_variable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokania/src/helpers/currency.dart';
import 'package:lokania/src/helpers/localization.dart';
import 'package:lokania/src/helpers/navigation.dart';
import 'package:lokania/src/utils/themes.dart';
import 'package:lokania/src/models/BlogModel.dart';
import 'package:lokania/src/models/HotelModel.dart';
import 'package:lokania/src/models/PlaceModel.dart';
import 'package:lokania/src/models/PromoModel.dart';
import 'package:lokania/src/screens/blog_detail/BlogDetailUI.dart';
import 'package:lokania/src/screens/detail/DetailUI.dart';
import 'package:lokania/src/screens/list/HotelListV2UI.dart';
import 'package:lokania/src/screens/list/HotelListUI.dart';
import 'package:lokania/src/screens/promo_detail/PromoDetailUI.dart';
import 'package:lokania/src/screens/promo_list/PromoListUI.dart';
import 'package:lokania/src/services/local_service.dart';
import 'package:lokania/src/utils/sizes.dart';
import 'package:lokania/src/widgets/buttons.dart';
import 'package:lokania/src/widgets/cards.dart';
import 'package:lokania/src/widgets/common_widgets.dart';
import 'package:lokania/src/widgets/inputs.dart';
import 'package:lokania/src/screens/search_location/SearchLocationUI.dart';
import 'package:lokania/src/helpers/modal.dart';
import 'package:intl/intl.dart';
import 'package:lokania/src/utils/colors.dart';

class HomeUI extends StatefulWidget {
  final String location;
  HomeUI({this.location});
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  bool _popularLoaded = false; // is popular loaded
  List<Hotel> _popularHotels = []; // popular hotels data
  bool _placesLoaded = false; // is places loaded
  List<Place> _places = []; // places data
  bool _blogsLoaded = false; // is blog loaded
  List<Blog> _blogs = []; // blogs data
  bool _dealsLoaded = false; // deals is loaded
  List<PromoModel> _deals = []; // deals data

  String userLocation;
  final dateFormat = DateFormat('dd LLL yyyy');

  TextEditingController _landmarkCtrl = TextEditingController();
  TextEditingController _checkInCtrl = TextEditingController();
  TextEditingController _checkOutCtrl = TextEditingController();
  TextEditingController _roomGuestCtrl = TextEditingController();

  Future<void> _selectCheckIn(
      BuildContext context, TextEditingController ctrl) async {
    var today = DateTime.now();
    var lastDay = today.add(Duration(days: 90));
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: today,
        lastDate: lastDay);
    if (picked != null)
      setState(() {
        ctrl.text = dateFormat.format(picked);
      });
  }

  Future<void> _selectCheckOut(
      BuildContext context, TextEditingController ctrl) async {
    var today = DateTime.now();
    var nextDay = today.add(Duration(days: 1));
    var lastDay = today.add(Duration(days: 180));
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: nextDay,
        firstDate: nextDay,
        lastDate: lastDay);
    if (picked != null)
      setState(() {
        ctrl.text = dateFormat.format(picked);
      });
  }

  // initializing data
  initializeData() async {
    // loading hot deals
    await LocalService.loadDeals().then((value) {
      setState(() {
        _deals = value;
        _dealsLoaded = true;
      });
    });

    // loading hotels
    await LocalService.loadHotels(true).then((value) {
      setState(() {
        _popularHotels = value;
        _popularLoaded = true;
      });
    });

    // loading places
    await LocalService.loadPlaces().then((value) {
      setState(() {
        _places = value;
        _placesLoaded = true;
      });
    });

    // loading blogs
    await LocalService.loadBlogs().then((value) {
      setState(() {
        _blogs = value;
        _blogsLoaded = true;
      });
    });
  }

  Widget nearbyCard() {
    var lang = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.only(left: Sizes.s20, right: Sizes.s10),
      child: Column(
        children: <Widget>[
          Container(
            height: Sizes.s50,
            width: Sizes.s50,
            decoration: BoxDecoration(
              gradient: customGradient(),
              borderRadius: BorderRadius.all(
                Radius.circular(Sizes.s10),
              ),
            ),
            child: Icon(
              Icons.location_on,
              color: Colors.white,
            ),
          ),
          SizedBox(height: Sizes.s5),
          Text(
            "${lang.translate('screen.home.nearMe')}",
            style: TextStyle(
              fontSize: FontSize.s12,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   _landmarkCtrl.text = widget?.location ?? 'Cari Hotel...';
    // });
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    // init localization
    var lang = AppLocalizations.of(context);
    // init currency
    String currency = userCurrency(context);
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: Sizes.s20,
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(left: Sizes.s20, right: Sizes.s20),
              child: Column(
                children: <Widget>[
                  SearchOptionTextField(
                    controller: _landmarkCtrl,
                    label:
                        "${lang.translate('screen.searchOption.landmarkLabel')}",
                    onTap: () async {
                      final res = await openPage(context, SearchLocationUI());
                      if (res != null) {
                        setState(() {
                          _landmarkCtrl.text = res;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: Sizes.s15,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: SearchOptionTextField(
                          controller: _checkInCtrl,
                          label:
                              "${lang.translate('screen.searchOption.checkInLabel')}",
                          onTap: () async {
                            _selectCheckIn(context, _checkInCtrl);
                          },
                        ),
                      ),
                      Container(
                        width: Sizes.s20,
                      ),
                      Expanded(
                        flex: 1,
                        child: SearchOptionTextField(
                          controller: _checkOutCtrl,
                          label:
                              "${lang.translate('screen.searchOption.checkOutLabel')}",
                          onTap: () async {
                            _selectCheckOut(context, _checkOutCtrl);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Sizes.s15,
                  ),
                  SearchOptionTextField(
                    controller: _roomGuestCtrl,
                    label:
                        "${lang.translate('screen.searchOption.roomAndGuestLabel')}",
                    onTap: () async {
                      final result = await showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (builder) {
                            return CustomModal.show(context);
                          });
                      if (result != null) {
                        setState(() {
                          _roomGuestCtrl.text = result[0].data +
                              " ${lang.translate('screen.searchOption.room')}" +
                              "  & " +
                              result[1].data +
                              " ${lang.translate('screen.searchOption.guest')}";
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(Sizes.s20),
                height: Sizes.s40,
                width: double.maxFinite,
                child: GradientButton(
                  title:
                      "${lang.translate('screen.searchOption.searchButton')}",
                  onTap: () => openPage(context, HotelListV2UI()),
                  fontSize: FontSize.s18,
                ),
              ),
            ),
            // SizedBox(
            //   height: Sizes.s20,
            // ),
            // TitleWrapper(
            //   title: "${lang.translate('screen.home.findTag')}",
            //   onTap: null,
            //   showButton: false,
            // ),
            // SizedBox(
            //   height: Sizes.s15,
            // ),
            // Container(
            //   height: Sizes.s30,
            //   child: ListView(
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     children: <Widget>[
            //       Container(
            //         margin: EdgeInsets.only(left: Sizes.s20),
            //         child: GradientButton(
            //           title:
            //               "${lang.translate('screen.home.lessThan')} ${currency}10",
            //           onTap: () => openPage(context, HotelListV2UI()),
            //           fontSize: FontSize.s14,
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(left: Sizes.s10),
            //         child: GradientButton(
            //           title: "${currency}10 - ${currency}30",
            //           onTap: () => openPage(context, HotelListV2UI()),
            //           fontSize: FontSize.s14,
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(left: Sizes.s10),
            //         child: GradientButton(
            //           title: "${currency}30 - ${currency}70",
            //           onTap: () => openPage(context, HotelListV2UI()),
            //           fontSize: FontSize.s14,
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(left: Sizes.s10),
            //         child: GradientButton(
            //           title: "${currency}70 - ${currency}100",
            //           onTap: () => openPage(context, HotelListV2UI()),
            //           fontSize: FontSize.s14,
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(left: Sizes.s10, right: Sizes.s20),
            //         child: GradientButton(
            //           title:
            //               "${lang.translate('screen.home.moreThan')} ${currency}100",
            //           onTap: () => openPage(context, HotelListV2UI()),
            //           fontSize: FontSize.s14,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: Sizes.s20),
            TitleWrapper(
              title: "${lang.translate('screen.home.promoTag')}",
              onTap: () => openPage(context, PromoListUI()),
            ),
            SizedBox(height: Sizes.s15),
            Container(
              child: _dealsLoaded
                  ? CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 2,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        initialPage: 1,
                        autoPlay: false,
                      ),
                      items: _deals
                          .map(
                            (item) => InkWell(
                              onTap: () =>
                                  openPage(context, PromoDetailUI(promo: item)),
                              child: Container(
                                margin: EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Sizes.s15)),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        "assets/images/misc/placeholder.png",
                                    image: item.thumbnail,
                                    width: Sizes.s300,
                                    height: Sizes.s200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : Center(
                      child: CupertinoActivityIndicator(),
                    ),
            ),
            // Container(
            //   height: Sizes.s80,
            //   child: _placesLoaded
            //       ? ListView.builder(
            //           itemCount: _places.length,
            //           shrinkWrap: true,
            //           scrollDirection: Axis.horizontal,
            //           itemBuilder: (context, index) {
            //             return InkWell(
            //               onTap: () => openPage(
            //                 context,
            //                 HotelListV2UI(
            //                   location: _places[index].name,
            //                 ),
            //               ),
            //               // if first index, show nearby location
            //               child: index == 0
            //                   ? nearbyCard()
            //                   : PlaceCards(
            //                       image: "${_places[index].image}",
            //                       placeName: "${_places[index].name}",
            //                     ),
            //             );
            //           },
            //         )
            //       : Container(
            //           margin: EdgeInsets.only(left: Sizes.s15),
            //           child: ListView.builder(
            //             itemCount: 8,
            //             shrinkWrap: true,
            //             scrollDirection: Axis.horizontal,
            //             itemBuilder: (context, index) {
            //               // place loader
            //               return PlaceCardLoader();
            //             },
            //           ),
            //         ),
            // ),
            SizedBox(height: Sizes.s20),
            TitleWrapper(
              title: "${lang.translate('screen.home.popularTag')}",
              onTap: () => openPage(context, HotelListV2UI()),
            ),
            SizedBox(
              height: Sizes.s15,
            ),
            Container(
              height: Sizes.s270,
              child: _popularLoaded
                  ? ListView.builder(
                      itemCount: _popularHotels.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                            right: index == 4 ? Sizes.s20 : 0,
                          ),
                          child: PopularCards(
                            onTap: () => openPage(
                              context,
                              DetailUI(hotel: _popularHotels[index]),
                            ),
                            hotel: _popularHotels[index],
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return PopularCardLoader();
                      },
                    ),
            ),
            SizedBox(
              height: Sizes.s20,
            ),
            TitleWrapper(
              title: "${lang.translate('screen.home.bestTag')}",
              onTap: () => openPage(context, HotelListV2UI(location: null)),
            ),
            SizedBox(
              height: Sizes.s15,
            ),
            _popularLoaded
                ? ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _popularHotels.length,
                    itemBuilder: (context, index) {
                      return BestOfferCards(
                        onTap: () => openPage(
                          context,
                          DetailUI(hotel: _popularHotels[index]),
                        ),
                        hotel: _popularHotels[index],
                      );
                    },
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return BestOfferCardLoader();
                    },
                  ),
            SizedBox(
              height: Sizes.s20,
            ),
            // SizedBox(
            //   height: Sizes.s30,
            // ),
            // TitleWrapper(
            //   title: "${lang.translate('screen.home.nearbyTag')}",
            //   onTap: () => openPage(context, HotelListV2UI()),
            //   showButton: true,
            // ),
            // SizedBox(
            //   height: Sizes.s15,
            // ),
            // // card
            // _popularLoaded
            //     ? ListView.builder(
            //         padding: EdgeInsets.only(left: Sizes.s20, right: Sizes.s20),
            //         shrinkWrap: true,
            //         physics: NeverScrollableScrollPhysics(),
            //         itemCount: _popularHotels.length,
            //         itemBuilder: (context, index) {
            //           return NearbyCards(
            //             onTap: () => openPage(
            //               context,
            //               DetailUI(hotel: _popularHotels[index]),
            //             ),
            //             hotel: _popularHotels[index],
            //           );
            //         },
            //       )
            //     : ListView.builder(
            //         padding: EdgeInsets.only(left: Sizes.s20, right: Sizes.s20),
            //         shrinkWrap: true,
            //         physics: NeverScrollableScrollPhysics(),
            //         itemCount: 5,
            //         itemBuilder: (context, index) {
            //           return NearbyCardLoader();
            //         },
            //       ),
            // SizedBox(
            //   height: Sizes.s20,
            // ),
            // TitleWrapper(
            //   title: "${lang.translate('screen.home.inviteTag')}",
            //   onTap: null,
            //   showButton: false,
            // ),
            // SizedBox(
            //   height: Sizes.s15,
            // ),
            // InvitationCards(),
            // SizedBox(
            //   height: Sizes.s25,
            // ),
            TitleWrapper(
              title: "${lang.translate('screen.home.travelTag')}",
              onTap: null,
              showButton: false,
            ),
            SizedBox(
              height: Sizes.s15,
            ),
            Container(
              height: Sizes.s190,
              child: _blogsLoaded
                  ? ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _blogs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                            left: Sizes.s20,
                            right: index == 4 ? Sizes.s20 : 0,
                          ),
                          child: BlogCards(
                            blog: _blogs[index],
                            onTap: () => openPage(
                                context, BlogDetailUI(blog: _blogs[index])),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                            left: Sizes.s20,
                            right: index == 4 ? Sizes.s20 : 0,
                          ),
                          child: BlogCardLoader(),
                        );
                      },
                    ),
            ),
            // SizedBox(
            //   height: Sizes.s15,
            // ),
            // TitleWrapper(
            //   title: "${lang.translate('screen.home.findTag')}",
            //   onTap: null,
            //   showButton: false,
            // ),
            // SizedBox(
            //   height: Sizes.s15,
            // ),
            // Container(
            //   height: Sizes.s30,
            //   child: ListView(
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     children: <Widget>[
            //       Container(
            //         margin: EdgeInsets.only(left: Sizes.s20),
            //         child: GradientButton(
            //           title:
            //               "${lang.translate('screen.home.lessThan')} ${currency}10",
            //           onTap: () => openPage(context, HotelListV2UI()),
            //           fontSize: FontSize.s14,
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(left: Sizes.s10),
            //         child: GradientButton(
            //           title: "${currency}10 - ${currency}30",
            //           onTap: () => openPage(context, HotelListV2UI()),
            //           fontSize: FontSize.s14,
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(left: Sizes.s10),
            //         child: GradientButton(
            //           title: "${currency}30 - ${currency}70",
            //           onTap: () => openPage(context, HotelListV2UI()),
            //           fontSize: FontSize.s14,
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(left: Sizes.s10),
            //         child: GradientButton(
            //           title: "${currency}70 - ${currency}100",
            //           onTap: () => openPage(context, HotelListV2UI()),
            //           fontSize: FontSize.s14,
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(left: Sizes.s10, right: Sizes.s20),
            //         child: GradientButton(
            //           title:
            //               "${lang.translate('screen.home.moreThan')} ${currency}100",
            //           onTap: () => openPage(context, HotelListV2UI()),
            //           fontSize: FontSize.s14,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: Sizes.s20,
            // )
          ],
        ),
      ),
    );
  }
}
