import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  var notes = [];
  var openedNotes = [];

  void addNote() {
    notes.add({'name': 'Unitled', 'content': ''});
    notifyListeners();
  }

  void openNote(String name) {
    // Only those who exist can by opened
    if (notes.firstWhere((element) => element['name'] == name) != -1) {
      openedNotes.add(name);
    }
    notifyListeners();
  }

  void closeNote(String name) {
    openedNotes.removeWhere((element) => element['name'] == name);
    notifyListeners();
  }
}
