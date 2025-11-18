import 'package:flutter/material.dart';

class TwynkAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isMobile;
  final bool drawerOpen;

  const TwynkAppBar({
    super.key,
    required this.isMobile,
    required this.drawerOpen,
  });

  @override
  State<TwynkAppBar> createState() => _TwynkAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TwynkAppBarState extends State<TwynkAppBar> {
  bool _searchActive = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
        Expanded(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 40,
              child: const SearchFormFlutter(),
            ),
          ),
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
      TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.workspace_premium_outlined),
        label: const Text('Atualizar'),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          foregroundColor: Colors.amber,
          backgroundColor: Colors.amber.withAlpha(25),
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
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.blue, width: 1),
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
                backgroundColor: Colors.lightBlue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
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