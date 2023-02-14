import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flint/providers/theme_provider.dart';
import 'package:flint/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/resizedable_sidebar.dart';
import 'notes_actions.dart';
import 'package:flint/lib/filesystem.dart';

class NotesSidebar extends StatefulWidget {
  const NotesSidebar({super.key});

  @override
  State<NotesSidebar> createState() => _NotesSidebarState();
}

class _NotesSidebarState extends State<NotesSidebar> {
  late Future<List<FileSystemEntity>> _notes;
  @override
  void initState() {
    super.initState();
    _notes = getNotes();
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return ResizeableSidebar(
      initialWidth: 200,
      child: Column(
        children: [
          const NotesActions(),
          Consumer<UserDataProvider>(
            builder: (context, userData, child) => Expanded(
              child: FutureBuilder(
                future: _notes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: TextButton(
                          onPressed: () {
                            userData.openNote(snapshot.data?[index].path ?? '');
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.resolveWith(
                              (states) => currentTheme['highlightBackground'],
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              snapshot.data?[index].path
                                      .split(Platform.pathSeparator)
                                      .last ??
                                  '',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: currentTheme['onPrimaryBackground'],
                              ),
                            ),
                          ),
                        ),
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
