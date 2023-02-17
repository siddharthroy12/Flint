import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final AxisDirection preferredTooltipDirection;
  final void Function() onClick;
  final bool? highlighted;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.preferredTooltipDirection,
    required this.onClick,
    this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    Color iconColor = currentTheme['onPrimaryBackground'];
    Color iconHighlightColor = currentTheme['highlightBackground'];
    Color accentColor = currentTheme['accent'];
    Color secondaryBackgroundColor = currentTheme['secondaryBackground'];
    Color backgroundColor = currentTheme['tooltipBackground'];
    Color textColor = currentTheme['tooltipText'];

    return JustTheTooltip(
      tailLength: 0,
      tailBaseWidth: 0,
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(2.0),
      offset: 5,
      backgroundColor: backgroundColor,
      preferredDirection: preferredTooltipDirection,
      content: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          tooltip,
          style: TextStyle(fontSize: 12, color: textColor),
        ),
      ),
      child: SizedBox(
        height: 30,
        width: 30,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => (highlighted ?? false) ? iconHighlightColor : null),
            padding: MaterialStateProperty.resolveWith((states) =>
                const EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (state) {
                return iconColor;
              },
            ),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) => iconHighlightColor,
            ),
          ),
          onPressed: onClick,
          child: Icon(
            icon,
            color: (highlighted ?? false) ? accentColor : null,
            size: 20,
          ),
        ),
      ),
    );
  }
}
