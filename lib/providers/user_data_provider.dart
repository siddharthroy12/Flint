// This providers handles notebooks, tags, notes and settings

import 'package:flint/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class NotFound implements Exception {
  String cause;
  NotFound(this.cause);
}

class AlreadyExists implements Exception {
  String cause;
  AlreadyExists(this.cause);
}

/// Handler for a single Tag
///
/// Tags are assigned to notes
class Tag extends ChangeNotifier {
  Tag({required String name, required Color color}) {
    _name = name;
    _color = color;
    _tagsFileContent[name] = {"color": color.toHex()};
    _updateTagFile();
  }

  /// JSON file where tags are stored
  /// All tags share the same json file
  static File? _tagsFile;

  /// Content of the JSON file as a dart object
  ///
  /// Call [_updateTagFile] after editing this object
  /// to update it in the file
  ///
  /// The example structure this JSON object
  /// ```json
  /// {
  ///   "tag_name": {
  ///     "color": "hex_value",
  ///   }
  /// }
  /// ```
  static Map<String, Map<String, String>> _tagsFileContent = {};

  /// Write the [_tagsFileContent] to the file;
  _updateTagFile() async {
    await Tag._tagsFile!.writeAsString(jsonEncode(_tagsFileContent));
  }

  late String _name;

  /// Name of the tag
  String get name {
    return _name;
  }

  set name(String newName) {
    _tagsFileContent.remove(_name);
    _name = newName;
    _tagsFileContent[_name] = {"color": color.toHex()};
    _updateTagFile();
    notifyListeners();
  }

  late Color _color;

  /// Color of the tag
  Color get color {
    return _color;
  }

  set color(Color newColor) {
    _color = newColor;
    _tagsFileContent[_name] = {"color": color.toHex()};
    _updateTagFile();
    notifyListeners();
  }

  /// Delete the tag inside the file
  delete() async {
    _tagsFileContent.remove(_name);
    await _updateTagFile();
    notifyListeners();
  }
}

/// Handler a Note
class Note extends ChangeNotifier {
  Note(this._file) {
    _file.readAsString().then((value) {
      _content = value;
    });
  }

  /// File in which the note is stored
  File _file;

  /// Content of the file
  String _content = '';

  String get name {
    return _file.nameWithoutExtension;
  }

  // Name of the note
  set name(String newName) {
    _file = _file.renameSyncName(newName);
    notifyListeners();
  }

  /// Content of the note
  String get content {
    return _content;
  }

  set content(String text) {
    _content = text;
    _file.writeAsString(text);
    notifyListeners();
  }
}

/// Handler for a notebook
class Notebook extends ChangeNotifier {
  Notebook(this._dir) {
    _loadNotes();
  }

  /// The directory of the notebook
  Directory _dir;

  /// Load notes of this notebook
  void _loadNotes() async {
    final files = (await _dir.list().toList());
    files.removeWhere((fileSystemEntity) => fileSystemEntity is Directory);

    for (var file in files) {
      _addNote(Note(file as File));
    }
  }

  // Tags assigned to this notebook
  List<String> tags = [];

  /// Name of the notebook
  String get name {
    return _dir.name;
  }

  // Change name of the notebook
  // This also renames the directory of the notebook
  set name(String newName) {
    _dir = _dir.renameSyncName(newName);
    // Reloads the notes
    _loadNotes();
    notifyListeners();
  }

  /// Collection of notes inside this notebook
  List<Note> notes = [];

  /// Adds a [Note] inside this notebook with the [name]
  ///
  /// Throws [AlreadyExists] exception if the note already exists
  addNote(String name) {
    name = name.trim();
    if (notes.indexWhere((note) => note.name == name) != -1) {
      throw AlreadyExists('Note with $name already exists');
    }
    final noteFile = File('${_dir.path}${Platform.pathSeparator}$name.md');
    noteFile.create(recursive: true);
    notes.add(Note(noteFile));
    _addNote(Note(noteFile));
    notifyListeners();
  }

  /// Whether a note exists with the name [name]
  bool noteExists(String name) {
    return notes.indexWhere((note) => note.name == name) != -1;
  }

  /// Add a note to the list and attach a listener to it
  _addNote(Note note) {
    note.addListener(() {
      notifyListeners();
    });

    notes.add(note);
  }

  /// Deletes a [Note] inside this notebook of the [name]
  ///
  /// Throws [NotFound] exception if the note is not found
  deleteNote(String name) async {
    try {
      Note note = notes.firstWhere((note) => note.name == name);

      // Delete the file first
      await note._file.delete();

      // then remove the from the list
      notes.removeWhere((note) => note.name == name);
    } on StateError {
      throw NotFound('Note $name is not found');
    }
    notifyListeners();
  }

  /// Moves a [Note] of [name] form this [Notebook] to the [notebook]
  ///
  /// Throws [NotFound] if the note or notebook is not found
  ///
  /// Throws [AlreadyExists] exception if any note in the
  /// target [notebook] has the same name
  moveNote(String name, Notebook notebook) async {
    try {
      Note note = notes.firstWhere((note) => note.name == name);
      final pathSplitted = note._file.path.split(Platform.pathSeparator);
      pathSplitted[pathSplitted.length - 2] = notebook.name;
      final newPath = pathSplitted.join(Platform.pathSeparator);
      await note._file.rename(newPath);
      notebook._addNote(Note(File(newPath)));
    } on StateError {
      throw NotFound('Note $name is not found');
    }

    // then remove the from the list
    notes.removeWhere((note) => note.name == name);
    notifyListeners();
  }
}

/// Global state for managing user's notes and settings
class UserDataProvider extends ChangeNotifier {
  UserDataProvider() {
    // Loads notebooks and notes
    _loadDataFromFilesystem();
  }

  List<Notebook> notebooks = [];
  List<Tag> tags = [];

  /// Get the directory where our data for the app will be stored
  Future<Directory> _getAppDataDirectory() async {
    final documentDir = await getApplicationDocumentsDirectory();
    final appDataDir =
        Directory('${documentDir.path}${Platform.pathSeparator}flint');
    appDataDir.create(recursive: true);
    return appDataDir;
  }

  /// Get the directory where notebooks are stored
  Future<Directory> _getNotebooksDirectory() async {
    final appDataDirectory = await _getAppDataDirectory();
    final notebooksDirectory =
        Directory('${appDataDirectory.path}${Platform.pathSeparator}notebooks');
    notebooksDirectory.create(recursive: true);

    return notebooksDirectory;
  }

  /// Load notebooks and tags from the filesystem
  Future _loadDataFromFilesystem() async {
    final appDataDir = await _getAppDataDirectory();
    final notebooksDir = await _getNotebooksDirectory();
    final filesAndFoldersInNotebooksDir = notebooksDir.listSync();

    // Load notebook
    for (var fileOrFolder in filesAndFoldersInNotebooksDir) {
      if (fileOrFolder is Directory) {
        final folder = fileOrFolder;
        _addNotebook(Notebook(folder));
        addNotebook(folder.path.split(Platform.pathSeparator).last);
      }
    }

    Tag._tagsFile =
        File('${appDataDir.path}${Platform.pathSeparator}tags.json');
    await Tag._tagsFile!.open(mode: FileMode.append);

    var tagsFileContent = await Tag._tagsFile!.readAsString();
    if (tagsFileContent.isEmpty) {
      tagsFileContent = '{}';
      await Tag._tagsFile!.writeAsString(tagsFileContent);
    }
    Tag._tagsFileContent = jsonDecode(tagsFileContent);

    Tag._tagsFileContent.forEach((key, value) {
      addTag(key, colorFromHex(value['color']!)!);
    });
  }

  /// Create a new [Notebook] and add it to the list
  addNotebook(String name) async {
    name = name.trim();
    final notebooksDir = await _getNotebooksDirectory();
    final notebookDir =
        Directory('${notebooksDir.path}${Platform.pathSeparator}$name');
    // Create the notebook directory if doesn't exists
    notebookDir.create(recursive: true);

    _addNotebook(Notebook(notebookDir));
  }

  /// Whether a notebook with the name [name] exists or not
  bool notebookExists(String name) {
    return notebooks.indexWhere((notebook) => notebook.name == name) != -1;
  }

  /// Add [notebook] to the list and attach a listner to it
  _addNotebook(Notebook notebook) {
    notebook.addListener(() {
      notifyListeners();
    });
    notifyListeners();
  }

  /// Deletes a [Notebook]
  ///
  /// Throws [NotFound] exception if the note is not found
  void deleteNotebook(String name) async {
    try {
      Notebook notebook =
          notebooks.firstWhere((notebook) => notebook.name == name);
      // Delete the file first
      await notebook._dir.delete(recursive: true);
    } on StateError {
      throw NotFound('Notebook $name is not found');
    }

    // then remove the from the list
    notebooks.removeWhere((note) => note.name == name);
    notifyListeners();
  }

  /// Create a new [Tag] and add it to the list
  void addTag(String name, Color color) {
    Tag tag = Tag(name: name, color: color);
    _addTag(tag);
    notifyListeners();
  }

  // Add [tag] to the list and attach a listener to it
  void _addTag(Tag tag) {
    tag.addListener(() {
      notifyListeners();
    });
    tags.add(tag);
    notifyListeners();
  }

  /// Deletes a [Tag]
  ///
  /// Throws [NotFound] exception if the tag is not found
  void deleteTag(String name) {
    try {
      Tag tag = tags.firstWhere((tag) => tag.name == name);
      // Delete the file first
      tag.delete();
    } on StateError {
      throw NotFound('Tag $name is not found');
    }

    // then remove the from the list
    tags.removeWhere((tag) => tag.name == name);
    notifyListeners();
  }
}
