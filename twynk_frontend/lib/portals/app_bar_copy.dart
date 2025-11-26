import 'package:flutter/material.dart';
import 'package:twynk_frontend/pages/plans.dart';

class _TwoBarMenuIcon extends StatelessWidget {
  final Color color;

  const _TwoBarMenuIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    const double size = 22;
    final double barHeight = size * 0.1;
    final double topWidth = size;
    final double bottomWidth = size * 0.7;
    final double spacing = size * 0.28;

    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: topWidth,
            height: barHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(barHeight),
            ),
          ),
          SizedBox(height: spacing),
          Container(
            width: bottomWidth,
            height: barHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(barHeight),
            ),
          ),
        ],
      ),
    );
  }
}

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color baseForegroundColor = colorScheme.onSurface;

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      foregroundColor: baseForegroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 4.0,
      leading: widget.isMobile
          ? Builder(
              builder: (ctx) => IconButton(
                icon: _TwoBarMenuIcon(
                  color: colorScheme.primary,
                ),
                onPressed: () {
                  final scaffoldState = Scaffold.maybeOf(ctx);
                  if (scaffoldState == null) {
                    return;
                  }
                  if (widget.drawerOpen == true) {
                    Navigator.of(ctx).pop();
                  } else if (scaffoldState.hasDrawer) {
                    scaffoldState.openDrawer();
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return [
      const SizedBox(width: 16.0),
      if (widget.isMobile)
        IconButton.filledTonal(
          onPressed: () {},
          icon: Icon(
            Icons.add_outlined,
            color: colorScheme.primary,
          ),
          tooltip: 'Criar',
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
            foregroundColor: colorScheme.primary,
            padding: const EdgeInsets.all(6.0),
            minimumSize: const Size(36, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        )
      else
        Center(
          child: TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add_outlined, color: colorScheme.primary),
            label: const Text('Criar'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              foregroundColor: colorScheme.primary,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
      const SizedBox(width: 16.0),
      _buildUserMenu(context),
      const SizedBox(width: 16.0),
    ];
  }

  Widget _buildUserMenu(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
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
              Icon(Icons.workspace_premium_outlined, size: 18, color: colorScheme.secondary),
              SizedBox(width: 8),
              Text('Update plan'),
            ],
          ),
        ),
      ],
      position: PopupMenuPosition.under,
      onSelected: (value) {
        if (value == 'update_plan') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PlansPage(),
            ),
          );
        }
      },
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
            fillColor: theme.brightness == Brightness.dark
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
            message: 'Search',
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: theme.brightness == Brightness.dark
                    ? Colors.white24
                    : colorScheme.primary.withValues(alpha: 0.18),
                foregroundColor: theme.brightness == Brightness.dark
                    ? Colors.white
                    : colorScheme.secondary,
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