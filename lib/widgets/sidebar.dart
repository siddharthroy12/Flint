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
  void showCreateNotebookPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return const CreateNewNotebookDialog();
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
                        onActionClick: showCreateNotebookPopup,
                      ),
                      ...notebooks.entries
                          .map((e) => SidebarSubItem(
                              name: e.key, count: e.value.notes.length))
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
    this.color,
  });
  final String name; // Name of the notebook or tag
  final int count; // Number of notes
  final Color? color;
  @override
  State<SidebarSubItem> createState() => _SidebarSubItemState();
}

class _SidebarSubItemState extends State<SidebarSubItem> {
  bool _hovering = false;
  // Color of the Tag
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hovering) {
        setState(() {
          _hovering = hovering;
        });
      },
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
                          PopupMenuItem(child: Text('Rename')),
                          PopupMenuItem(child: Text('Delete'))
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
      onTap: () {},
    );
  }
}

class CreateNewNotebookDialog extends StatefulWidget {
  const CreateNewNotebookDialog({
    super.key,
  });

  @override
  State<CreateNewNotebookDialog> createState() =>
      _CreateNewNotebookDialogState();
}

class _CreateNewNotebookDialogState extends State<CreateNewNotebookDialog> {
  var name = '';

  void onCreate() {
    Provider.of<UserDataProvider>(context, listen: false).addNotebook(name);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Create new Notebook",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      content: TextField(
        decoration: const InputDecoration(
          hintText: 'Enter notebook name',
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
          onPressed: name.trim() == '' ? null : onCreate,
          style: ButtonStyle(foregroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            if (!states.contains(MaterialState.disabled)) {
              return Theme.of(context).colorScheme.primary;
            }
          })),
          child: const Text(
            'CREATE',
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        )
      ],
    );
  }
}
