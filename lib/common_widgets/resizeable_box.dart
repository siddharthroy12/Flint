import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

enum Direction { left, right }

class ResizeController {
  void Function(double width) onChangeWidth = (_) {};
  double width = 0;
  void changeWidth(double width) {
    onChangeWidth(width);
  }
}

class ResizeableBox extends StatefulWidget {
  final double initialWidth;
  final double minimumWidth;
  final Direction direction;
  final Widget child;
  final ResizeController? resizeController;

  final ValueSetter<double>? onWidthChange;
  const ResizeableBox({
    super.key,
    required this.initialWidth,
    required this.child,
    this.onWidthChange,
    this.minimumWidth = 170,
    this.direction = Direction.right,
    this.resizeController,
  });

  @override
  State<ResizeableBox> createState() => _ResizeableBoxState();
}

class _ResizeableBoxState extends State<ResizeableBox> {
  final double _handleSize = 5;
  double _width = 0;
  bool _hovering = false;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    _width = widget.initialWidth;
    if (widget.resizeController != null) {
      widget.resizeController?.width = _width;

      widget.resizeController?.onChangeWidth = (double width) {
        setState(() {
          _width = width;
        });
        widget.resizeController?.width = width;
      };
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    widget.resizeController?.width = _width;

    var handle = GestureDetector(
      onHorizontalDragCancel: () {
        setState(() {
          _hovering = false;
        });
      },
      onHorizontalDragEnd: (_) {
        setState(() {
          _hovering = false;
        });
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          RenderBox box = _key.currentContext?.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero);
          if (widget.direction == Direction.right) {
            _width = details.globalPosition.dx - position.dx;
          } else {
            _width =
                MediaQuery.of(context).size.width - details.globalPosition.dx;
          }
          if (_width < widget.minimumWidth) {
            _width = widget.minimumWidth;
          } else {
            _hovering = true;
          }
          if (widget.onWidthChange != null) {
            widget.onWidthChange!(_width);
          }
        });
      },
      child: InkWell(
        onTap: () {}, // This is needed for onHover to work
        onHover: (val) {
          setState(() {
            _hovering = val;
          });
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _hovering ? currentTheme['accent'] : Colors.transparent,
            ),
            child: SizedBox(
              width: _hovering ? _handleSize : 1,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
      ),
    );

    return GestureDetector(
      child: Container(
        key: _key,
        width: _width,
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
