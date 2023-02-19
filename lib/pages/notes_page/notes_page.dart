import 'package:flint/pages/notes_page/note_editor.dart';
import 'package:flutter/material.dart';
import '../../layout.dart';
import 'notes_sidebar.dart';
import 'package:provider/provider.dart';
import 'package:flint/providers/user_data_provider.dart';
import 'package:flint/providers/theme_provider.dart';
import 'notes_tabs.dart';

// The notes page of the app
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool editorMode = true;
  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: currentTheme['accent'],
        onPressed: () {
          setState(() {
            editorMode = !editorMode;
          });
        },
        child: Icon(editorMode ? Icons.visibility : Icons.create),
      ),
      body: Layout(
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
                            child:
                                editorMode ? const NoteEditor() : Container(),
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
      ),
    );
  }
}
