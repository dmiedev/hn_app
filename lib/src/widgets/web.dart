import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class HackerNewsWebPage extends StatelessWidget {
  HackerNewsWebPage({this.url, this.title});

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class HackerNewsCommentPage extends StatelessWidget {
  final int id;

  HackerNewsCommentPage({this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: WebView(
        initialUrl: 'https://news.ycombinator.com/item?id=$id',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
