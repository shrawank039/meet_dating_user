import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CustomWebView extends StatefulWidget {
  final String ? selectedUrl;

  CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {

  // final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    // flutterWebviewPlugin.onUrlChanged.listen((String url) {
    //   if (url.contains("#access_token")) {
    //     succeed(url);
    //   }
    //
    //   if (url.contains(
    //       "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
    //     denied();
    //   }
    // });
  }

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");
    var endparam = params[1].split("&");
    Navigator.pop(context, endparam[0]);
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.selectedUrl!,
      onPageStarted: (String url) {
        if (url.contains("#access_token")) {
          succeed(url);
        }
        if (url.contains(
            "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
          denied();
        }
      },
      onPageFinished: (String url) {
        if (url.contains("#access_token")) {
          succeed(url);
        }
        if (url.contains(
            "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
          denied();
        }
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return WebviewScaffold(
  //       url: widget.selectedUrl!,
  //       appBar: new AppBar(
  //         backgroundColor: Color.fromRGBO(66, 103, 178, 1),
  //         title: new Text("Facebook login"),
  //       ));
  // }
}
