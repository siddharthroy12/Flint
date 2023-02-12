import 'package:provider/provider.dart';
import 'package:flint/providers/theme_provider.dart';
import 'package:flint/providers/user_data_provider.dart';
import 'package:flutter/material.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return Consumer<UserDataProvider>(
      builder: (context, userData, child) => Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
        child: SizedBox(
          height: 35,
          child: ListView.separated(
            itemCount: userData.openedNotes.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) => Container(
              decoration: BoxDecoration(
                color: currentTheme['secondaryBackground'],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: currentTheme['primaryBackground'],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8),
                  child: VerticalDivider(
                    width: 1,
                    color: (currentTheme['border'] as Color),
                  ),
                ),
              ),
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    color: index == 0
                        ? currentTheme['secondaryBackground']
                        : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      userData.openedNotes[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
