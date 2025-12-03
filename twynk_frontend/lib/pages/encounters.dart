import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twynk_frontend/emoji_picker.dart';
import 'package:twynk_frontend/pages/snaps.dart';
import 'package:twynk_frontend/pages/chat.dart';
import 'package:twynk_frontend/pages/login.dart';
import 'package:twynk_frontend/pages/ping.dart';
import 'package:twynk_frontend/pages/plans.dart';
import 'package:twynk_frontend/portals/footer.dart';
import 'package:twynk_frontend/portals/app_bar.dart';
import 'package:twynk_frontend/portals/drawer.dart';
import 'package:twynk_frontend/services/api_client.dart';

final List<UserModel> _encounterUsers = [
  UserModel(
    id: 1,
    name: 'Ana',
    age: 24,
    location: 'São Paulo',
    img:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=400',
    online: true,
    recent: true,
  ),
  UserModel(
    id: 2,
    name: 'Carlos',
    age: 29,
    location: 'Rio de Janeiro',
    img:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=400',
    online: false,
    recent: true,
  ),
  UserModel(
    id: 3,
    name: 'Beatriz',
    age: 22,
    location: 'Belo Horizonte',
    img:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400',
    online: true,
    recent: false,
  ),
  UserModel(
    id: 4,
    name: 'Daniel',
    age: 30,
    location: 'Curitiba',
    img:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=400',
    online: true,
    recent: true,
  ),
  UserModel(
    id: 5,
    name: 'Elena',
    age: 26,
    location: 'Florianópolis',
    img:
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&q=80&w=400',
    online: false,
    recent: false,
  ),
  UserModel(
    id: 6,
    name: 'Fernando',
    age: 28,
    location: 'Porto Alegre',
    img:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=400',
    online: false,
    recent: false,
  ),
  UserModel(
    id: 7,
    name: 'Gabriela',
    age: 25,
    location: 'Salvador',
    img:
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&q=80&w=400',
    online: true,
    recent: true,
  ),
  UserModel(
    id: 8,
    name: 'Hugo',
    age: 31,
    location: 'Recife',
    img:
        'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&q=80&w=400',
    online: true,
    recent: false,
  ),
];

class HomeYouTubeStyleFlutter extends StatefulWidget {
  const HomeYouTubeStyleFlutter({super.key});

  @override
  State<HomeYouTubeStyleFlutter> createState() => _HomeYouTubeStyleFlutterState();
}

class _HomeYouTubeStyleFlutterState extends State<HomeYouTubeStyleFlutter> {
  bool _drawerOpen = false;
  int _selectedIndex = 0;

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    ApiClient.instance.clearToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  Future<void> _showChatInviteAlert(UserModel user) async {
    final theme = Theme.of(context);

    Future.delayed(const Duration(minutes: 1), () {
      if (!mounted) return;
      _showChatTimeoutAlert();
    });

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final padding = MediaQuery.of(dialogContext).padding;
        final Size size = MediaQuery.of(dialogContext).size;
        final route = ModalRoute.of(dialogContext);

        Future.delayed(const Duration(seconds: 6), () {
          if (route?.isActive ?? false) {
            route?.navigator?.pop();
          }
        });

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              top: padding.top + 16,
              left: 16,
              right: 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.width < 600 ? size.width - 32 : 360,
              ),
              child: Material(
                color: theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  ),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(user.img),
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Chat com ${user.name}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Aguarde o convite ser aceito.',
                              style: theme.textTheme.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Fechar',
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showChatTimeoutAlert() async {
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final padding = MediaQuery.of(dialogContext).padding;
        final Size size = MediaQuery.of(dialogContext).size;
        final route = ModalRoute.of(dialogContext);

        Future.delayed(const Duration(seconds: 6), () {
          if (route?.isActive ?? false) {
            route?.navigator?.pop();
          }
        });

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              top: padding.top + 16,
              left: 16,
              right: 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.width < 600 ? size.width : 480,
              ),
              child: Material(
                color: Colors.orange.withValues(alpha: 0.95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: Colors.orange,
                  ),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Aviso!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Convite não respondido.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLikeSentAlert(String userName) {
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final padding = MediaQuery.of(dialogContext).padding;
        final Size size = MediaQuery.of(dialogContext).size;
        final route = ModalRoute.of(dialogContext);

        Future.delayed(const Duration(seconds: 6), () {
          if (route?.isActive ?? false) {
            route?.navigator?.pop();
          }
        });

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              top: padding.top + 16,
              left: 16,
              right: 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.width < 600 ? size.width : 480,
              ),
              child: Material(
                color: Colors.green.withValues(alpha: 0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: Colors.green,
                  ),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.thumb_up_alt_outlined,
                        color: theme.colorScheme.primary,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Like enviado para $userName.',
                          style: theme.textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 6) {
      _logout();
      return;
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SnapsPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatPage()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PlansPage()),
      );
    } else if (index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PlansPage()),
      );
    } else if (MediaQuery.of(context).size.width < 1024) {
      Navigator.of(context).pop();
    }
  }

  void _showMessageSentAlert(String userName) {
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final padding = MediaQuery.of(dialogContext).padding;
        final Size size = MediaQuery.of(dialogContext).size;
        final route = ModalRoute.of(dialogContext);

        Future.delayed(const Duration(seconds: 6), () {
          if (route?.isActive ?? false) {
            route?.navigator?.pop();
          }
        });

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              top: padding.top + 16,
              left: 16,
              right: 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.width < 600 ? size.width : 480,
              ),
              child: Material(
                color: Colors.green.withValues(alpha: 0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: Colors.green,
                  ),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Mensagem enviada para $userName.',
                          style: theme.textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: unused_element
  Future<void> _openMessageSheet(UserModel user) async {
    final rootContext = context;
    final Size size = MediaQuery.of(rootContext).size;
    final bool isMobile = size.width < 600;

    if (isMobile) {
      final theme = Theme.of(rootContext);
      final TextEditingController controller = TextEditingController();
      bool showEmojis = false;

      final bool? messageSent = await showModalBottomSheet<bool>(
        context: rootContext,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        builder: (bottomContext) {
          final EdgeInsets viewInsets = MediaQuery.of(bottomContext).viewInsets;
          final Size localSize = MediaQuery.of(bottomContext).size;

          return Padding(
            padding: EdgeInsets.only(bottom: viewInsets.bottom),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: localSize.width,
                  maxHeight: localSize.height * 0.8,
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(user.img),
                                  backgroundColor: Colors.grey[300],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        user.name,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(bottomContext).pop();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.dividerColor,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: TextField(
                                      controller: controller,
                                      maxLines: 3,
                                      minLines: 1,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Escreva sua mensagem...',
                                        filled: false,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.emoji_emotions_outlined,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showEmojis = !showEmojis;
                                            });
                                          },
                                        ),
                                        const Spacer(),
                                        FilledButton.icon(
                                          onPressed: () {
                                            Navigator.of(bottomContext).pop(true);
                                          },
                                          icon: const Icon(Icons.send),
                                          label: const Text('Enviar'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Segurança: Evite informar dados de contato particular.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (showEmojis) ...[
                              const SizedBox(height: 8),
                              EmojiPicker(
                                onEmojiSelected: (emoji) {
                                  final text = controller.text;
                                  final selection = controller.selection;
                                  final int insertAt = selection.isValid
                                      ? selection.start
                                      : text.length;
                                  final newText = text.replaceRange(
                                    insertAt,
                                    insertAt,
                                    emoji,
                                  );
                                  controller.text = newText;
                                  controller.selection =
                                      TextSelection.collapsed(
                                    offset: insertAt + emoji.length,
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );

      // Após o drawer ser completamente fechado, então fechamos o teclado
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      if (messageSent == true) {
        _showMessageSentAlert(user.name);
      }
    } else {
      bool showEmojis = false;

      final bool? messageSent = await showModalBottomSheet<bool>(
        context: rootContext,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        builder: (bottomContext) {
          final theme = Theme.of(bottomContext);
          final Size localSize = MediaQuery.of(bottomContext).size;
          final TextEditingController controller = TextEditingController();
          final EdgeInsets viewInsets =
              MediaQuery.of(bottomContext).viewInsets;

          return Padding(
            padding: EdgeInsets.only(bottom: viewInsets.bottom),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 560,
                  maxHeight: localSize.height * 0.8,
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(user.img),
                                  backgroundColor: Colors.grey[300],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        user.name,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(bottomContext).pop();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white10
                                    : const Color(0xFFF6EAFE),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.dividerColor,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: TextField(
                                      controller: controller,
                                      maxLines: 3,
                                      minLines: 1,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Escreva sua mensagem...',
                                        filled: false,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.emoji_emotions_outlined,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showEmojis = !showEmojis;
                                            });
                                          },
                                        ),
                                        const Spacer(),
                                        FilledButton.icon(
                                          onPressed: () {
                                            Navigator.of(bottomContext).pop(true);
                                          },
                                          icon: const Icon(Icons.send),
                                          label: const Text('Enviar'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Segurança: Evite informar dados de contato particular.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (showEmojis) ...[
                              const SizedBox(height: 8),
                              EmojiPicker(
                                onEmojiSelected: (emoji) {
                                  final text = controller.text;
                                  final selection = controller.selection;
                                  final int insertAt = selection.isValid
                                      ? selection.start
                                      : text.length;
                                  final newText = text.replaceRange(
                                    insertAt,
                                    insertAt,
                                    emoji,
                                  );
                                  controller.text = newText;
                                  controller.selection =
                                      TextSelection.collapsed(
                                    offset: insertAt + emoji.length,
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );

      if (!mounted) return;
      FocusScope.of(context).unfocus();
      if (messageSent == true) {
        _showMessageSentAlert(user.name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawerScrimColor: Colors.transparent,
      onDrawerChanged: (open) => setState(() => _drawerOpen = open),

      appBar: NomirroAppBar(
        isMobile: isMobile,
        drawerOpen: _drawerOpen,
        showCreateAction: false,
        enableSearch: true,
      ),

      drawer: !isMobile
          ? null
          : Drawer(
              child: SidebarMenu(
              compact: false,
              showDrawerHeader: true,
              selectedIndex: _selectedIndex,
              onItemSelected: _onItemTapped,
            )),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SIDEBAR DESKTOP ---
          if (!isMobile)
            Container(
              width: 240,
              color: Theme.of(context).cardColor,
              child: SidebarMenu(
                compact: false,
                showDrawerHeader: false,
                selectedIndex: _selectedIndex,
                onItemSelected: _onItemTapped,
              ),
            ),

          // --- CONTEÚDO PRINCIPAL ---
          Expanded(
            child: Column(
              children: [

                // --- GRID DE CARDS ---
                Expanded(
                  child: _responsiveGrid(_encounterUsers),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: isMobile
          ? Footer(
              currentIndex: _selectedIndex > 4 ? 0 : _selectedIndex,
              onTap: _onItemTapped,
            )
          : null,
    );
  }

  Widget _responsiveGrid(List<UserModel> data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int cross = 2;
        if (width > 1200) {
          cross = 5;
        } else if (width > 900) {
          cross = 4;
        } else if (width > 600) {
          cross = 3;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cross,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return UserCard(
              user: data[index],
              showActionsMenu: true,
              onMessageTap: _showChatInviteAlert,
              onLikeTap: (user) async {
                _showLikeSentAlert(user.name);
              },
            );
          },
        );
      },
    );
  }
}