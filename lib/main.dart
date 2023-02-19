import 'package:flutter/material.dart';
// Pages
import './pages/kanban_page.dart';
import 'pages/notes_page/notes_page.dart';
import './pages/timeline_page.dart';
import './pages/not_found_page.dart';
// Page transition animation
import './fade_route_animation.dart';
// Global State
import 'package:provider/provider.dart';
import './providers/theme_provider.dart';
import 'package:flint/providers/user_data_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
        initialRoute: '/notes',
        theme: ThemeData.dark(),
        onGenerateRoute: (settings) {
          Widget page;
          switch (settings.name) {
            case '/notes':
              page = const NotesPage();
              break;
            case '/kanban':
              page = const KanbanPage();
              break;
            case '/timeline':
              page = const TimelinePage();
              break;
            default:
              page = const NotFoundPage();
          }
          // Page chaning animation
          return FadeRouteBuilder(page: page, settings: settings);
        },
      ),
    );
  }
}
