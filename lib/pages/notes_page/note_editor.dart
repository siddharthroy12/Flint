import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:flint/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flint/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/resizeable_box.dart';
import 'package:markdown_widget/markdown_widget.dart';

// The whole package of stuffs for rich markdown editing experience
class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _editorScrollController = ScrollController();
  ResizeController resizeController = ResizeController();
  // Show the live markdown preview
  bool showPreview = false;
  // The file we are saving in
  File? _selectedNote;
  double maxAvailableWidth = 0;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      if (_selectedNote != null) {
        // Save editor's text to the file whenever it changes
        _selectedNote?.writeAsString(_textEditingController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedNote =
        context.select<UserDataProvider, File?>((value) => value.selectedNote);
    // Whenver the selected note change update the text inside editor
    // and jump to the top of the text
    if (selectedNote != _selectedNote && selectedNote != null) {
      selectedNote.readAsString().then((value) {
        _textEditingController.text = value;
        _editorScrollController.jumpTo(0);
      });
      _selectedNote = selectedNote;
    }

    return LayoutBuilder(builder: (p0, p1) {
      // Resize the resizeable preview if this editor's width change
      if (p1.maxWidth != maxAvailableWidth) {
        double difference = p1.maxWidth - maxAvailableWidth;
        resizeController.width = resizeController.width + difference;
        maxAvailableWidth = p1.maxWidth;
      }
      return Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Tools(
              textEditingController: _textEditingController,
              onToggleVisibility: () {
                setState(() {
                  showPreview = !showPreview;
                });
              },
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: MarkdownCodeEditor(
                      editorScrollController: _editorScrollController,
                      textEditingController: _textEditingController,
                    ),
                  ),
                  showPreview
                      ? ResizeableBox(
                          resizeController: resizeController,
                          initialWidth: 300,
                          minimumWidth: 300,
                          direction: Direction.left,
                          child: MarkdownWidget(
                            data: _textEditingController.text,
                            config: MarkdownConfig.darkConfig,
                          ))
                      : Container()
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// The cool markdown editor
class MarkdownCodeEditor extends StatefulWidget {
  const MarkdownCodeEditor({
    super.key,
    required this.textEditingController,
    required this.editorScrollController,
  });

  final TextEditingController textEditingController;
  final ScrollController editorScrollController;
  @override
  State<MarkdownCodeEditor> createState() => _MarkdownCodeEditorState();
}

class _MarkdownCodeEditorState extends State<MarkdownCodeEditor> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: TextField(
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.only(top: 4, bottom: 4),
        ),
        scrollController: widget.editorScrollController,
        style: const TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: 14,
          fontWeight: FontWeight.w300,
          fontVariations: [FontVariation('wght', 300.0)],
        ),
        maxLines: 999,
        controller: widget.textEditingController,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}

// The tools to insert markdown elements inside text editor
class Tools extends StatefulWidget {
  const Tools(
      {super.key,
      required this.textEditingController,
      required this.onToggleVisibility});

  final TextEditingController textEditingController;
  final void Function() onToggleVisibility;

  @override
  State<Tools> createState() => _ToolsState();
}

class _ToolsState extends State<Tools> {
  final double iconSize = 18;
  final double iconSplashRadius = 20;
  late List<Map<String, Object>> tools;

  // Get the starting positing of the line on which the is cursor is located
  int _getLineStartAtCursor() {
    int cursorPosition = widget.textEditingController.selection.base.offset;
    int startOfCurrentLine = cursorPosition;

    // Calculate the postion of the starting of the line at which the cursor at
    if (widget.textEditingController.text.isNotEmpty) {
      int pointer = cursorPosition;

      // If the pointer at the end of the text then move the
      // pointer back otherwise it'll throw range error
      // because offset is outside the range
      if (pointer == widget.textEditingController.text.length) {
        pointer--;
      }

      // If pointer is on a new line or at the end of text
      // then move it backword so that we can get previous new line
      if (pointer != 0) {
        if (widget.textEditingController.text[pointer] == '\n' &&
            pointer != widget.textEditingController.text.length - 1) {
          pointer--;
        }
      }

      // Get the previous new line
      while (
          pointer != 0 && widget.textEditingController.text[pointer] != '\n') {
        pointer--;
      }

      // If pointer at start then move forward
      // Idk why I'm doing this
      if (pointer != 0) {
        pointer++;
      }
      // And we got the start of the current line
      startOfCurrentLine = pointer;
    }

    return startOfCurrentLine;
  }

  // Get the ending positing of the line on which the is cursor is located
  int _getLineEndAtCursor() {
    return 0;
  }

  // Toggle heading numbers eg. (h1, h2, h3, ...)
  void _toggleHeading() {
    int cursorPosition = widget.textEditingController.selection.base.offset;
    int startOfCurrentLine = _getLineStartAtCursor();

    // Calculate the size count of the #
    int count = 0;
    int endOfHash = 0;
    int cursorOffset = 1;

    // Count the hash and get the end of the hash
    if (widget.textEditingController.text.isNotEmpty) {
      int pointer = startOfCurrentLine;
      while (pointer != widget.textEditingController.text.length &&
          widget.textEditingController.text[pointer] == "#") {
        count++;
        pointer++;
      }
      endOfHash = pointer;
    }

    // Check if it has a space after the hash
    bool hasSpaceAfterHash =
        (endOfHash != widget.textEditingController.text.length &&
            widget.textEditingController.text[endOfHash] == ' ');

    // If count is less than 6 then increase it otherwise make it 0
    if (count > 6) {
      // To remove the space after hash after removing all hashes
      if (hasSpaceAfterHash) {
        endOfHash++;
        count++;
      }
      int cursorDistanceFromStartOfLine = (cursorPosition - startOfCurrentLine);
      // Move the cursor back but don't go to the previous line
      cursorOffset = -min(count, cursorDistanceFromStartOfLine);
      count = 0;
    } else {
      count++;
      if (!hasSpaceAfterHash) {
        // If we are adding space then cursor will move one more step forward
        cursorOffset++;
      }
    }

    // text before the start of the line
    var leftSide =
        widget.textEditingController.text.substring(0, startOfCurrentLine);

    var hashes = '#' * (count);

    // text after the end of the hashes
    var rightSide = widget.textEditingController.text.substring(endOfHash);

    // Put both side with hashes
    widget.textEditingController.text =
        '$leftSide$hashes${hasSpaceAfterHash ? "" : ' '}$rightSide';

    // Move cursor forward
    widget.textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition + cursorOffset));
  }

  void _toggleWrap(String wrap) {
    int selectionStart = widget.textEditingController.selection.baseOffset;
    int baseOffset = selectionStart;
    int selectionEnd = widget.textEditingController.selection.extentOffset;
    int extendOffset = selectionEnd;

    String selectedText = widget.textEditingController.text
        .substring(selectionStart, selectionEnd);

    int sizeOfSelectedTextBeforeChange = selectedText.length;
    if (selectedText.startsWith(wrap) || selectedText.endsWith(wrap)) {
      if (selectedText.startsWith(wrap)) {
        selectedText = selectedText.substring(wrap.length);
        extendOffset -= wrap.length;
      }
      if (selectedText.endsWith(wrap)) {
        selectedText =
            selectedText.substring(0, selectedText.length - wrap.length);
        extendOffset -= wrap.length;
      }
    } else {
      String pattern = wrap.characters.map((e) => "\\$e").join();
      selectedText = selectedText.replaceAll(RegExp(pattern), "");
      selectedText = '$wrap$selectedText$wrap';

      extendOffset += selectedText.length - sizeOfSelectedTextBeforeChange;
    }

    // text before the start of the line
    var leftSide =
        widget.textEditingController.text.substring(0, selectionStart);

    // text after the end of the hashes
    var rightSide = widget.textEditingController.text.substring(selectionEnd);

    // Put both side with hashes
    widget.textEditingController.text = '$leftSide$selectedText$rightSide';

    widget.textEditingController.selection =
        TextSelection(baseOffset: baseOffset, extentOffset: extendOffset);
  }

  void _toggleBlockQuote() {
    int cursorPosition = widget.textEditingController.selection.base.offset;
    int startOfCurrentLine = _getLineStartAtCursor();

    if (widget.textEditingController.text.isNotEmpty) {
      if (widget.textEditingController.text[startOfCurrentLine] == '>') {}
    }
  }

  @override
  void initState() {
    super.initState();
    tools = [
      {'icon': Icons.visibility, 'onPressed': widget.onToggleVisibility},
      {'icon': Icons.text_fields, 'onPressed': _toggleHeading},
      {
        'icon': Icons.format_bold,
        'onPressed': () {
          _toggleWrap("**");
        }
      },
      {
        'icon': Icons.format_italic,
        'onPressed': () {
          _toggleWrap("_");
        }
      },
      {
        'icon': Icons.format_strikethrough,
        'onPressed': () {
          _toggleWrap("~~");
        }
      },
      {'icon': Icons.format_quote, 'onPressed': () {}},
      {'icon': Icons.code, 'onPressed': () {}},
      {'icon': Icons.format_list_bulleted, 'onPressed': () {}},
      {'icon': Icons.format_list_numbered, 'onPressed': () {}},
      {'icon': Icons.checklist, 'onPressed': () {}},
      {'icon': Icons.link, 'onPressed': () {}},
      {'icon': Icons.functions, 'onPressed': () {}},
      {'icon': Icons.image, 'onPressed': () {}},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.select<ThemeProvider, Map>(
        (themeProvider) => themeProvider.currentTheme);

    return Container(
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
            padding: const EdgeInsets.all(3),
            child: Row(
              children: tools
                  .map<Widget>(
                    (tool) => IconButton(
                      splashRadius: iconSplashRadius,
                      icon: Icon(tool['icon'] as IconData,
                          color: currentTheme['onPrimaryBackground'],
                          size: iconSize),
                      onPressed: tool['onPressed'] as void Function(),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
