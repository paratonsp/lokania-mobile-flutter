import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';
import 'package:lokania/src/models/BlogModel.dart';
import 'package:lokania/src/models/BookingHistory.dart';
import 'package:lokania/src/models/FaqModel.dart';
import 'package:lokania/src/models/HotelModel.dart';
import 'package:lokania/src/models/NotificationModel.dart';
import 'package:lokania/src/models/PlaceModel.dart';
import 'package:lokania/src/models/PromoModel.dart';

class LocalService {
  static Future<List<Hotel>> loadHotels(bool hold) async {
    if (hold) await Future.delayed(Duration(milliseconds: 3000));
    var result = await http.get('https://lokania.pesoros.com/api/v1/hotels');
    var datas = (json.decode(result.body) as List)
        .map<Hotel>((json) => Hotel.fromJson(json))
        .toList();
    return datas;
  }

  static Future<List<Place>> loadPlaces() async {
    await Future.delayed(Duration(milliseconds: 3000));
    var result = await http.get('https://lokania.pesoros.com/api/v1/places');
    var datas = (json.decode(result.body) as List)
        .map<Place>((json) => Place.fromJson(json))
        .toList();
    return datas;
  }

  static Future<List<Blog>> loadBlogs() async {
    await Future.delayed(Duration(milliseconds: 3000));
    var result = await rootBundle.loadString('assets/json/data/blogs.json');
    var datas = (json.decode(result) as List)
        .map<Blog>((json) => Blog.fromJson(json))
        .toList();
    return datas;
  }

  static Future<List<FaqModel>> loadFaqs() async {
    await Future.delayed(Duration(milliseconds: 3000));
    var result = await rootBundle.loadString('assets/json/data/faqs.json');
    var datas = (json.decode(result) as List)
        .map<FaqModel>((json) => FaqModel.fromJson(json))
        .toList();
    return datas;
  }

  static Future<List<PromoModel>> loadDeals() async {
    await Future.delayed(Duration(milliseconds: 3000));
    var result = await http.get('https://lokania.pesoros.com/api/v1/deals');
    var datas = (json.decode(result.body) as List)
        .map<PromoModel>((json) => PromoModel.fromJson(json))
        .toList();
    return datas;
  }

  static Future<List<NotificationModel>> loadNotifications() async {
    await Future.delayed(Duration(milliseconds: 3000));
    var result =
        await http.get('https://lokania.pesoros.com/api/v1/notifications');
    var datas = (json.decode(result.body) as List)
        .map<NotificationModel>((json) => NotificationModel.fromJson(json))
        .toList();
    return datas;
  }

  static Future<List<BookingHistory>> loadBookingHistory() async {
    await Future.delayed(Duration(milliseconds: 3000));
    var result = await http.get('https://lokania.pesoros.com/api/v1/history');
    var datas = (json.decode(result.body) as List)
        .map<BookingHistory>((json) => BookingHistory.fromJson(json))
        .toList();
    return datas;
  }
}
