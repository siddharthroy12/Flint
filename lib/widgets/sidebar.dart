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
  void showNotebookPopup(Notebook? notebook) {
    var createForm = {
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
      'initialText': notebook != null ? notebook.name : '',
      'onConfirm': (name) {
        final renameNotebook =
            Provider.of<UserDataProvider>(context, listen: false)
                .renameNotebook;

        renameNotebook(notebook!.name, name);
      },
      'confirmText': 'RENAME',
      'valid': (newName) {
        final notebooks =
            Provider.of<UserDataProvider>(context, listen: false).notebooks;
        return newName.trim() != '' &&
            newName != notebook!.name &&
            !notebooks.containsKey(newName);
      }
    };
    final form = notebook == null ? createForm : renameForm;
    showDialog(
      context: context,
      builder: (context) {
        return NotebookUpdateDialog(
          title: form['title'] as String,
          hintText: form['hintText'] as String,
          initialName: form['initialText'] as String,
          onCancle: () {},
          onConfirm: form['onConfirm'] as Function(String),
          confirmText: form['confirmText'] as String,
          valid: form['valid'] as bool Function(String),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notebooks = context.watch<UserDataProvider>().notebooks;

    return ResizeableBox(
      initialWidth: 300,
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
                          showNotebookPopup(null);
                        },
                      ),
                      // Todo Add sorting of notebooks by last used
                      ...notebooks.entries
                          .map(
                            (e) => SidebarSubItem(
                              name: e.key,
                              count: e.value.notes.length,
                              onTapDelete: () {},
                              onTapRename: () {
                                showNotebookPopup(e.value);
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
            Text(widget.name),
            Expanded(child: Container()),
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
                                () => widget.onTapDelete,
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

// This is used for creating and renaming notebook
class NotebookUpdateDialog extends StatefulWidget {
  const NotebookUpdateDialog({
    super.key,
    required this.title,
    required this.hintText,
    this.initialName,
    required this.onCancle,
    required this.onConfirm,
    required this.confirmText,
    required this.valid,
  });

  final String? initialName;
  final String title;
  final String hintText;
  final Function onCancle;
  final Function(String) onConfirm;
  final String confirmText;
  final bool Function(String) valid;

  @override
  State<NotebookUpdateDialog> createState() => _NotebookUpdateDialogState();
}

class _NotebookUpdateDialogState extends State<NotebookUpdateDialog> {
  var name = '';
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  void onCreate() {
    Navigator.pop(context);
    widget.onCancle(name);
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = UnderlineInputBorder(
      borderSide: BorderSide(
          color: widget.valid(name)
              ? Theme.of(context).colorScheme.primary
              : Colors.red),
    );
    return AlertDialog(
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
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
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onCancle();
          },
          child: Text(
            'CANCLE',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        TextButton(
          onPressed: !widget.valid(name)
              ? null
              : () {
                  Navigator.pop(context);
                  widget.onConfirm(name);
                },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith(
              (Set<MaterialState> states) {
                if (!states.contains(MaterialState.disabled)) {
                  return Theme.of(context).colorScheme.primary;
                }
              },
            ),
          ),
          child: Text(
            widget.confirmText,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        )
      ],
    );
  }
}
