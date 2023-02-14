import 'package:provider/provider.dart';
import 'package:flint/providers/theme_provider.dart';
import 'package:flint/providers/user_data_provider.dart';
import 'package:flutter/material.dart';

// Draw bottom rounded corner on both side of the tab

enum Side { left, right }

class BottomCorner extends StatelessWidget {
  final Side side;
  const BottomCorner({super.key, required this.side});

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    const radius = Radius.circular(10);
    return Container(
      decoration: BoxDecoration(
        color: currentTheme['secondaryBackground'],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: currentTheme['primaryBackground'],
          borderRadius: BorderRadius.only(
            bottomRight: side == Side.left ? radius : Radius.zero,
            bottomLeft: side == Side.right ? radius : Radius.zero,
          ),
        ),
        child: const SizedBox(width: 5, height: double.infinity),
      ),
    );
  }
}

class NotesTab extends StatelessWidget {
  const NotesTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userData, child) => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SizedBox(
          height: 38,
          child: ListView.builder(
            itemCount: userData.openedNotes.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              bool isSelected =
                  userData.openedNotes[index] == userData.selectedNote;
              bool isSelectedOnRight = userData.selectedIndex == index + 1;
              bool isSelecetedOnLeft = userData.selectedIndex == index - 1;
              bool isLast = index == userData.openedNotes.length - 1;
              return Row(
                children: [
                  ...(index == 0 && isSelected
                      ? [const BottomCorner(side: Side.left)]
                      : [SizedBox(width: index == 0 ? 5 : 0)]),
                  Tab(
                    onClick: () {
                      userData.selectNote(userData.openedNotes[index]);
                    },
                    onClose: () {},
                    title: userData.openedNotes[index],
                    isSelectedOnLeft: isSelecetedOnLeft,
                    isSelectedOnRight: isSelectedOnRight,
                    showBackground:
                        userData.openedNotes[index] == userData.selectedNote,
                  ),
                  ...(isLast
                      ? [
                          PlusButton(
                            showBottomCorner: isSelected,
                          )
                        ]
                      : []),
                ],
              );
            },
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
  final bool isSelectedOnLeft;
  final bool isSelectedOnRight;

  const Tab({
    super.key,
    required this.onClick,
    required this.onClose,
    required this.title,
    required this.isSelectedOnLeft,
    required this.isSelectedOnRight,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    Widget leftSide;
    Widget rightSide;
    if (showBackground) {
      leftSide = const SizedBox(width: 5);
      rightSide = leftSide;
    } else {
      if (isSelectedOnLeft) {
        leftSide = const BottomCorner(side: Side.right);
      } else {
        leftSide = const SizedBox(width: 5);
      }
      if (isSelectedOnRight) {
        rightSide = const BottomCorner(side: Side.left);
      } else {
        rightSide = const SizedBox(width: 5);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: showBackground
            ? currentTheme['secondaryBackground']
            : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            ...(showBackground ? [const SizedBox(width: 5)] : [leftSide]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextButton(
                onPressed: onClick,
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith((states) =>
                        showBackground
                            ? currentTheme['secondaryBackground']
                            : currentTheme['highlightBackground'])),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 30,
              child: IconButton(
                splashRadius: 15,
                onPressed: () {},
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.close,
                  size: 15,
                ),
              ),
            ),
            ...(showBackground ? [const SizedBox(width: 5)] : [rightSide]),
          ],
        ),
      ),
    );
  }
}

class PlusButton extends StatelessWidget {
  final bool showBottomCorner;
  const PlusButton({super.key, required this.showBottomCorner});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...(showBottomCorner
            ? [
                const BottomCorner(side: Side.right),
              ]
            : [
                const SizedBox(
                  width: 5,
                )
              ]),
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
