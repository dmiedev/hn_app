import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hn_app/src/notifiers/hn_api.dart';

class LoadingInfo extends StatefulWidget {
  final LoadingTabsCount isLoading;

  LoadingInfo(this.isLoading);

  @override
  LoadingInfoState createState() => LoadingInfoState();
}

class LoadingInfoState extends State<LoadingInfo>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    widget.isLoading.addListener(_handleLoadingChange);
  }

  void _handleLoadingChange() {
    if (widget.isLoading.value > 0) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      child: Icon(FontAwesomeIcons.hackerNewsSquare),
      turns: Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void dispose() {
    widget.isLoading.removeListener(_handleLoadingChange);
    _controller.dispose();
    super.dispose();
  }
}
