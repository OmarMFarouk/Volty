import 'package:flutter/material.dart';
import '../../components/general/my_bar.dart';
import '../../components/general/my_loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../components/general/my_animation.dart';
import '../../src/app_colors.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    super.key,
    required this.url,
    required this.title,
    required this.icon,
    this.subTitle,
  });
  final String url, title;
  final String? subTitle;
  final IconData icon;
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => MyLoadingIndicator.showLoader(context, canPop: true),
    );
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..clearCache() // Enable JS for modern websites
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => Navigator.pop(context),
          onNavigationRequest: (request) {
            if (!request.url.contains(Uri.parse(widget.url).host)) {
              launchUrl(
                Uri.parse(request.url),
                mode: LaunchMode.externalApplication,
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url)).timeout(Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: MyCustomAnimation(
        duration: 750,
        child: Column(
          children: [
            MyBar(
              title: widget.title,
              actionTitle: "رجوع",
              onAction: () => Navigator.pop(context),
              subtitle: widget.subTitle ?? 'الإطلاع و قراءة ${widget.title}',
              icon: widget.icon,
            ),
            Expanded(child: WebViewWidget(controller: _controller)),
          ],
        ),
      ),
    );
  }
}
