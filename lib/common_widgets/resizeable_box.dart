import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ResizeableBox extends StatefulWidget {
  final double initialWidth;
  final Widget child;
  final ValueSetter<double>? onWidthChange;
  const ResizeableBox(
      {super.key,
      required this.initialWidth,
      required this.child,
      this.onWidthChange});

  @override
  State<ResizeableBox> createState() => _ResizeableBoxState();
}

class _ResizeableBoxState extends State<ResizeableBox> {
  final double handleSize = 5;
  double width = 0;
  bool hovering = false;
  GlobalKey key = GlobalKey();

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
        key: key,
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
                  RenderBox box =
                      key.currentContext?.findRenderObject() as RenderBox;
                  Offset position = box.localToGlobal(Offset.zero);
                  width = details.globalPosition.dx - position.dx;
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
