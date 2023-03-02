import 'package:flutter/material.dart';

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
