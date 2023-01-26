import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              // if (request.url.startsWith('https://www.youtube.com/')) {
              //   return NavigationDecision.prevent;
              // }
              return NavigationDecision.navigate;
            }),
      )
      ..setUserAgent(Platform.isIOS
          ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1'
          : 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36')
      ..enableZoom(false)
      ..loadRequest(Uri.parse('https://www.everyanswer.kr'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        var future = controller.canGoBack();
        future.then((canGoBack) => {
          if (canGoBack) {
            controller.goBack()
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('앱 종료'),
                content: Text('에브리엔서를 정말로 종료하시겠어요? 😥'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('아니오'),
                  ),
                  TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: Text('예'),
                  ),
                ],
              ),
            ),
          }
        });
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
