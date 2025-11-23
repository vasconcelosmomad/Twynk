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
    final items = [
      {'icon': Icons.person_search, 'label': 'Nearby'},
      {'icon': Icons.people_alt, 'label': 'Encounters'},
      {'icon': Icons.play_circle_fill, 'label': 'Explore'},
      {'icon': Icons.chat_bubble, 'label': 'Chats'},
      {'icon': Icons.notifications, 'label': 'Notification'},
    ];

    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final ColorScheme colorScheme = theme.colorScheme;
    final Color unselectedTextColor = isDark
        ? Colors.white70
        : colorScheme.onSurface.withValues(alpha: 0.7);
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
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                          style: TextStyle(color: textColor),
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