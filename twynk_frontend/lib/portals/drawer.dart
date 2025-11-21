import 'package:flutter/material.dart';
import '../themes/twynk_colors.dart';

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
      {'icon': Icons.people, 'label': 'Nomirro'},
      {'icon': Icons.person, 'label': 'Você'},
      {'icon': Icons.play_circle_fill, 'label': 'Shorts'},
      {'icon': Icons.sync_alt, 'label': 'Interações'},
     
    ];

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

                return ListTile(
                  leading: Icon(item['icon'] as IconData),
                  title: compact ? null : Text(item['label'] as String),
                  selected: selectedIndex == index,
                  onTap: () => onItemSelected?.call(index),
                  selectedColor: NomirroColors.primary,
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                );
              }),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.workspace_premium_outlined, color: NomirroColors.accentDark),
                title: compact ? null : const Text('Atualizar plano'),
                selected: selectedIndex == 4,
                onTap: () => onItemSelected?.call(4),
                selectedColor: NomirroColors.primary,
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: compact ? null : const Text('Sair/Deslogar'),
                selected: selectedIndex == 5,
                onTap: () => onItemSelected?.call(5),
                selectedColor: NomirroColors.primary,
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '© ${DateTime.now().year} Nomirro  Todos os direitos reservados',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
  }
}