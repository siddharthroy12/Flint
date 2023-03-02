import 'package:flutter/material.dart';
import './widgets/sidebar.dart';
import './widgets/editor.dart';
import './widgets/notes.dart';
// Global State
import 'package:provider/provider.dart';
import './providers/theme_provider.dart';
import 'package:flint/providers/user_data_provider.dart';
// Custom window decoration library
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() {
  runApp(MyApp());

  doWhenWindowReady(() {
    appWindow.minSize = const Size(600, 450);
    appWindow.size = const Size(800, 550);
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final darkThemeData = ThemeData.from(
    colorScheme: const ColorScheme.dark(
      error: Color(0xFFED2960),
      secondaryContainer: Color(0xFF121212), // Sidebar Background Color
      background: Color(0xFF181818), // Editor Background Color
      outline: Color(0xFF252525), // Border Color
      primary: Color(0xFFE7E7E7), // Editor color
      secondary: Color(0xFF939393), // Icon Color
      tertiary: Color.fromARGB(255, 12, 94, 202), // Accent color
      inversePrimary: Color(0xFF5C5C5C), // Less important text Color
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserDataProvider())
      ],
      child: MaterialApp(
        title: 'Flint',
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        themeMode: ThemeMode.dark,
        darkTheme: darkThemeData,
        home: Builder(builder: (context) {
          return Scaffold(
            body: WindowBorder(
              color: Theme.of(context).colorScheme.outline,
              child: Row(
                children: const [
                  Sidebar(),
                  Notes(),
                  Expanded(
                    child: Editor(),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
