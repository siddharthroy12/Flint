import 'package:flutter/material.dart';
import '../../providers/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
// If notebook is given then it's for renaming otherwise it's for creating
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
      'hintText': 'Enter new notebook name',
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
      ),
    );
  }
}

class TagCreateAndUpdate extends StatefulWidget {
  const TagCreateAndUpdate({
    super.key,
    this.tag,
  });
  final Tag? tag;

  @override
  State<TagCreateAndUpdate> createState() => _TagCreateAndUpdateState();
}

class _TagCreateAndUpdateState extends State<TagCreateAndUpdate> {
  String name = '';
  Color color = Colors.blue;
  late TextEditingController _controller;
  var form = {};

  @override
  void initState() {
    super.initState();
    final createForm = {
      'title': 'Create Tag',
      'hintText': 'Enter tag name',
      'initialText': '',
      'initialColor': Colors.blue,
      'onConfirm': (name) {},
      'confirmText': 'CREATE',
      'valid': (name) {
        return true;
      }
    };

    final renameForm = {
      'title': 'Update Tag',
      'hintText': 'Update Tag name',
      'initialText': '',
      'initialColor': Colors.blue,
      'onConfirm': (name) {},
      'confirmText': 'UPDATE',
      'valid': (newName) {
        return true;
      }
    };
    form = widget.tag == null ? createForm : renameForm;
    _controller = TextEditingController(text: form['initialText']);
    color = form['initialColor'];
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
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
          const SizedBox(
            height: 20,
          ),
          BlockPicker(
            availableColors: const [
              Color(0xFF3F51B5),
              Color(0xFF2196F3),
              Color(0xFF4CAF50),
              Color(0xFFFFEB3B),
              Color(0xFFE91E63),
              Color(0xFF673AB7),
            ],
            layoutBuilder: (context, colors, child) => SizedBox(
              height: 50,
              width: 300,
              child: GridView.count(
                crossAxisCount: 6,
                children: [for (Color color in colors) child(color)],
              ),
            ),
            itemBuilder: (color, isCurrentColor, changeColor) {
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: color,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: changeColor,
                    borderRadius: BorderRadius.circular(30),
                    child: AnimatedOpacity(
                      duration: const Duration(microseconds: 250),
                      opacity: isCurrentColor ? 1 : 0,
                      child: Icon(
                        Icons.done,
                        size: 24,
                        color: useWhiteForeground(color)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
            pickerColor: form['initialColor'],
            onColorChanged: (_) {},
          )
        ],
      ),
      actions: generateDialogActions(
        value: name,
        isValid: form['valid'],
        context: context,
        onConfirm: () {
          form['onConfirm'](name);
        },
        confirmText: form['confirmText'],
      ),
    );
  }
}
