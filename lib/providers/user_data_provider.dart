import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// This is an abstract class for all the data that will be stored in file system
abstract class PersistedData {
  PersistedData({required this.key, required this.name});
  // Key will be an unique id for each instance of this class to
  // make relationships and be able to uniquely indentify each instance
  String key;
  String name;

  // Every change inside the extended class should be made
  // by calling this function and making changes inside the
  // callback
  void change(Function changes) {
    changes();
    save();
  }

  // This function defines how the data is going to be saved inside filesystem
  save();
}

// Tags can be assigned to notes
class Tag extends PersistedData {
  Tag({required this.title, required this.color, required super.key})
      : super(name: 'Tag');
  String title;
  Color color;

  @override
  save() {}
}

class Note {
  Note({required this.name, required this.content});
  String name;
  String content;
}

class Notebook {
  Notebook({required this.name});
  String name;
}

// Global state for managing user's notes and settings
class UserDataProvider extends ChangeNotifier {
  List<Tag> tags = [];

  void addTag() {
    notifyListeners();
  }

  void getTagById() {}
}
