import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final bool compact;
  final bool showDrawerHeader;
  final int selectedIndex;
  final Function(int)? onItemSelected;

  const SidebarMenu({
    super.key,
    this.compact = false,
    this.showDrawerHeader = false,
    this.selectedIndex = 0,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double menuFontSize = screenWidth >= 1024
        ? 16
        : screenWidth >= 600
            ? 15
            : 14;

    final items = [
      {'icon': Icons.person_search, 'label': 'Encontros'},
      {'icon': Icons.notifications, 'label': 'Proximo'},
      {'icon': Icons.play_circle_fill, 'label': 'Explore'},
      {'icon': Icons.chat_bubble, 'label': 'Chats'},
      {'icon': Icons.person, 'label': 'Perfil'},
    ];

    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final ColorScheme colorScheme = theme.colorScheme;

    final Color baseTextColor = isDark
        ? (theme.textTheme.bodyMedium?.color ?? Colors.white70)
        : (theme.textTheme.bodyMedium?.color ?? colorScheme.onSurface);

    final Color unselectedTextColor =
        baseTextColor.withValues(alpha: isDark ? 0.8 : 0.9);

    final Color selectedTextColor =
        isDark ? colorScheme.secondary : colorScheme.primary;
    final Color selectedTileColor =
        isDark
            ? colorScheme.primary.withValues(alpha: 0.16)
            : colorScheme.primary.withValues(alpha: 0.06);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              if (showDrawerHeader)
                Padding(
                  padding: EdgeInsets.only(top: mediaQuery.padding.top),
                  child: SizedBox(
                    height: kToolbarHeight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            tooltip: 'Fechar',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Image.asset('assets/icons/logo_02.png', height: 32),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final bool isSelected = selectedIndex == index;
                final Color textColor =
                    isSelected ? selectedTextColor : unselectedTextColor;

                return ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: textColor,
                  ),
                  title: compact
                      ? null
                      : Text(
                          item['label'] as String,
                          style: TextStyle(
                            color: textColor,
                            fontSize: menuFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  selected: isSelected,
                  onTap: () => onItemSelected?.call(index),
                  selectedTileColor: selectedTileColor,
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0),
                );
              }),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.workspace_premium_outlined,
                  color: selectedIndex == 5
                      ? selectedTextColor
                      : colorScheme.secondary,
                ),
                title: compact
                    ? null
                    : Text(
                        'Update plan',
                        style: TextStyle(
                          color: selectedIndex == 5
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: menuFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                selected: selectedIndex == 5,
                onTap: () => onItemSelected?.call(5),
                selectedTileColor: selectedTileColor,
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: selectedIndex == 6
                      ? Colors.red.shade300
                      : Colors.red,
                ),
                title: compact
                    ? null
                    : Text(
                        'Log out / Sign out',
                        style: TextStyle(
                          color: selectedIndex == 6
                              ? selectedTextColor
                              : unselectedTextColor,
                          fontSize: menuFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                selected: selectedIndex == 6,
                onTap: () => onItemSelected?.call(6),
                selectedTileColor: selectedTileColor,
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '© ${DateTime.now().year} Nomirro  All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
  }
}