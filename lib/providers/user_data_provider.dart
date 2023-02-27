import 'package:flutter/material.dart';
import 'dart:io';
import '../utils/filesystem.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

// Tags can be assigned to notes
class Tag extends ChangeNotifier {
  Tag({required String title, required Color color}) {
    _title = title;
    _color = color;
  }

  late String _title;
  late Color _color;

  String get title {
    return _title;
  }

  Color get color {
    return _color;
  }

  set title(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  set color(Color newColor) {
    _color = newColor;
    notifyListeners();
  }
}

class Note extends ChangeNotifier {
  Note({required this.name, required this.content});
  String name;
  String content;
}

class Notebook extends ChangeNotifier {
  Notebook({required this.name}) {
    // Load notes
  }

  String name;

  Map<String, Note> notes = {};

  addNote(String name) {
    notifyListeners();
  }

  deleteNote(String name) {
    notifyListeners();
  }

  moveNote(String name, Notebook notebook) {
    notifyListeners();
  }
}

// Global state for managing user's notes and settings
class UserDataProvider extends ChangeNotifier {
  Map<String, Tag> tags = {};
  Map<String, Notebook> notebooks = {};

  Future<Directory> _getNotebooksDirectory() async {
    final appDataDirectory = await getAppDataDirectory();
    final notebooksDirectory =
        Directory('${appDataDirectory.path}${Platform.pathSeparator}notebooks');
    notebooksDirectory.create(recursive: true);

    return notebooksDirectory;
  }

  Future _loadDataFromFilesystem() async {
    final notebooksDir = await _getNotebooksDirectory();
    final filesAndFolders = notebooksDir.listSync();

    for (var fileOrFolder in filesAndFolders) {
      if (fileOrFolder is Directory) {
        final folder = fileOrFolder;
        addNotebook(getDirectoryNameFromPath(folder.path));
      }
    }
  }

  UserDataProvider() {
    // Loads notebooks and notes
    _loadDataFromFilesystem();
  }

  // TODO: Add duplicate name check in UI
  addNotebook(String name) async {
    Notebook newNotebook = Notebook(name: name);
    final notebooksDir = await _getNotebooksDirectory();
    final newNotebookDirectory =
        Directory('${notebooksDir.path}${Platform.pathSeparator}$name');
    newNotebookDirectory.create(recursive: true);
    newNotebook.addListener(() {
      notifyListeners();
    });

    notebooks[name] = newNotebook;
    notifyListeners();
  }

  void deleteNotebook(String name) {
    notifyListeners();
  }

  void addTag(String name) {
    notifyListeners();
  }

  void deleteTag(String name) {
    notifyListeners();
  }
}
