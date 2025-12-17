import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../services/language_controller.dart';
import '../services/api_client.dart';
import '../pages/login.dart';
import '../pages/channel_panel.dart';
import '../pages/proflie.dart';
import '../providers/app_provider.dart';

class NomirroAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isMobile;
  final bool drawerOpen;
  final bool showCreateAction;
  final bool enableSearch;

  const NomirroAppBar({
    super.key,
    required this.isMobile,
    this.drawerOpen = false,
    this.showCreateAction = true,
    this.enableSearch = true,
  });

  @override
  State<NomirroAppBar> createState() => _NomirroAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NomirroAppBarState extends State<NomirroAppBar> {
  bool _searchActive = false;

  Future<void> _handleLogout() async {
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
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: null,
      title: _buildTitle(context),
      actions: _buildActions(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    // MOBILE
    if (widget.isMobile && widget.enableSearch && _searchActive) {
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
        if (widget.enableSearch)
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 40,
            child: const SearchFormFlutter(),
          ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color textColor =
        theme.textTheme.bodyMedium?.color ?? colorScheme.onSurface;
    if (widget.isMobile && _searchActive) {
      return [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() => _searchActive = false),
        ),
      ];
    }

    return [
      if (widget.isMobile && widget.enableSearch)
        IconButton(
          icon: const Icon(Icons.search),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          onPressed: () => setState(() => _searchActive = true),
        ),
      const SizedBox(width: 16.0),
      if (widget.showCreateAction)
        if (widget.isMobile)
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ExplorerPage(openUploadOnStart: true),
                ),
              );
            },
            icon: Icon(
              Icons.add,
              size: 22,
              color: textColor,
            ),
            tooltip: 'Criar',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
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
              icon: Icon(
                Icons.add,
                color: colorScheme.onPrimary,
              ),
              label: const Text('Criar'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                foregroundColor: colorScheme.onPrimary,
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
      const SizedBox(width: 8.0),
      // Use a Builder to get the context of the button for positioning the menu.
      Center(
        child: Builder(
          builder: (context) {
            return Tooltip(
            message: 'Idioma / Language',
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                final RenderBox button = context.findRenderObject() as RenderBox;
                final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                final RelativeRect position = RelativeRect.fromRect(
                  Rect.fromPoints(
                    button.localToGlobal(const Offset(0, 0), ancestor: overlay),
                    button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                  ),
                  Offset.zero & overlay.size,
                );

                showMenu<String>(
                  context: context,
                  position: position.shift(const Offset(0, 44)), // Adjust offset as needed
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
                  if (value == null) return; // Menu dismissed
                  final lang = value == 'en' ? AppLanguage.en : AppLanguage.pt;
                  LanguageController.instance.setLanguage(lang);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.language, color: colorScheme.secondary),
              ),
            ),
          );
        },
      )),
      const SizedBox(width: 16.0),
      _buildUserMenu(context),
      const SizedBox(width: 16.0),
    ];
  }

  Widget _buildUserMenu(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // Use a Builder to get the context of the button for positioning the menu.
    return Center(
      child: Builder(
      builder: (context) {
          final appProvider = Provider.of<AppProvider>(context);
          final user = appProvider.userProvider.user;
          final String userName;
          if (user == null) {
            userName = 'Conta';
          } else if ((user.apelido ?? '').isNotEmpty) {
            userName = user.apelido!;
          } else if (user.nome.isNotEmpty) {
            userName = user.nome;
          } else {
            userName = user.email;
          }
          // Resolve latest profile media URL, if any
          String? profileUrl;
          final mediaList = appProvider.mediaProvider.userMedia;
          if (mediaList.isNotEmpty) {
            final profileMedias = mediaList
                .where((m) => m.isProfile && (m.url).isNotEmpty)
                .toList();
            if (profileMedias.isNotEmpty) {
              // Backend returns media ordered by created_at desc,
              // so first item is the mais recente.
              profileUrl = profileMedias.first.url;
            }
          }

          return Tooltip(
            message: 'User Menu',
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                final RenderBox button = context.findRenderObject() as RenderBox;
                final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                final RelativeRect position = RelativeRect.fromRect(
                  Rect.fromPoints(
                    button.localToGlobal(const Offset(0, 0), ancestor: overlay),
                    button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                  ),
                  Offset.zero & overlay.size,
                );

                final navigator = Navigator.of(context);

                showMenu<String>(
                  context: context,
                  position: position.shift(const Offset(0, 44)), // Adjust offset as needed
                  items: [
                    PopupMenuItem<String>(
                      value: 'name',
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 18, color: colorScheme.onSurface),
                          SizedBox(width: 8),
                          Text(userName),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.settings, size: 18, color: colorScheme.onSurface),
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
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 18, color: colorScheme.error),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                ).then((value) {
                  if (value == null) return; // Menu dismissed
                  if (value == 'logout') {
                    _handleLogout();
                    return;
                  }
                  if (value == 'profile') {
                    navigator.push(
                      MaterialPageRoute(
                        builder: (_) => const PainelAssinantePage(),
                      ),
                    );
                    return;
                  }
                  // Handle other selections if needed
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      profileUrl != null ? NetworkImage(profileUrl) : null,
                  child: profileUrl == null
                      ? const Icon(Icons.person, size: 18, color: Colors.white)
                      : null,
                ),
              ),
            ),
          );
        },
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
                const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
            hintText: 'Search',
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(40, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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