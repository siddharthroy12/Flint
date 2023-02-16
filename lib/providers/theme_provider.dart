import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  var _currentTheme = 'dark';
  static var themeList = {
    'dark': {
      'primaryBackground': const Color(0xFF1E1E1E),
      'topbarBackground': const Color(0xFF242424),
      'secondaryBackground': const Color(0xFF181818),
      'onPrimaryBackground': const Color.fromARGB(255, 151, 151, 151),
      'highlightBackground': const Color.fromARGB(255, 41, 41, 41),
      'accent': const Color(0xFF8E7EF0),
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
