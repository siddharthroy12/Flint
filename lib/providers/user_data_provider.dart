import 'package:flutter/material.dart';
import 'dart:io';
import '../utils/filesystem.dart';

Future<Directory> _getNotebooksDirectory() async {
  final appDataDirectory = await getAppDataDirectory();
  final notebooksDirectory =
      Directory('${appDataDirectory.path}${Platform.pathSeparator}notebooks');
  notebooksDirectory.create(recursive: true);

  return notebooksDirectory;
}

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
  Notebook({required String name}) {
    // Load notes
    _name = name;
    _loadDirectory();
  }

  late String _name;

  late Directory _dir;

  void _loadDirectory() async {
    final notebooksDir = await _getNotebooksDirectory();
    final notebookDirectory =
        Directory('${notebooksDir.path}${Platform.pathSeparator}$_name');
    notebookDirectory.create(recursive: true);

    _dir = notebookDirectory;
  }

  set name(String newName) {
    final separated = _dir.path.split(Platform.pathSeparator);
    separated[separated.length - 1] = newName;
    final newPath = separated.join(Platform.pathSeparator);
    _dir = _dir.renameSync(newPath);
    _name = newName;
    notifyListeners();
  }

  String get name {
    return _name;
  }

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
    name = name.trim();
    Notebook newNotebook = Notebook(name: name);

    newNotebook.addListener(() {
      notifyListeners();
    });

    notebooks[name] = newNotebook;
    notifyListeners();
  }

  void renameNotebook(String oldName, String newName) {
    final notebook = notebooks[oldName]!;
    notebook.name = newName;
    notebooks.remove(oldName);
    notebooks[newName] = notebook;
    notifyListeners();
  }

  void deleteNotebook(String name) {
    notebooks[name]?._dir.delete();
    notebooks.remove(name);
    notifyListeners();
  }

  void addTag(String name) {
    notifyListeners();
  }

  void deleteTag(String name) {
    notifyListeners();
  }
}
