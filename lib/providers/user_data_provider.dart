import 'package:flutter/material.dart';
import 'dart:io';

class UserDataProvider extends ChangeNotifier {
  var notes = [];
  var openedNotes = [];
  String? selectedNote;
  File? selectedNoteFile;
  int? selectedIndex;

  void openNote(String path) {
    if (!openedNotes.contains(path)) {
      openedNotes.add(path);
    }
    if (openedNotes.length == 1) {
      selectedNote = path;
    }
    notifyListeners();
  }

  void selectNote(String note) {
    selectedNote = note;
    selectedIndex = openedNotes.indexOf(note);
    notifyListeners();
  }

  void closeNote(String path) {
    openedNotes.removeWhere((element) => element['name'] == path);
    notifyListeners();
  }
}
