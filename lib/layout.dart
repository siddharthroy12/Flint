import 'package:flutter/material.dart';
import './sidebar.dart';
import 'package:provider/provider.dart';
import './providers/theme_provider.dart';

class Layout extends StatelessWidget {
  final Widget child;
  const Layout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ThemeProvider>(
          builder: (_, themeProvider, __) => Material(
            color: themeProvider.currentTheme['primaryBackground'],
            child: Row(
              children: [const Sidebar(), Expanded(child: child)],
            ),
          ),
        ),
      ),
    );
  }
}
