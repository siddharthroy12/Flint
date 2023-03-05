import 'package:flutter/material.dart';
import './notebook_dialogs.dart';
import '../../providers/user_data_provider.dart';
import './sidebar_item.dart';
import 'package:provider/provider.dart';
import './sidebar_sub_item.dart';

class NotebooksAndTags extends StatefulWidget {
  const NotebooksAndTags({super.key});

  @override
  State<NotebooksAndTags> createState() => _NotebooksAndTagsState();
}

class _NotebooksAndTagsState extends State<NotebooksAndTags> {
  @override
  Widget build(BuildContext context) {
    final notebooks = context.watch<UserDataProvider>().notebooks;
    final tags = context.watch<UserDataProvider>().tags;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SidebarItem(
              title: 'All Notes',
              prefixIcon: Image.asset(
                width: 22,
                'images/icons/home_storage.png',
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SidebarItem(
              title: 'Notebooks',
              prefixIcon: Image.asset(
                width: 20,
                'images/icons/book.png',
                color: Theme.of(context).colorScheme.secondary,
              ),
              actionIcon: Icon(
                Icons.create_new_folder_outlined,
                size: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onActionClick: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const NotebookCreateRenameDialog();
                  },
                );
              },
            ),
            // TODO: Add sorting of notebooks by last used
            ...notebooks
                .map(
                  (notebook) => SidebarSubItem(
                    name: notebook.name,
                    count: notebook.notes.length,
                    onTapDelete: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteDialog(
                          name: notebook.name,
                          onConfirm: () {
                            final userDataProvider =
                                Provider.of<UserDataProvider>(context,
                                    listen: false);
                            userDataProvider.deleteNotebook(notebook.name);
                          },
                        ),
                      );
                    },
                    onTapRename: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return NotebookCreateRenameDialog(
                            notebook: notebook,
                          );
                        },
                      );
                    },
                  ),
                )
                .toList(),
            SidebarItem(
              title: 'Tags',
              prefixIcon: Icon(
                Icons.label_outline,
                size: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              actionIcon: Icon(
                Icons.new_label_outlined,
                size: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onActionClick: () {
                showDialog(
                  context: context,
                  builder: (context) => const TagCreateAndUpdateDialog(),
                );
              },
            ),
            ...tags
                .map(
                  (tag) => SidebarSubItem(
                    name: tag.name,
                    color: tag.color,
                    count: 0, // TODO: Added notebooks count
                    onTapDelete: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteDialog(
                          name: tag.name,
                          onConfirm: () {
                            final userDataProvider =
                                Provider.of<UserDataProvider>(context,
                                    listen: false);
                            userDataProvider.deleteTag(tag.name);
                          },
                        ),
                      );
                    },
                    onTapRename: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return TagCreateAndUpdateDialog(
                            tag: tag,
                          );
                        },
                      );
                    },
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }
}
