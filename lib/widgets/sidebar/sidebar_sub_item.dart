import 'package:flutter/material.dart';

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
