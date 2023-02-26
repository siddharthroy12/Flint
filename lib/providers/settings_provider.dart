import 'package:flutter/material.dart';

// A global state for managing themes
class ThemeProvider extends ChangeNotifier {
  var _currentTheme = 'dark';
  static var themeList = {
    'dark': {
      'primaryBackground': const Color(0xFF191919),
      'topbarBackground': const Color(0xFF242424),
      'secondaryBackground': const Color(0xFF202020),
      'onPrimaryBackground': const Color(0xFFA9A9A9),
      'highlightBackground': const Color.fromARGB(255, 41, 41, 41),
      'accent': const Color(0xFF8E7EF0),
      'border': const Color.fromARGB(255, 51, 51, 51),
      'tooltipBackground': Colors.white,
      'tooltipText': Colors.black
    }
  };

  setTheme(String name) {
    _currentTheme = name;
    notifyListeners();
  }

  get themeNames {
    return themeList.keys;
  }

  get currentTheme {
    return themeList[_currentTheme];
  }
}
