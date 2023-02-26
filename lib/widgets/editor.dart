import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    final windowButtonsColors =
        WindowButtonColors(iconNormal: Theme.of(context).colorScheme.secondary);

    return Column(
      children: [
        SizedBox(
          height: topBarHeight,
          child: MoveWindow(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MinimizeWindowButton(
                  colors: windowButtonsColors,
                ),
                MaximizeWindowButton(
                  colors: windowButtonsColors,
                ),
                CloseWindowButton(
                  colors: windowButtonsColors,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
