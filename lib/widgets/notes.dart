import 'package:flutter/material.dart';
import './resizeable_box.dart';
import '../constants.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

// This is where list of notebooks, app logo and hamburgur menu is located
class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return ResizeableBox(
      initialWidth: 200,
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Column(
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
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      splashRadius: 18,
                      icon: Icon(
                        size: 20,
                        Icons.sort_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Expanded(child: MoveWindow()),
                    IconButton(
                      onPressed: () {},
                      splashRadius: 18,
                      icon: Icon(
                        Icons.note_add_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
            ),
            TextField(
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Search',
                isCollapsed: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.tertiary, width: 2),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
