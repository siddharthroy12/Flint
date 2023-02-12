import 'package:flutter/material.dart';

class Topbar extends StatelessWidget {
  const Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 32, 32, 32),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: const [
            Text('FLiNT'),
          ],
        ),
      ),
    );
  }
}
