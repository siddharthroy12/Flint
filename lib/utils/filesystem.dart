import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Get the directory where our data for the app will be stored
Future<Directory> getAppDataDirectory() async {
  final documentDir = await getApplicationDocumentsDirectory();
  final appDataDir =
      Directory('${documentDir.path}${Platform.pathSeparator}flint');
  appDataDir.create(recursive: true);
  return appDataDir;
}

// TODO: Improve performance of these two
String getFileNameFromPath(String path) {
  return path.split("/").last.split(".").first;
}

String getDirectoryNameFromPath(String path) {
  return path.split("/").last;
}
