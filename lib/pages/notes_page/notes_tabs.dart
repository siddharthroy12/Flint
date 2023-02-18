import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flint/providers/theme_provider.dart';
import 'package:flint/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NotesTab extends StatefulWidget {
  const NotesTab({
    super.key,
  });

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return Consumer<UserDataProvider>(
      builder: (context, userData, child) => Material(
        color: currentTheme['primaryBackground'],
        child: Container(
          decoration: BoxDecoration(
              border: BorderDirectional(
                  bottom: BorderSide(color: currentTheme['border']))),
          child: SizedBox(
            height: 46,
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  double offset =
                      scrollController.offset + event.scrollDelta.dy;
                  offset = offset.clamp(
                      0, scrollController.position.maxScrollExtent);
                  scrollController.jumpTo(offset);
                }
              },
              child: ListView.builder(
                itemCount: userData.openedNotes.length,
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                itemBuilder: (context, index) {
                  bool isSelected = index == userData.selectedNoteIndex;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Tab(
                        onClick: () {
                          userData.selectedNoteIndex = index;
                        },
                        onClose: () {
                          userData.closeNote(index);
                        },
                        title: userData.openedNotes[index].path
                            .split(Platform.pathSeparator)
                            .last
                            .split('.')
                            .first,
                        showBackground: isSelected,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Tab extends StatelessWidget {
  final void Function() onClose;
  final void Function() onClick;
  final String title;
  final bool showBackground;

  const Tab({
    super.key,
    required this.onClick,
    required this.onClose,
    required this.title,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return Container(
      decoration: BoxDecoration(
        color: showBackground
            ? currentTheme['secondaryBackground']
            : Colors.transparent,
        border: BorderDirectional(
          bottom: BorderSide(
            color: showBackground
                ? currentTheme['accent'] as Color
                : Colors.transparent,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 30,
                  child: IconButton(
                    splashRadius: 15,
                    onPressed: onClose,
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.close,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlusButton extends StatelessWidget {
  const PlusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: IconButton(
            onPressed: () {},
            splashRadius: 15,
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.add,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
