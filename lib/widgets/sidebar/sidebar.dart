import 'package:flutter/material.dart';
import '../resizeable_box.dart';
import '../../constants.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import './notebooks_and_tags.dart';

// This is where list of notebooks, app logo and hamburgur menu is located
class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
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
            const NotebooksAndTags()
          ],
        ),
      ),
    );
  }
}
