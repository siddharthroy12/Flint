import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flint/providers/theme_provider.dart';
import 'package:flint/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import '../../widgets/resizeable_box.dart';
import 'notes_actions.dart';
import 'package:flint/lib/filesystem.dart';

// The treeview on notes and action buttons
class NotesSidebar extends StatefulWidget {
  const NotesSidebar({super.key});

  @override
  State<NotesSidebar> createState() => _NotesSidebarState();
}

class _NotesSidebarState extends State<NotesSidebar> {
  // The Directory where notes are stored
  late Future<List<FileSystemEntity>> _notes;
  @override
  void initState() {
    super.initState();
    _notes = getNotes();
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return ResizeableBox(
      initialWidth: 200,
      child: Column(
        children: [
          const NotesActions(),
          Consumer<UserDataProvider>(
            builder: (context, userData, child) => Expanded(
              child: FutureBuilder(
                future: _notes,
                builder: (context, snapshot) {
                  // Wait for the list of files to load
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Documents',
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) => TextButton(
                                onPressed: () {
                                  userData.openNote(
                                      snapshot.data?[index].path ?? '');
                                },
                                style: ButtonStyle(
                                  overlayColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) =>
                                        currentTheme['highlightBackground'],
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    // Only show the filename
                                    // and without the extension
                                    snapshot.data?[index].path
                                            .split(Platform.pathSeparator)
                                            .last
                                            .split(".")
                                            .first ??
                                        '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color:
                                          currentTheme['onPrimaryBackground'],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
