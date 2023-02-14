import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ResizeableSidebar extends StatefulWidget {
  final double initialWidth;
  final Widget child;
  final ValueSetter<double>? onWidthChange;
  const ResizeableSidebar(
      {super.key,
      required this.initialWidth,
      required this.child,
      this.onWidthChange});

  @override
  State<ResizeableSidebar> createState() => _ResizeableSidebarState();
}

class _ResizeableSidebarState extends State<ResizeableSidebar> {
  final double handleSize = 5;
  double width = 0;
  bool hovering = false;

  @override
  void initState() {
    width = widget.initialWidth;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

    return GestureDetector(
      child: Container(
        width: width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: currentTheme['border'] as Color,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(child: widget.child),
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  width = details.globalPosition.dx - 47;
                  if (width < 170) {
                    width = 170;
                  } else {
                    hovering = true;
                  }
                  if (widget.onWidthChange != null) {
                    widget.onWidthChange!(width);
                  }
                });
              },
              child: InkWell(
                onTap: () {}, // This is needed for onHover to work
                onHover: (val) {
                  setState(() {
                    hovering = val;
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeftRight,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        color: hovering
                            ? currentTheme['accent']
                            : Colors.transparent),
                    child: SizedBox(
                      width: hovering ? handleSize : 1,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
