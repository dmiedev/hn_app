import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsState {
  bool showWebView;
  bool useDarkMode;

  PrefsState({
    this.showWebView = true,
    this.useDarkMode = false,
  });
}

class PrefsNotifier with ChangeNotifier {
  var _currentPrefs = PrefsState();

  bool get showWebView => _currentPrefs.showWebView;
  bool get useDarkMode => _currentPrefs.useDarkMode;

  PrefsNotifier() {
    _loadSharedPrefs();
  }

  Future<void> _loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final showWebView =
        prefs.getBool('showWebView') ?? _currentPrefs.showWebView;
    final useDarkMode =
        prefs.getBool('useDarkMode') ?? _currentPrefs.useDarkMode;
    _currentPrefs = PrefsState(
      showWebView: showWebView,
      useDarkMode: useDarkMode,
    );
    notifyListeners();
  }

  set showWebView(bool newValue) {
    if (newValue == _currentPrefs.showWebView) return;
    _currentPrefs.showWebView = newValue;
    notifyListeners();
    _savePreference('showWebView', newValue);
  }

  set useDarkMode(bool newValue) {
    if (newValue == _currentPrefs.useDarkMode) return;
    _currentPrefs.useDarkMode = newValue;
    notifyListeners();
    _savePreference('useDarkMode', newValue);
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case bool:
        await prefs.setBool(key, value);
        break;
      case double:
        await prefs.setDouble(key, value);
        break;
      case int:
        await prefs.setInt(key, value);
        break;
      case String:
        await prefs.setString(key, value);
        break;
      default:
        throw PrefsNotifierException(
          "${value.runtimeType} isn't supported as SharedPreferences value.",
        );
    }
  }
}

class PrefsNotifierException implements Exception {
  final String message;

  PrefsNotifierException(this.message);
}
