import 'package:flutter/material.dart';
import './resizeable_box.dart';
import '../constants.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

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
        return CreateNewNotebookDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        onActionClick: showCreateNotebookPopup,
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
  static const _itemPadding = EdgeInsets.only(bottom: 15);

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

    return Padding(
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

  void onCreate() {}
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Create new Notebook",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
      content: TextField(
        decoration: const InputDecoration(hintText: 'Enter notebook name'),
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
          child: const Text('CANCLE'),
        ),
        TextButton(
          onPressed: name.trim() == '' ? null : onCreate,
          child: const Text('CREATE'),
        )
      ],
    );
  }
}
