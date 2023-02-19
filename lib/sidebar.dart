import 'package:flint/common_widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/theme_provider.dart';

// The navigation sidebar
class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  static const navigations = [
    {'icon': Icons.note_alt_outlined, 'path': '/notes', 'tooltip': 'Notes'},
    {
      'icon': Icons.dashboard_outlined,
      'path': '/kanban',
      'tooltip': 'Kanban Board'
    },
    {'icon': Icons.history, 'path': '/timeline', 'tooltip': 'Timeline'},
  ];

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    // Get the name of the current route to highlight the correct button
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return Container(
      width: 50,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: currentTheme['border'] as Color,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: navigations.map(
            (e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: CustomIconButton(
                  icon: e['icon'] as IconData,
                  onClick: () {
                    Navigator.pushNamed(context, e['path'] as String);
                  },
                  highlighted: currentRoute == e['path'],
                  preferredTooltipDirection: AxisDirection.right,
                  tooltip: e['tooltip'] as String,
                ),
              );
            },
          ).toList(growable: false),
        ),
      ),
    );
  }
}
