import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Footer({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;
    final Color selectedColor =
        isDark ? colorScheme.secondary : colorScheme.primary;

    final Color baseIconColor = isDark
        ? (theme.appBarTheme.foregroundColor ??
            theme.iconTheme.color ??
            theme.textTheme.bodyMedium?.color ??
            colorScheme.onSurface)
        : (theme.textTheme.bodyMedium?.color ?? colorScheme.onSurface);

    final Color unselectedColor = baseIconColor.withValues(alpha: 0.8);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: theme.scaffoldBackgroundColor,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_search),
          label: 'Encontros',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Proximo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_fill),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}