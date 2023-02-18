import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

enum Direction { left, right }

class ResizeableBox extends StatefulWidget {
  final double initialWidth;
  final double minimumWidth;
  final Direction direction;
  final Widget child;

  final ValueSetter<double>? onWidthChange;
  const ResizeableBox({
    super.key,
    required this.initialWidth,
    required this.child,
    this.onWidthChange,
    this.minimumWidth = 170,
    this.direction = Direction.right,
  });

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

    var handle = GestureDetector(
      onHorizontalDragCancel: () {
        setState(() {
          hovering = false;
        });
      },
      onHorizontalDragEnd: (_) {
        setState(() {
          hovering = false;
        });
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero);
          if (widget.direction == Direction.right) {
            width = details.globalPosition.dx - position.dx;
          } else {
            width =
                MediaQuery.of(context).size.width - details.globalPosition.dx;
          }
          if (width < widget.minimumWidth) {
            width = widget.minimumWidth;
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
              color: hovering ? currentTheme['accent'] : Colors.transparent,
            ),
            child: SizedBox(
              width: hovering ? handleSize : 1,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
      ),
    );

    return GestureDetector(
      child: Container(
        key: key,
        width: width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: widget.direction == Direction.right
                  ? currentTheme['border'] as Color
                  : Colors.transparent,
            ),
            left: BorderSide(
              color: widget.direction == Direction.left
                  ? currentTheme['border'] as Color
                  : Colors.transparent,
            ),
          ),
        ),
        child: Row(
          children: [
            if (widget.direction == Direction.left) handle,
            Expanded(child: widget.child),
            if (widget.direction == Direction.right) handle
          ],
        ),
      ),
    );
  }
}
