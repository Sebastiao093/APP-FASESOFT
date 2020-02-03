import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class PantallaWeb extends StatefulWidget {
  static const routedname = "/PantallaWeb";

  @override
  _PantallaWebState createState() => _PantallaWebState();
}

class _PantallaWebState extends State<PantallaWeb> {
  final Completer<WebViewController> _controller = 
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web'),
      ),
      body: WebView(
        initialUrl: 'https://apps.asesoftware.com/ares',
        onWebViewCreated: (WebViewController webViewController){
          _controller.complete(webViewController);
        },javascriptMode: JavascriptMode.unrestricted,
        ),
    );
  }
}
