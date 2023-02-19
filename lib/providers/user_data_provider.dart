import 'package:flutter/material.dart';
import 'dart:io';

// Global state for managing user's notes and settings
class UserDataProvider extends ChangeNotifier {
  final List<File> _openedNotes = [];
  var _selectedNoteIndex = 0;

  void openNote(String path) {
    if (_openedNotes.indexWhere((file) => file.path == path) == -1) {
      File file = File(path);
      file.open(mode: FileMode.append);
      _openedNotes.add(file);
    }
    notifyListeners();
  }

  List<File> get openedNotes {
    return _openedNotes;
  }

  File? get selectedNote {
    if (_openedNotes.isNotEmpty) {
      return _openedNotes[_selectedNoteIndex];
    } else {
      return null;
    }
  }

  set selectedNoteIndex(int index) {
    _selectedNoteIndex = index;
    notifyListeners();
  }

  int get selectedNoteIndex {
    return _selectedNoteIndex;
  }

  void closeNote(int index) {
    _openedNotes.removeAt(index);
    if (index <= selectedNoteIndex) {
      _selectedNoteIndex--;
    }

    if (_selectedNoteIndex < 0) {
      _selectedNoteIndex = 0;
    }
    notifyListeners();
  }
}
