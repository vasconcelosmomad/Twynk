import 'package:flutter/material.dart';
import 'package:twynk_frontend/pages/plans.dart';
import '../services/language_controller.dart';

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
      // REMOVIDO: O leading widget para mobile foi removido.
      // Agora ele é sempre null, garantindo que o logo (no título)
      // fique posicionado mais à esquerda.
      leading: widget.isMobile && widget.enableSearch && _isMobileSearchActive
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
          : null,
      title: _buildTitle(context),
      actions: _buildActions(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    // O logo é mantido no título para ambas as visualizações.
    // Com o `leading` null, ele se alinha à esquerda no mobile.
    final Widget logo =
        Image.asset('assets/icons/logo_02.png', height: 42);

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

    if (widget.enableSearch && widget.isMobile && _isMobileSearchActive) {
      return const <Widget>[];
    }

    return [
      const SizedBox(width: 16.0),
      if (widget.showCreateAction)
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
      if (widget.showCreateAction) const SizedBox(width: 16.0),
      // DESKTOP/TABLET: quando habilitado, o campo de busca fica nas actions.
      if (widget.enableSearch && !widget.isMobile) ...[
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: const SearchFormFlutter(),
          ),
        ),
        const SizedBox(width: 16.0),
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
        const SizedBox(width: 16.0),
      ],
      Center(
        child: Builder(
          builder: (context) {
            return Tooltip(
              message: 'Idioma / Language',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final RelativeRect position = RelativeRect.fromRect(
                    Rect.fromPoints(
                      button.localToGlobal(
                        const Offset(0, 0),
                        ancestor: overlay,
                      ),
                      button.localToGlobal(
                        button.size.bottomRight(Offset.zero),
                        ancestor: overlay,
                      ),
                    ),
                    Offset.zero & overlay.size,
                  );

                  showMenu<String>(
                    context: context,
                    position: position.shift(const Offset(0, 44)),
                    items: const [
                      PopupMenuItem<String>(
                        value: 'pt',
                        child: Text('Português'),
                      ),
                      PopupMenuItem<String>(
                        value: 'en',
                        child: Text('English'),
                      ),
                    ],
                  ).then((value) {
                    if (value == null) return;
                    final lang =
                        value == 'en' ? AppLanguage.en : AppLanguage.pt;
                    LanguageController.instance.setLanguage(lang);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Icon(Icons.language, color: colorScheme.secondary),
                ),
              ),
            );
          },
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
              const Icon(Icons.person, size: 18),
              const SizedBox(width: 8),
              const Text('Nome'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              const Icon(Icons.settings, size: 18),
              const SizedBox(width: 8),
              const Text('Profile'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'update_plan',
          child: Row(
            children: [
              Icon(Icons.workspace_premium_outlined, size: 18, color: colorScheme.secondary),
              const SizedBox(width: 8),
              const Text('Update plan'),
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