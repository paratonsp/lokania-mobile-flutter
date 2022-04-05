import 'package:flutter/material.dart';

showToast(GlobalKey<ScaffoldState> _scaffoldKey, String content) {
  ScaffoldMessenger(
    key: _scaffoldKey,
    child: SnackBar(
      content: Text(
        "$content",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black.withOpacity(.5),
    ),
  );
}
