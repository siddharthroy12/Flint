// Extensions for the libraries I'm using in this project to make my life easier
import 'package:flutter/material.dart';
import 'dart:io';

// Extension for easily converting Color to hex and hex to Color
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}'
      '${alpha.toRadixString(16).padLeft(2, '0')}';
}

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
