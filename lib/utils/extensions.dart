// Extensions for the libraries I'm using in this project to make my life easier
import 'package:flutter/material.dart';
import 'dart:io';

extension Improvements on FileSystemEntity {
  /// Get new path used for renaming
  String getNewPath(String newName) {
    final separated = path.split(Platform.pathSeparator);
    separated[separated.length - 1] = newName;
    final newPath = separated.join(Platform.pathSeparator);
    return newPath;
  }

  /// Name of this [FileSystemEntity]
  String get name {
    return path.split(Platform.pathSeparator).last;
  }

  /// Name of this [FileSystemEntity] without extension
  String get nameWithoutExtension {
    final nameSplit = name.split(".");
    nameSplit.removeLast();
    return nameSplit.join(".");
  }
}

extension RenameFile on File {
  /// Same as [renameSync] but without providing full path
  File renameSyncName(String newName) {
    return renameSync(getNewPath(newName));
  }
}

extension RenameDirectory on Directory {
  /// Same as [renameSync] but without providing full path
  Directory renameSyncName(String newName) {
    return renameSync(getNewPath(newName));
  }
}
