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

    return Scrollable(
      viewportBuilder: (context, position) {
        return Padding(
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
              // Todo Add sorting of notebooks by last used
              ...notebooks.entries
                  .map(
                    (e) => SidebarSubItem(
                      name: e.key,
                      count: e.value.notes.length,
                      onTapDelete: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              NotebookDeleteDialog(notebook: e.value),
                        );
                      },
                      onTapRename: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return NotebookCreateRenameDialog(
                              notebook: e.value,
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
                    builder: (context) => const TagCreateAndUpdate(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
