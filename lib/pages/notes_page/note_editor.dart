import 'package:provider/provider.dart';
import 'package:flint/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late File note;
  late TextEditingController controller;
  late Future<String> dataFromFile;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    openSelectedFile();
    Provider.of<UserDataProvider>(context, listen: false).addListener(() {});
  }

  void openSelectedFile() {
    final path =
        Provider.of<UserDataProvider>(context, listen: false).selectedNote;
    note = File(path!);
    note.open(mode: FileMode.append);
    dataFromFile = note.readAsString();

    dataFromFile.then((value) {
      controller.text = value;
    });
    print('Opened new file');
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      context.select<UserDataProvider, String>((value) => value.selectedNote!);
      openSelectedFile();
      return FutureBuilder(
        future: dataFromFile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return TextField(
              controller: controller,
              onChanged: (text) {
                note.writeAsString(text);
              },
            );
          } else {
            return Container();
          }
        },
      );
    });
  }
}
