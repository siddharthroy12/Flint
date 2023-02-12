import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  var _currentTheme = 'dark';
  static var themeList = {
    'dark': {
      'primaryBackground': const Color.fromARGB(255, 22, 22, 22),
      'secondaryBackground': const Color.fromARGB(255, 14, 14, 14),
      'onPrimaryBackground': const Color.fromARGB(255, 126, 126, 126),
      'highlightBackground': const Color.fromARGB(255, 41, 41, 41),
      'accent': const Color.fromARGB(255, 146, 74, 240),
      'border': const Color.fromARGB(255, 32, 32, 32)
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
