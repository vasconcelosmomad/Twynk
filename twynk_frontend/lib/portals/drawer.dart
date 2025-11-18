import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final bool compact;
  final bool showDrawerHeader;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SidebarMenu({
    super.key,
    this.compact = false,
    this.showDrawerHeader = false,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home, 'label': 'Início'},
      {'icon': Icons.play_circle_fill, 'label': 'Shorts'},
      {'icon': Icons.sync_alt, 'label': 'Interações'},
      {'icon': Icons.person, 'label': 'Você'},
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
                  padding: const EdgeInsets.fromLTRB(4, 32, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/logo_02.png', height: 32),
                    ],
                  ),
                ),
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return ListTile(
                  leading: Icon(item['icon'] as IconData),
                  title: compact ? null : Text(item['label'] as String),
                  selected: selectedIndex == index,
                  onTap: () => onItemSelected(index),
                  selectedColor: Colors.lightBlue,
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                );
              }),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.workspace_premium_outlined, color: Colors.amber),
                title: compact ? null : const Text('Atualizar plano'),
                selected: selectedIndex == 4,
                onTap: () => onItemSelected(4),
                selectedColor: Colors.lightBlue,
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: compact ? null : const Text('Sair/Deslogar'),
                selected: selectedIndex == 5,
                onTap: () => onItemSelected(5),
                selectedColor: Colors.lightBlue,
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
            '© ${DateTime.now().year} Twynk  Todos os direitos reservados',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
  }
}