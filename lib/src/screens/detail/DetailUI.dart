// ignore_for_file: unused_import

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lokania/src/helpers/localization.dart';
import 'package:lokania/src/helpers/modal.dart';
import 'package:lokania/src/helpers/navigation.dart';
import 'package:lokania/src/helpers/toast.dart';
import 'package:lokania/src/models/HotelModel.dart';
import 'package:lokania/src/screens/payment/PaymentUI.dart';
import 'package:lokania/src/screens/photoviewer/PhotoViewer.dart';
import 'package:lokania/src/screens/reviews/ReviewsUI.dart';
import 'package:lokania/src/screens/room_detail/RoomDetailUI.dart';
import 'package:lokania/src/services/local_service.dart';
import 'package:lokania/src/utils/colors.dart';
import 'package:lokania/src/utils/sizes.dart';
import 'package:lokania/src/widgets/cards.dart';
import 'package:lokania/src/widgets/chips.dart';
import 'package:lokania/src/widgets/common_widgets.dart';
import 'package:lokania/src/widgets/read_more.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:lokania/src/screens/maps/MapsUI.dart';

class DetailUI extends StatefulWidget {
  final Hotel hotel;
  DetailUI({@required this.hotel});

  @override
  _DetailUIState createState() => _DetailUIState();
}

class _DetailUIState extends State<DetailUI> {
  var _scaffoldKey = GlobalKey<ScaffoldState>(); // scaffold identifier
  var top = 0.0;
  ScrollController _controller = ScrollController();
  bool silverCollapsed = false;
  List<String> tags = [];
  List<String> options = [
    'Parking',
    'Smoking',
    'TV',
    'Restaurant',
    'Wifi',
    'Air Conditioning',
    'Soundproof'
  ];

  bool _loaded = false;
  List<Hotel> _hotels = [];
  Random random = Random();
  int randReview = 0;
  // DateTime nextDay = today.add(Duration(days: 1));
  // handling sliver when user scrolling
  void handleSlivers() {
    _controller.addListener(() {
      if (_controller.offset > Sizes.s200 && !_controller.position.outOfRange) {
        if (!silverCollapsed) {
          silverCollapsed = true;
          setState(() {});
        }
      }
      if (_controller.offset <= Sizes.s200 &&
          !_controller.position.outOfRange) {
        if (silverCollapsed) {
          silverCollapsed = false;
          setState(() {});
        }
      }
    });
  }

  // simulate loading related hotels
  loadRelatedHotels() async {
    await LocalService.loadHotels(false).then((value) {
      setState(() {
        _loaded = true;
        _hotels = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      randReview = random.nextInt(5);
    });
    handleSlivers();
    loadRelatedHotels();
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String formatToday = DateFormat('d MMM').format(today);
    DateTime nextDay = today.add(Duration(days: 1));
    String formatNextDay = DateFormat('d MMM').format(nextDay);
    DateTime day60 = today.add(Duration(days: 60));
    DateTime day180 = today.add(Duration(days: 180));
    var lang = AppLocalizations.of(context);
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              expandedHeight: 200,
              floating: false,
              pinned: true,
              title: Text(
                silverCollapsed ? "${widget.hotel.name}" : "",
              ),
              actions: <Widget>[
                // IconButton(icon: Icon(Feather.heart), onPressed: () {}),
                // IconButton(icon: Icon(Feather.share_2), onPressed: () {}),
              ],
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                    background: InkWell(
                      onTap: () => openPage(
                        context,
                        PhotoViewer(pictures: widget.hotel.pictures),
                      ),
                      child: Carousel(
                        images: widget.hotel.pictures
                            .map(
                              (item) => FadeInImage.assetNetwork(
                                placeholder:
                                    "assets/images/misc/placeholder.png",
                                image: item.url,
                                fit: BoxFit.cover,
                              ),
                            )
                            .toList(),
                        dotSize: Sizes.s5,
                        dotSpacing: Sizes.s15,
                        dotColor: primaryColor,
                        indicatorBgPadding: Sizes.s5,
                        borderRadius: true,
                        autoplay: false,
                        dotBgColor: Colors.transparent,
                        radius: Radius.circular(0),
                      ),
                    ),
                    collapseMode: CollapseMode.parallax,
                  );
                },
              ),
            ),
          ];
        },
        body: Container(
          margin: EdgeInsets.only(
              left: Sizes.s20, right: Sizes.s20, top: Sizes.s20),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text("${widget.hotel.name}"),
                      subtitle: Text("${widget.hotel.fullLocation}"),
                      trailing: InkWell(
                        onTap: () => openPage(context, MapsUI()),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FlutterIcons.location_evi,
                              size: FontSize.s20,
                            ),
                            Text(
                              "${lang.translate('screen.detail.mapButton')}",
                              style: TextStyle(
                                fontSize: FontSize.s12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        RatingsValue(rating: "${widget.hotel.rating}"),
                        Text(
                          " ${lang.translate('screen.detail.fromTxt')} ${widget.hotel.reviews.length} ${lang.translate('screen.detail.reviewsTxt')}",
                          style: TextStyle(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Sizes.s30,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TitleIconWrapper(
                      title: "${lang.translate('screen.detail.reviewsTitle')}",
                      icon: FlutterIcons.comment_account_mco,
                    ),
                    Divider(),
                    SizedBox(height: Sizes.s10),
                    ReviewWrapper(
                      review: widget.hotel.reviews[randReview],
                      onReport: (String val) {
                        showToast(_scaffoldKey, val);
                      },
                    ),
                    SizedBox(height: Sizes.s20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => openPage(
                          context,
                          ReviewsUI(
                            reviews: widget.hotel.reviews,
                          ),
                        ),
                        child: Text(
                          "${lang.translate('screen.detail.viewAllReviews')}",
                          style: TextStyle(
                            fontSize: FontSize.s14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: Sizes.s30,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    TitleIconWrapper(
                      title:
                          "${lang.translate('screen.detail.descriptionTitle')}",
                      icon: FlutterIcons.building_faw,
                    ),
                    Divider(),
                    // Text("${widget.hotel.description}")
                    ReadMoreText(
                      "${widget.hotel.description}",
                      trimLines: 3,
                      colorClickableText: primaryColor,
                      trimMode: TrimMode.Line,
                      trimCollapsedText:
                          "..${lang.translate('screen.detail.readMoreTxt')}",
                      trimExpandedText:
                          " ${lang.translate('screen.detail.readLessTxt')}",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Sizes.s30,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    TitleIconWrapper(
                      title: "${lang.translate('screen.detail.facilityTitle')}",
                      icon: FlutterIcons.bathtub_faw,
                    ),
                    Divider(),
                    GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.hotel.facilities.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.5, // tambahkan nilai berikut
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          Facilities facilities =
                              widget.hotel.facilities[index];
                          return Row(
                            children: <Widget>[
                              Icon(Icons.check),
                              SizedBox(
                                width: Sizes.s5,
                              ),
                              Flexible(
                                child: Text(facilities.name),
                              )
                            ],
                          );
                        })
                  ],
                ),
              ),
              SizedBox(
                height: Sizes.s30,
              ),
              Container(
                width: _width,
                child: Column(
                  children: <Widget>[
                    TitleIconWrapper(
                      title:
                          "${lang.translate('screen.detail.travelDateTitle')}",
                      icon: FlutterIcons.calendar_account_mco,
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TravelDetailCard(
                          title:
                              "${lang.translate('screen.detail.checkInTag')}",
                          textTitle: formatToday,
                          textSubtitle: "12:00",
                          onTap: () async {
                            final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: today,
                                firstDate: today,
                                lastDate: day60);
                            print(">> PICKED : $picked");
                          },
                        ),
                        TravelDetailCard(
                          title:
                              "${lang.translate('screen.detail.checkOutTag')}",
                          textTitle: formatNextDay,
                          textSubtitle: "12:00",
                          onTap: () async {
                            final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: nextDay,
                                firstDate: nextDay,
                                lastDate: day180);
                            print(">> PICKED : $picked");
                          },
                        ),
                        Expanded(
                          flex: 1,
                          child: TravelDetailCard(
                            title:
                                "${lang.translate('screen.detail.detailsTag')}",
                            textTitle:
                                "2 ${lang.translate('screen.detail.guestTag')}",
                            textSubtitle:
                                "1 ${lang.translate('screen.detail.roomTag')}",
                            onTap: () async {
                              final result = await showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (builder) {
                                    return CustomModal.show(context);
                                  });
                              if (result != null) {
                                print(">> RESULT : ${result.length}");
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: Sizes.s30,
              ),
              Container(
                // height: Sizes.s260,
                child: Column(
                  children: <Widget>[
                    TitleIconWrapper(
                      title:
                          "${lang.translate('screen.detail.availableRoomTitle')}",
                      icon: FlutterIcons.ios_bed_ion,
                    ),
                    Divider(),
                    _loaded
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.hotel.rooms.length,
                            itemBuilder: (context, index) {
                              Rooms room = widget.hotel.rooms[index];
                              return HotelRoomCard(
                                room: room,
                                onTapInfo: () => openPage(
                                  context,
                                  RoomDetailUI(
                                    room: room,
                                  ),
                                ),
                                onTapBooking: () => openPage(
                                  context,
                                  PaymentUI(),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: CupertinoActivityIndicator(),
                          )
                  ],
                ),
              ),
              SizedBox(
                height: Sizes.s30,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    TitleIconWrapper(
                      title:
                          "${lang.translate('screen.detail.propertyPolicyTitle')}",
                      icon: FlutterIcons.info_faw,
                    ),
                    Divider(),
                    CustomMarkdown(
                      icon: Icons.brightness_1,
                      title: Text(
                        "Lorem ipsum dolor sit amet 2x24",
                        style: TextStyle(fontSize: FontSize.s14),
                      ),
                    ),
                    CustomMarkdown(
                      icon: Icons.brightness_1,
                      title: Text(
                        "Lorem ipsum dolor sit amet 2x24",
                        style: TextStyle(fontSize: FontSize.s14),
                      ),
                    ),
                    CustomMarkdown(
                      icon: Icons.brightness_1,
                      title: Text(
                        "Lorem ipsum dolor sit amet 2x24 Lorem ipsum dolor sit amet 2x24 Lorem ipsum dolor sit amet 2x24 Lorem ipsum dolor sit amet 2x24",
                        style: TextStyle(fontSize: FontSize.s14),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Sizes.s30),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TitleIconWrapper(
                      title:
                          "${lang.translate('screen.detail.relatedHotelTitle')}",
                      icon: FlutterIcons.columns_faw,
                    ),
                    Divider(),
                    Container(
                      height: Sizes.s240,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _hotels.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: index == _hotels.length - 1
                                ? EdgeInsets.zero
                                : EdgeInsets.only(right: Sizes.s20),
                            child: RelatedHotelCard(
                              hotel: _hotels[index],
                              onTap: () => openPage(
                                context,
                                DetailUI(
                                  hotel: _hotels[index],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
