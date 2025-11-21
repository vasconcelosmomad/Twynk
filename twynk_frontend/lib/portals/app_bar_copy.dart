import 'package:flutter/material.dart';
import '../themes/twynk_colors.dart';

class NomirroAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isMobile;
  final bool? drawerOpen;

  const NomirroAppBar({
    super.key,
    required this.isMobile,
    this.drawerOpen = false,
  });

  @override
  State<NomirroAppBar> createState() => _NomirroAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NomirroAppBarState extends State<NomirroAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: widget.isMobile
          ? Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  if (widget.drawerOpen == true) {
                    Navigator.of(ctx).pop();
                  } else {
                    Scaffold.of(ctx).openDrawer();
                  }
                },
              ),
            )
          : null,
      title: _buildTitle(context),
      actions: _buildActions(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (widget.isMobile) {
      return Image.asset('assets/icons/logo_02.png', height: 32);
    }

    // DESKTOP
    return Row(
      children: [
        const SizedBox(width: 8.0),
        Image.asset('assets/icons/logo_02.png', height: 32),
        const SizedBox(width: 8.0),
        const Spacer(),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      const SizedBox(width: 16.0),
      if (widget.isMobile)
        IconButton.filledTonal(
          onPressed: () {},
          icon: const Icon(Icons.add_outlined),
          tooltip: 'Criar',
          style: IconButton.styleFrom(
            backgroundColor: NomirroColors.primary.withAlpha(25),
            foregroundColor: NomirroColors.primary,
            padding: const EdgeInsets.all(6.0),
            minimumSize: const Size(36, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        )
      else
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Criar'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            foregroundColor: Colors.white,
            backgroundColor: NomirroColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      const SizedBox(width: 16.0),
      if (widget.isMobile)
        IconButton.filledTonal(
          onPressed: () {},
          icon: const Icon(Icons.workspace_premium_outlined),
          tooltip: 'Atualizar',
          style: IconButton.styleFrom(
            backgroundColor: NomirroColors.accentDark.withAlpha(25),
            foregroundColor: NomirroColors.accentDark,
            padding: const EdgeInsets.all(6.0),
            minimumSize: const Size(36, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        )
      else
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.workspace_premium_outlined),
          label: const Text('Atualizar'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            foregroundColor: NomirroColors.accentDark,
            backgroundColor: NomirroColors.accentDark.withAlpha(25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      const SizedBox(width: 16.0),
    ];
  }
}

class SearchFormFlutter extends StatefulWidget {
  const SearchFormFlutter({super.key});

  @override
  State<SearchFormFlutter> createState() => _SearchFormFlutterState();
}

class _SearchFormFlutterState extends State<SearchFormFlutter> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            hintText: 'Pesquisar',
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white12
                : const Color(0xFFF6EAFE),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          top: 0,
          child: Tooltip(
            message: 'Pesquisar',
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white24
                    : NomirroColors.primary.withValues(alpha: 0.18),
                foregroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : NomirroColors.accentDark,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(0),
                  ),
                ),
              ).copyWith(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                // Ação do botão
              },
              child: const Icon(Icons.search),
            ),
          ),
        ),
      ],
    );
  }
}