import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  var notes = [];
  var openedNotes = [];
  String? selectedNote = '';
  int? selectedIndex = null;

  void openNote(String path) {
    if (!openedNotes.contains(path)) {
      openedNotes.add(path);
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
