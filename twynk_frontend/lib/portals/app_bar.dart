import 'package:flutter/material.dart';
import '../themes/twynk_colors.dart';

class NomirroAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isMobile;
  final bool drawerOpen;

  const NomirroAppBar({
    super.key,
    required this.isMobile,
    required this.drawerOpen,
  });

  @override
  State<NomirroAppBar> createState() => _NomirroAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NomirroAppBarState extends State<NomirroAppBar> {
  bool _searchActive = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: widget.isMobile
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                if (widget.drawerOpen) {
                  Navigator.of(context).pop();
                } else {
                  Scaffold.of(context).openDrawer();
                }
              },
            )
          : null,
      title: _buildTitle(context),
      actions: _buildActions(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    // MOBILE
    if (widget.isMobile && _searchActive) {
      return const SizedBox(
        height: 40,
        child: SearchFormFlutter(),
      );
    }

    if (widget.isMobile) {
      return Image.asset('assets/icons/logo_02.png', height: 42);
    }

    // DESKTOP
    return Row(
      children: [
        const SizedBox(width: 8.0),
        Image.asset('assets/icons/logo_02.png', height: 32),
        const SizedBox(width: 8.0),
        const Spacer(),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 40,
          child: const SearchFormFlutter(),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    if (widget.isMobile && _searchActive) {
      return [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() => _searchActive = false),
        ),
      ];
    }

    return [
      if (widget.isMobile)
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => setState(() => _searchActive = true),
        ),
      const SizedBox(width: 16.0),
      if (widget.isMobile)
        IconButton.filledTonal(
          onPressed: () {},
          icon: const Icon(Icons.add),
          tooltip: 'Criar',
          style: IconButton.styleFrom(
            backgroundColor: NomirroColors.primary.withAlpha(25),
            foregroundColor: NomirroColors.primary,
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
      _buildUserMenu(context),
      const SizedBox(width: 16.0),
    ];
  }

  Widget _buildUserMenu(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => const [
        PopupMenuItem<String>(
          value: 'name',
          child: Row(
            children: [
              Icon(Icons.person, size: 18),
              SizedBox(width: 8),
              Text('Nome'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.settings, size: 18),
              SizedBox(width: 8),
              Text('Profile'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'update_plan',
          child: Row(
            children: [
              Icon(Icons.workspace_premium_outlined, size: 18, color: NomirroColors.accentDark),
              SizedBox(width: 8),
              Text('Update plan'),
            ],
          ),
        ),
      ],
      position: PopupMenuPosition.under,
      onSelected: (value) {},
      child: const CircleAvatar(
        radius: 16,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, size: 18, color: Colors.white),
      ),
    );
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
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white12
                : const Color(0xFFF6EAFE),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            // No borders on enabled/focused as requested
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          top: 0,
          child: Tooltip(
            message: 'Search',
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