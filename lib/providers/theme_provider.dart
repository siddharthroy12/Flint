import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  var _currentTheme = 'dark';
  static var themeList = {
    'dark': {
      'primaryBackground': const Color(0xFF1E1E1E),
      'secondaryBackground': const Color(0xFF121212),
      'onPrimaryBackground': const Color.fromARGB(255, 151, 151, 151),
      'highlightBackground': const Color.fromARGB(255, 41, 41, 41),
      'accent': const Color.fromARGB(255, 146, 74, 240),
      'border': const Color(0xFF353535)
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
