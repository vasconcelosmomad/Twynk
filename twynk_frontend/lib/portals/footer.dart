import 'package:flutter/material.dart';
import '../themes/twynk_colors.dart';

class Footer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Footer({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: NomirroColors.primary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Nomirro',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_fill),
          label: 'Shorts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sync_alt),
          label: 'Interações',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Você',
        ),
      ],
    );
  }
}