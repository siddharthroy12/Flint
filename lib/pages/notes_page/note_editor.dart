import 'dart:io';
import 'dart:ui';
import 'package:flint/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flint/providers/user_data_provider.dart';
import 'package:flutter/material.dart';

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
  late TextEditingController textEditingController;
  late ScrollController editorScrollController;
  late ScrollController lineNumberScrollController;
  File? selectedNote;

  int linesCount = 0;
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    editorScrollController = ScrollController();
    lineNumberScrollController = ScrollController();
    editorScrollController.addListener(() {
      lineNumberScrollController.jumpTo(editorScrollController.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final selectedNote = context
          .select<UserDataProvider, File?>((value) => value.selectedNote);
      if (selectedNote != this.selectedNote && selectedNote != null) {
        selectedNote.readAsString().then((value) {
          textEditingController.text = value;
          editorScrollController.jumpTo(0);
          setState(() {
            linesCount = '\n'.allMatches(value).length + 1;
          });
        });
        this.selectedNote = selectedNote;
      }
      final currentTheme = context.watch<ThemeProvider>().currentTheme;
      return Padding(
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
                    controller: lineNumberScrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < linesCount; i++)
                          Text(
                            style: TextStyle(
                                    color: currentTheme['onPrimaryBackground'])
                                .merge(textStyle),
                            (i + 1).toString(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.only(top: 4, bottom: 4),
                ),
                scrollController: editorScrollController,
                style: textStyle,
                maxLines: 999,
                controller: textEditingController,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  if (selectedNote != null) {
                    selectedNote.writeAsString(value);
                    setState(() {
                      linesCount = '\n'.allMatches(value).length + 1;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
