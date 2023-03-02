import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './resizeable_box.dart';
import '../constants.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import '../providers/user_data_provider.dart';

// This is where list of notebooks, app logo and hamburgur menu is located
class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // For creating or updating notebook
  // If notebook is given it's for renaming else it's for creating
  void showCreateRenameNotebookPopup(Notebook? notebook) {
    showDialog(
      context: context,
      builder: (context) {
        return NotebookCreateRenameDialog(
          notebook: notebook,
        );
      },
    );
  }

  void showDeleteNotebookPopup(Notebook notebook) {
    showDialog(
      context: context,
      builder: (context) => NotebookDeleteDialog(notebook: notebook),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notebooks = context.watch<UserDataProvider>().notebooks;

    return ResizeableBox(
      initialWidth: 200,
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom:
                      BorderSide(color: Theme.of(context).colorScheme.outline),
                ),
              ),
              child: SizedBox(
                height: topBarHeight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        width: 20,
                        'images/appicon.png',
                      ),
                      Expanded(child: MoveWindow()),
                      IconButton(
                        onPressed: () {},
                        splashRadius: 18,
                        icon: Icon(
                          size: 20,
                          Icons.menu,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Scrollable(
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
                          showCreateRenameNotebookPopup(null);
                        },
                      ),
                      // Todo Add sorting of notebooks by last used
                      ...notebooks.entries
                          .map(
                            (e) => SidebarSubItem(
                              name: e.key,
                              count: e.value.notes.length,
                              onTapDelete: () {
                                showDeleteNotebookPopup(e.value);
                              },
                              onTapRename: () {
                                showCreateRenameNotebookPopup(e.value);
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
                        onActionClick: () {},
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

// For Items like All Notes, Notebooks, Tags
class SidebarItem extends StatelessWidget {
  const SidebarItem({
    super.key,
    required this.title,
    required this.prefixIcon,
    this.onActionClick,
    this.actionIcon,
  });
  final String title;
  final Widget prefixIcon;
  final Function()? onActionClick;
  final Widget? actionIcon;
  static const _itemPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 8);

  @override
  Widget build(BuildContext context) {
    Widget actionButton = Container();

    if (actionIcon != null) {
      actionButton = IconButton(
        onPressed: onActionClick ?? onActionClick,
        splashRadius: 18,
        padding: const EdgeInsets.all(0),
        // Adding empty box constraints is important
        // because this assumes a minimum size of 48px
        constraints: const BoxConstraints(),
        icon: actionIcon!,
      );
    }

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: _itemPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            prefixIcon,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            actionButton
          ],
        ),
      ),
    );
  }
}

// This is used to show notes and tags
class SidebarSubItem extends StatefulWidget {
  const SidebarSubItem({
    super.key,
    required this.name,
    required this.count,
    required this.onTapDelete,
    required this.onTapRename,
    this.color,
  });
  final String name; // Name of the notebook or tag
  final int count; // Number of notes
  final Color? color; // The color on the tag
  final void Function() onTapDelete;
  final void Function() onTapRename;
  @override
  State<SidebarSubItem> createState() => _SidebarSubItemState();
}

class _SidebarSubItemState extends State<SidebarSubItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hovering) {
        setState(() {
          _hovering = hovering;
        });
      },
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const SizedBox(width: 40),
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                widget.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _hovering
                ? Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: PopupMenuButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 15,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            height: 20,
                            padding: const EdgeInsets.all(10),
                            value: 'rename',
                            onTap: () {
                              // This future thing is used here instead of
                              // on selected because on selected doesn't work
                              // when PopupMenuItem is inside InkWell
                              // and onTap calles navigation.pop which will
                              // remove my dialog and the only way to overcome that
                              // is to make it happpen asynchronously
                              Future.delayed(
                                const Duration(seconds: 0),
                                () => widget.onTapRename(),
                              );
                            },
                            child: const Text(
                              'Rename',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          PopupMenuItem(
                            height: 20,
                            padding: const EdgeInsets.all(10),
                            value: 'delete',
                            onTap: () {
                              Future.delayed(
                                const Duration(seconds: 0),
                                () => widget.onTapDelete(),
                              );
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                        icon: const Icon(
                          Icons.more_vert_outlined,
                          size: 15,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      widget.count.toString(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  ),
          ],
        ),
      ),
      // onTap: () {},
    );
  }
}

// Generate action buttons for dialogs
// If valid callback is given then value should also be present
List<Widget> generateDialogActions({
  String? value,
  required BuildContext context,
  required Function onConfirm,
  required String confirmText,
  bool Function(String)? isValid,
  bool danger = false,
}) {
  final confirmEnable = isValid != null ? isValid(value!) : true;

  return [
    TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'CANCLE',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    ),
    FilledButton(
      onPressed: confirmEnable
          ? () {
              Navigator.pop(context);
              onConfirm();
            }
          : null,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2), // <-- Radius
        ),
        backgroundColor: danger
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.tertiary,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        confirmText,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    )
  ];
}

class NotebookDeleteDialog extends StatelessWidget {
  const NotebookDeleteDialog({
    super.key,
    required this.notebook,
  });
  final Notebook notebook;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirm Delete',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      content: Text(
        'Are you sure you want to delete "${notebook.name}"?',
        style: TextStyle(
          fontWeight: FontWeight.w300,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      actions: generateDialogActions(
        danger: true,
        context: context,
        onConfirm: () {
          Provider.of<UserDataProvider>(context, listen: false)
              .deleteNotebook(notebook.name);
        },
        confirmText: 'DELETE',
      ),
    );
  }
}

// This is used for creating and renaming notebook
class NotebookCreateRenameDialog extends StatefulWidget {
  const NotebookCreateRenameDialog({
    super.key,
    this.notebook,
  });

  final Notebook? notebook;

  @override
  State<NotebookCreateRenameDialog> createState() =>
      _NotebookCreateRenameDialogState();
}

class _NotebookCreateRenameDialogState
    extends State<NotebookCreateRenameDialog> {
  var name = '';
  late TextEditingController _controller;
  var form = {};

  @override
  void initState() {
    super.initState();
    final createForm = {
      'title': 'Create Notebook',
      'hintText': 'Enter notebook name',
      'initialText': '',
      'onConfirm': (name) {
        Provider.of<UserDataProvider>(context, listen: false).addNotebook(name);
      },
      'confirmText': 'CREATE',
      'valid': (name) {
        final notebooks =
            Provider.of<UserDataProvider>(context, listen: false).notebooks;
        return name.trim() != '' && !notebooks.containsKey(name);
      }
    };

    var renameForm = {
      'title': 'Rename Notebook',
      'hintText': 'Enter name notebook name',
      'initialText': widget.notebook != null ? widget.notebook!.name : '',
      'onConfirm': (name) {
        final renameNotebook =
            Provider.of<UserDataProvider>(context, listen: false)
                .renameNotebook;

        renameNotebook(widget.notebook!.name, name);
      },
      'confirmText': 'RENAME',
      'valid': (newName) {
        final notebooks =
            Provider.of<UserDataProvider>(context, listen: false).notebooks;
        return newName.trim() != '' &&
            newName != widget.notebook!.name &&
            !notebooks.containsKey(newName);
      }
    };
    form = widget.notebook == null ? createForm : renameForm;
    _controller = TextEditingController(text: form['initialText']);
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = UnderlineInputBorder(
      borderSide: BorderSide(
          color: form['valid'](name)
              ? Theme.of(context).colorScheme.primary
              : Colors.red),
    );
    return AlertDialog(
        title: Text(
          form['title'],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: form['hintText'],
            focusedBorder: inputBorder,
          ),
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.primary,
          ),
          onChanged: (value) {
            setState(() {
              name = value;
            });
          },
        ),
        actions: generateDialogActions(
          value: name,
          isValid: form['valid'],
          context: context,
          onConfirm: () {
            form['onConfirm'](name);
          },
          confirmText: form['confirmText'],
        ));
  }
}
