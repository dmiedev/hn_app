import 'package:flutter/material.dart';

const Duration headlineAnimationDuration = const Duration(milliseconds: 400);
const List<Color> headlineTextColors = [Colors.blue, Colors.deepOrange];

class Headline extends ImplicitlyAnimatedWidget {
  final String text;
  final int index;

  Color get targetColor => headlineTextColors[index];

  Headline({Key key, @required this.text, @required this.index})
      : super(key: key, duration: headlineAnimationDuration);

  @override
  _HeadlineState createState() => _HeadlineState();
}

class _HeadlineState extends AnimatedWidgetBaseState<Headline> {
  _FadeColorTween _colorTween;
  _StringTween _stringTween;

  @override
  Widget build(BuildContext context) {
    return Text(
      _stringTween.evaluate(animation),
      style: TextStyle(color: _colorTween.evaluate(animation)),
    );
  }

  @override
  void forEachTween(visitor) {
    _colorTween = visitor(
      _colorTween,
      widget.targetColor,
      (color) => _FadeColorTween(begin: color),
    );
    _stringTween = visitor(
      _stringTween,
      widget.text,
      (text) => _StringTween(begin: text),
    );
  }
}

class _FadeColorTween extends ColorTween {
  _FadeColorTween({
    Color begin,
    Color end,
  }) : super(begin: begin, end: end);

  @override
  Color lerp(double t) => t < 0.5
      ? Color.lerp(begin, null, t * 2)
      : Color.lerp(null, end, (t - 0.5) * 2);
}

class _StringTween extends Tween<String> {
  _StringTween({String begin, String end}) : super(begin: begin, end: end);

  @override
  String lerp(double t) => t < 0.5 ? begin : end;
}
