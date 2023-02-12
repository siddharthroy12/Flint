import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flint/providers/theme_provider.dart';

class FruitColorizer extends TextEditingController {
  final Map<String, TextStyle> mapping;
  final Pattern pattern;

  FruitColorizer(this.mapping)
      : pattern =
            RegExp(mapping.keys.map((key) => RegExp.escape(key)).join('|'));
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<InlineSpan> children = [];
    // splitMapJoin is a bit tricky here but i found it very handy for populating children list
    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        children.add(TextSpan(text: '', children: [
          WidgetSpan(
              child: TextButton(
            child: Text(match[0] ?? ''),
            onPressed: () {},
          ))
        ]));

        return '';
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return '';
      },
    );
    return TextSpan(style: style, children: children);
  }
}

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: FruitColorizer({
      'apple':
          TextStyle(color: Colors.green, decoration: TextDecoration.underline),
      'orange': TextStyle(color: Colors.orange, shadows: kElevationToShadow[2]),
    }));
  }
}
