import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<Directory> getNotesDirectory() async {
  final documentDir = await getApplicationDocumentsDirectory();
  return Directory('${documentDir.path}${Platform.pathSeparator}notes');
}

Future<List<FileSystemEntity>> getNotes() async {
  final notesDir = await getNotesDirectory();
  notesDir.create();
  return notesDir.listSync();
}

Future addNewNote(String name) async {
  final notesDir = await getNotesDirectory();
  final newNote = File('${notesDir.path}${Platform.pathSeparator}${name}');
  await newNote.create(recursive: true);
}
