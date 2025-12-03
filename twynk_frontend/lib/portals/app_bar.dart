import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twynk_frontend/pages/channel_panel.dart';
import 'package:twynk_frontend/pages/login.dart';
import 'package:twynk_frontend/pages/plans.dart';
import 'package:twynk_frontend/pages/proflie.dart';
import '../services/api_client.dart';

// O widget _TwoBarMenuIcon foi removido pois não é mais necessário.

class NomirroAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isMobile;
  final bool? drawerOpen;
  final bool showCreateAction;
  final bool enableSearch;

  const NomirroAppBar({
    super.key,
    required this.isMobile,
    this.drawerOpen = false,
    this.showCreateAction = true,
    this.enableSearch = false,
  });

  @override
  State<NomirroAppBar> createState() => _NomirroAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NomirroAppBarState extends State<NomirroAppBar> {
  bool _isMobileSearchActive = false;

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    ApiClient.instance.clearToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

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
      // MOBILE: quando a busca está ativa, mostramos o botão de voltar.
      // Caso contrário, mostramos o ícone de menu para abrir o Drawer,
      // usando a cor definida pelo tema.
      leading: widget.isMobile
          ? (widget.enableSearch && _isMobileSearchActive
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: colorScheme.secondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isMobileSearchActive = false;
                    });
                  },
                )
              : null)
          : null,
      title: _buildTitle(context),
      actions: _buildActions(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    // O logo é mantido no título para ambas as visualizações.
    // Com o `leading` null, ele se alinha à esquerda no mobile.
    final Widget logo =
        Image.asset('assets/icons/logo_02.png', height: 48);

    // MOBILE: quando a busca está habilitada, o título vira o campo de busca.
    if (widget.isMobile) {
      if (widget.enableSearch && _isMobileSearchActive) {
        return const SearchFormFlutter();
      }
      return logo;
    }

    // DESKTOP/TABLET: o campo de busca fica nas actions, não no título.
    return Row(
      children: [
        const SizedBox(width: 8.0),
        logo,
        const SizedBox(width: 8.0),
        const Spacer(),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double mobileSpacing = 4.0;
    final double desktopSpacing = 8.0;

    if (widget.enableSearch && widget.isMobile && _isMobileSearchActive) {
      return const <Widget>[];
    }

    return [
      SizedBox(width: widget.isMobile ? mobileSpacing : desktopSpacing),
      if (widget.showCreateAction)
        if (widget.isMobile)
          IconButton.filledTonal(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ExplorerPage(openUploadOnStart: true),
                ),
              );
            },
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ExplorerPage(openUploadOnStart: true),
                  ),
                );
              },
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
      if (widget.showCreateAction)
        SizedBox(width: widget.isMobile ? mobileSpacing : desktopSpacing),
      // DESKTOP/TABLET: quando habilitado, o campo de busca fica nas actions.
      if (widget.enableSearch && !widget.isMobile) ...[
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: const SearchFormFlutter(),
          ),
        ),
        SizedBox(width: desktopSpacing),
      ],
      if (widget.enableSearch && widget.isMobile) ...[
        Center(
          child: IconButton(
            onPressed: () {
              setState(() {
                _isMobileSearchActive = true;
              });
            },
            icon: Icon(
              Icons.search,
              color: colorScheme.secondary,
            ),
            tooltip: 'Buscar',
          ),
        ),
        SizedBox(width: widget.isMobile ? mobileSpacing : desktopSpacing),
      ],
      _buildUserMenu(context),
      SizedBox(width: widget.isMobile ? mobileSpacing : desktopSpacing),
    ];
  }

  Widget _buildUserMenu(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'name',
          enabled: false,
          child: Row(
            children: [
              Icon(Icons.person, size: 20, color: colorScheme.onSurface),
              const SizedBox(width: 8),
              const Text('Usuário logado'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person_outline, size: 20, color: colorScheme.onSurface),
              const SizedBox(width: 8),
              const Text('Profile'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'plans',
          child: Row(
            children: [
              Icon(Icons.workspace_premium_outlined, size: 20, color: colorScheme.secondary),
              const SizedBox(width: 8),
              const Text('Planos'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: colorScheme.error),
              const SizedBox(width: 8),
              const Text('Logout'),
            ],
          ),
        ),
      ],
      position: PopupMenuPosition.under,
      onSelected: (value) {
        if (value == 'profile') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PainelAssinantePage(),
            ),
          );
        } else if (value == 'plans') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PlansPage(),
            ),
          );
        } else if (value == 'logout') {
          _logout();
        }
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.16),
            child: const Icon(Icons.person, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 4),
          Icon(Icons.more_vert, color: colorScheme.onSurface),
        ],
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