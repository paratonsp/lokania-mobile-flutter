import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewUI extends StatelessWidget {
  final String url;
  final String title;
  WebviewUI({@required this.url, @required this.title});

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
      // appBar: AppBar(
      //   title: Text("$title"),
      // ),
      // withZoom: true,
      // withLocalStorage: true,
      // hidden: true,
      // initialChild: Container(
      //   color: Theme.of(context).scaffoldBackgroundColor,
      //   child: const Center(
      //     child: CupertinoActivityIndicator(),
      //   ),
      // ),
    );
  }
}
