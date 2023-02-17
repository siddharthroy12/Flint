import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:flint/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flint/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/resizeable_box.dart';
import 'package:markdown_widget/markdown_widget.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

const textStyle = TextStyle(
  fontFamily: 'RobotoMono',
  fontSize: 14,
  fontWeight: FontWeight.w300,
  fontVariations: [FontVariation('wght', 300.0)],
);

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _textEditingController;
  late ScrollController _editorScrollController;
  late ScrollController _lineNumberScrollController;
  late ScrollController _verticalScrollController;
  File? _selectedNote;

  int _linesCount = 0;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      if (_selectedNote != null) {
        _selectedNote?.writeAsString(_textEditingController.text);
      }
    });
    _editorScrollController = ScrollController();
    _lineNumberScrollController = ScrollController();
    _verticalScrollController = ScrollController();
    _editorScrollController.addListener(() {
      _lineNumberScrollController.jumpTo(_editorScrollController.offset);
    });
  }

  void _toggleHeading() {
    int cursorOffset = _textEditingController.selection.base.offset;
    int pointer = cursorOffset;
    int cursorOffsetFromStartOfLine = 0;

    // If the cursor at new line we need to move back so
    // that we can find the previous new line
    if (_textEditingController.text[cursorOffset] == '\n') {
      pointer--;
    }

    // Now find the previous new line
    while (_textEditingController.text[pointer] != '\n' && pointer != 0) {
      pointer--;
      cursorOffsetFromStartOfLine++;
    }

    // Now move one step forward where the line start
    if (pointer != 0) {
      pointer++;
    }
    int startOfHash = pointer;

    // Cound number of #
    int countOfHashTag = 0;

    while (_textEditingController.text[pointer] == '#') {
      countOfHashTag++;
      pointer++;
    }

    if (countOfHashTag < 7) {
      // Increase hashses
      _textEditingController.text =
          '${_textEditingController.text.substring(0, pointer)}#${_textEditingController.text.substring(pointer)}';
      // Move cursor forward
      _textEditingController.selection =
          TextSelection.fromPosition(TextPosition(offset: cursorOffset + 1));
    } else {
      // Remove all the hashses
      _textEditingController.text =
          '${_textEditingController.text.substring(0, startOfHash)}${_textEditingController.text.substring(pointer)}';
      // Move cursor backward
      int stepsToGoBack = countOfHashTag;
      if (stepsToGoBack > cursorOffsetFromStartOfLine) {
        stepsToGoBack = cursorOffsetFromStartOfLine - 1;
      }
      _textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: cursorOffset - stepsToGoBack));
    }
  }

  void _toggleBold() {}

  void _toggleItalic() {}

  double _getWidthOfText() {
    String longestLine = '';
    _textEditingController.text.split("\n").forEach((element) {
      if (element.length > longestLine.length) {
        longestLine = element;
      }
    });

    TextPainter textPainter = TextPainter();
    textPainter.text = TextSpan(text: longestLine, style: textStyle);
    textPainter.textDirection = TextDirection.ltr;
    textPainter.layout();

    return textPainter.width + 5; // Some extra padding
  }

  @override
  Widget build(BuildContext context) {
    final selectedNote =
        context.select<UserDataProvider, File?>((value) => value.selectedNote);
    if (selectedNote != _selectedNote && selectedNote != null) {
      selectedNote.readAsString().then((value) {
        _textEditingController.text = value;
        _editorScrollController.jumpTo(0);
        setState(() {
          _linesCount = '\n'.allMatches(value).length + 1;
        });
      });
      _selectedNote = selectedNote;
    }
    final currentTheme = context.watch<ThemeProvider>().currentTheme;

    final Color iconColor = currentTheme['onPrimaryBackground'];
    const double iconSize = 20;
    const double iconSplashRadius = 20;

    var tools = [
      {'icon': Icons.visibility, 'onPressed': () {}},
      {'icon': Icons.format_size, 'onPressed': _toggleHeading},
      {'icon': Icons.format_bold, 'onPressed': () {}},
      {'icon': Icons.format_italic, 'onPressed': () {}},
      {'icon': Icons.format_underline, 'onPressed': () {}},
      {'icon': Icons.format_quote, 'onPressed': () {}},
      {'icon': Icons.code, 'onPressed': () {}},
      {'icon': Icons.format_list_bulleted, 'onPressed': () {}},
      {'icon': Icons.format_list_numbered, 'onPressed': () {}},
      {'icon': Icons.checklist, 'onPressed': () {}},
      {'icon': Icons.link, 'onPressed': () {}},
      {'icon': Icons.functions, 'onPressed': () {}},
      {'icon': Icons.image, 'onPressed': () {}},
    ];

    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: currentTheme['border'] as Color,
                ),
              ),
            ),
            child: TextFieldTapRegion(
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: tools
                        .map<Widget>((tool) => IconButton(
                              splashRadius: iconSplashRadius,
                              icon: Icon(tool['icon'] as IconData,
                                  color: iconColor, size: iconSize),
                              onPressed: tool['onPressed'] as void Function(),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                ResizeableBox(
                  initialWidth: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            width: 30,
                            height: MediaQuery.of(context).size.height,
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context)
                                  .copyWith(scrollbars: false),
                              child: SingleChildScrollView(
                                controller: _lineNumberScrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var i = 0; i < _linesCount; i++)
                                      Text(
                                        style: TextStyle(
                                          color: currentTheme[
                                              'onPrimaryBackground'],
                                        ).merge(textStyle),
                                        (i + 1).toString(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (p0, p1) {
                              final double textFieldWidth =
                                  max(p1.maxWidth, _getWidthOfText());
                              return Scrollbar(
                                controller: _verticalScrollController,
                                child: SingleChildScrollView(
                                  controller: _verticalScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints.expand(
                                        width: textFieldWidth),
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.only(top: 4, bottom: 4),
                                      ),
                                      scrollController: _editorScrollController,
                                      style: textStyle,
                                      maxLines: 999,
                                      controller: _textEditingController,
                                      keyboardType: TextInputType.multiline,
                                      onChanged: (value) {
                                        if (selectedNote != null) {
                                          setState(() {
                                            _linesCount =
                                                '\n'.allMatches(value).length +
                                                    1;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: MarkdownWidget(
                  data: _textEditingController.text,
                  config: MarkdownConfig.darkConfig,
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
