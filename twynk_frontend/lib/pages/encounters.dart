import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twynk_frontend/pages/explore.dart';
import 'package:twynk_frontend/pages/proflie.dart';
import 'package:twynk_frontend/pages/chat.dart';
import 'package:twynk_frontend/pages/login.dart';
import 'package:twynk_frontend/pages/noerby.dart';
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
        MaterialPageRoute(builder: (context) => ShortsPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatPage()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PainelAssinantePage()),
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

  Future<void> _openMessageSheet(UserModel user) async {
    final rootContext = context;
    final Size size = MediaQuery.of(rootContext).size;
    final bool isMobile = size.width < 600;

    if (isMobile) {
      final theme = Theme.of(rootContext);
      final TextEditingController controller = TextEditingController();
      bool showEmojis = false;
      int selectedEmojiCategory = 0;

      const List<String> mobileEmojisSmileys = [
        '😀','😁','😂','🤣','😃','😄','😅','😉','😊','😍',
        '😘','😎','🤩','🤗','😢','😭','😱',
      ];

      const List<String> mobileEmojisGestures = [
        '👍','👎','🙏','👏',
      ];

      const List<String> mobileEmojisHearts = [
        '❤️','💔','🔥','✨',
      ];

      final List<List<String>> mobileEmojiCategories = [
        mobileEmojisSmileys,
        mobileEmojisGestures,
        mobileEmojisHearts,
      ];

      await showDialog<void>(
        context: rootContext,
        barrierDismissible: true,
        builder: (dialogContext) {
          final EdgeInsets viewInsets = MediaQuery.of(dialogContext).viewInsets;
          final EdgeInsets padding = MediaQuery.of(dialogContext).padding;

          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: padding.top,
                left: 0,
                right: 0,
                bottom: viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: size.width,
                  maxHeight: size.height * 0.8,
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    final List<IconData> categoryIcons = [
                      Icons.emoji_emotions,
                      Icons.back_hand,
                      Icons.favorite,
                    ];

                    return Material(
                      color: theme.cardColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      elevation: 8,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                    onPressed: () => Navigator.of(dialogContext).pop(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: controller,
                                maxLines: 3,
                                minLines: 1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Escreva sua mensagem...',
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
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.emoji_emotions_outlined),
                                    onPressed: () {
                                      setState(() {
                                        showEmojis = !showEmojis;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                        ScaffoldMessenger.of(rootContext)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Mensagem enviada para ${user.name}.',
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.send),
                                      label: const Text('Enviar'),
                                    ),
                                  ),
                                ],
                              ),
                              if (showEmojis) ...[
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(categoryIcons.length, (index) {
                                    final bool isSelected =
                                        selectedEmojiCategory == index;
                                    return IconButton(
                                      icon: Icon(categoryIcons[index]),
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.iconTheme.color,
                                      onPressed: () {
                                        setState(() {
                                          selectedEmojiCategory = index;
                                        });
                                      },
                                    );
                                  }),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 120,
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: mobileEmojiCategories
                                          [selectedEmojiCategory]
                                          .map((emoji) {
                                        return GestureDetector(
                                          onTap: () {
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
                                          child: Text(
                                            emoji,
                                            style: const TextStyle(fontSize: 24),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
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
    } else {
      bool showEmojis = false;
      int selectedEmojiCategory = 0;

      const List<String> desktopEmojisSmileys = [
        '😀','😁','😂','🤣','😃','😄','😅','😉','😊','😍',
        '😘','😎','🤩','🤗','😢','😭','😱',
      ];

      const List<String> desktopEmojisGestures = [
        '👍','👎','🙏','👏',
      ];

      const List<String> desktopEmojisHearts = [
        '❤️','💔','🔥','✨',
      ];

      final List<List<String>> desktopEmojiCategories = [
        desktopEmojisSmileys,
        desktopEmojisGestures,
        desktopEmojisHearts,
      ];

      await showModalBottomSheet<void>(
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
                  maxWidth: 480,
                  maxHeight: localSize.height * 0.8,
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    final List<IconData> categoryIcons = [
                      Icons.emoji_emotions,
                      Icons.back_hand,
                      Icons.favorite,
                    ];

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
                                  onPressed: () =>
                                      Navigator.of(bottomContext).pop(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: controller,
                              maxLines: 3,
                              minLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Escreva sua mensagem...',
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
                            Row(
                              children: [
                                IconButton(
                                  icon:
                                      const Icon(Icons.emoji_emotions_outlined),
                                  onPressed: () {
                                    setState(() {
                                      showEmojis = !showEmojis;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () {
                                      Navigator.of(bottomContext).pop();
                                      ScaffoldMessenger.of(rootContext)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Mensagem enviada para ${user.name}.',
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.send),
                                    label: const Text('Enviar'),
                                  ),
                                ),
                              ],
                            ),
                            if (showEmojis) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(categoryIcons.length, (index) {
                                  final bool isSelected =
                                      selectedEmojiCategory == index;
                                  return IconButton(
                                    icon: Icon(categoryIcons[index]),
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.iconTheme.color,
                                    onPressed: () {
                                      setState(() {
                                        selectedEmojiCategory = index;
                                      });
                                    },
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 120,
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: desktopEmojiCategories
                                        [selectedEmojiCategory]
                                        .map((emoji) {
                                      return GestureDetector(
                                        onTap: () {
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
                                        child: Text(
                                          emoji,
                                          style:
                                              const TextStyle(fontSize: 24),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
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
              onMessageTap: _openMessageSheet,
            );
          },
        );
      },
    );
  }
}