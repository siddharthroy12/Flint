import 'package:flint/common_widgets/custom_icon_button.dart';
import 'package:flint/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesActions extends StatelessWidget {
  const NotesActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            icon: Icons.note_add_outlined,
            tooltip: 'New Note',
            preferredTooltipDirection: AxisDirection.down,
            onClick: () => userData.addNote(),
          ),
          CustomIconButton(
            icon: Icons.create_new_folder_outlined,
            tooltip: 'Create folder',
            preferredTooltipDirection: AxisDirection.down,
            onClick: () {},
          ),
          CustomIconButton(
            icon: Icons.sort,
            tooltip: 'Change Sort Order',
            preferredTooltipDirection: AxisDirection.down,
            onClick: () {},
          ),
          CustomIconButton(
            icon: Icons.expand,
            tooltip: 'Expand all',
            preferredTooltipDirection: AxisDirection.down,
            onClick: () {},
          ),
          CustomIconButton(
            icon: Icons.search_outlined,
            tooltip: 'Search',
            preferredTooltipDirection: AxisDirection.down,
            onClick: () {},
          )
        ],
      ),
    );
  }
}
