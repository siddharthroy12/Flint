import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

enum Direction { left, right }

// Controller to controller to set and get width of ResizeableBox
class ResizeController {
  // Callback function that will be set by the ResizeableBox
  // This will get called whenever the width is set from this controller
  void Function(double width)? onChangeWidth;
  // The width of the ResizeableBox
  double _width = 0;

  // Set the width of ResizeableBox
  set width(double w) {
    _width = w;
    if (onChangeWidth != null) {
      onChangeWidth!(w);
    }
  }

  // Get width of ResizeableBox
  double get width {
    return _width;
  }
}

// Widget with a handle to reisze it's size
class ResizeableBox extends StatefulWidget {
  // Initial width of the widget
  final double initialWidth;
  // The maximum size of the widget
  final double minimumWidth;
  // The Direction of the handle
  final Direction direction;
  // Context of the Widget
  final Widget child;
  // Controller to set/get the width of the widget
  final ResizeController? resizeController;
  // This callback function will get called everytime the size of the
  // widget changes
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
  // Size of the handle
  final double _handleSize = 2;
  // Width of the widget
  double _width = 0;
  // Is cursor hovering the handle?
  bool _hovering = false;
  // This key is being used to get the position of the widget
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    // Set the initial width
    _width = widget.initialWidth;

    if (widget.resizeController != null) {
      // Update the contoller's width
      widget.resizeController?.width = _width;
      // Set the callback so that the width is changeable from controller
      widget.resizeController?.onChangeWidth = (double width) {
        setState(() {
          _width = width;
        });
        // It's is important the update the width inside the controller too
        widget.resizeController?._width = width;
      };
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // Properly remove the callback to prevent memory leak
    widget.resizeController?.onChangeWidth = null;
  }

  @override
  Widget build(BuildContext context) {
    // The current theme
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

    // Update the width inside controller
    widget.resizeController?.width = _width;

    // The "handle" to change to resize the widget
    var handle = GestureDetector(
      // Set hovering to false when dragging is finished otherwise
      // the handle will stay active
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
      // Resize the width by calculating the position of the mouse
      // Relative to the positing of the
      onHorizontalDragUpdate: (details) {
        setState(() {
          RenderBox box = _key.currentContext?.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero);
          if (widget.direction == Direction.right) {
            _width = details.globalPosition.dx - position.dx;
          } else {
            _width = (position.dx + box.size.width) - details.globalPosition.dx;
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
        // To change the cursor to resize
        // TODO:
        //  This doesn't work perfectly because
        //  the mouse isn't always on top of the handle
        //  when dragging
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _hovering
                  ? Theme.of(context).colorScheme.tertiary
                  : Colors.transparent,
            ),
            child: SizedBox(
              width: _hovering ? _handleSize : 1,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
      ),
    );

    return Container(
      key: _key,
      width: _width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: widget.direction == Direction.right
                ? Theme.of(context).colorScheme.outline
                : Colors.transparent,
          ),
          left: BorderSide(
            color: widget.direction == Direction.left
                ? Theme.of(context).colorScheme.outline
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
    );
  }
}
