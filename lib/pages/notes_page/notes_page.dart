import 'package:flint/pages/notes_page/note_editor.dart';
import 'package:flutter/material.dart';
import '../../layout.dart';
import 'notes_sidebar.dart';
import 'package:provider/provider.dart';
import 'package:flint/providers/theme_provider.dart';
import 'package:flint/providers/user_data_provider.dart';
import 'notes_tabs.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return Layout(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NotesSidebar(),
          Expanded(
            child: Consumer<UserDataProvider>(
              builder: (context, userData, child) {
                if (userData.openedNotes.isNotEmpty) {
                  return Column(
                    children: [
                      const NotesTab(),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: currentTheme['secondaryBackground'],
                          ),
                          child: const NoteEditor(),
                        ),
                      )
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
