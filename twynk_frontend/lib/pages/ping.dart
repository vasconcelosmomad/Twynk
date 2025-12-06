// loveconnect_flutter - main.dart
// Flutter Material 3 implementation converted from the provided React + Tailwind template.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twynk_frontend/portals/app_bar.dart';
import 'package:twynk_frontend/portals/drawer.dart';
import 'package:twynk_frontend/portals/footer.dart';
import 'package:twynk_frontend/pages/encounters.dart';
import 'package:twynk_frontend/pages/snaps.dart';
import 'package:twynk_frontend/pages/chat.dart';
import 'package:twynk_frontend/pages/login.dart';
import 'package:twynk_frontend/pages/plans.dart';
import 'package:twynk_frontend/services/api_client.dart';




// ------------------ Models ------------------
class UserModel {
  final int id;
  final String name;
  final int age;
  final String location;
  final String img;
  final bool online;
  final bool recent;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.img,
    required this.online,
    required this.recent,
  });
}

class MessageModel {
  final int id;
  final int userId;
  final String text;
  final String time;
  final String type; // 'sent' | 'received'

  MessageModel({
    required this.id,
    required this.userId,
    required this.text,
    required this.time,
    required this.type,
  });
}

// ------------------ Sample Data ------------------
final List<UserModel> _users = [
  UserModel(id: 1, name: 'Ana', age: 24, location: 'São Paulo', img: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=400', online: true, recent: true),
  UserModel(id: 2, name: 'Carlos', age: 29, location: 'Rio de Janeiro', img: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=400', online: false, recent: true),
  UserModel(id: 3, name: 'Beatriz', age: 22, location: 'Belo Horizonte', img: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400', online: true, recent: false),
  UserModel(id: 4, name: 'Daniel', age: 30, location: 'Curitiba', img: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=400', online: true, recent: true),
  UserModel(id: 5, name: 'Elena', age: 26, location: 'Florianópolis', img: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&q=80&w=400', online: false, recent: false),
  UserModel(id: 6, name: 'Fernando', age: 28, location: 'Porto Alegre', img: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=400', online: false, recent: false),
  UserModel(id: 7, name: 'Gabriela', age: 25, location: 'Salvador', img: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&q=80&w=400', online: true, recent: true),
  UserModel(id: 8, name: 'Hugo', age: 31, location: 'Recife', img: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&q=80&w=400', online: true, recent: false),
];

final List<MessageModel> _messages = [
  MessageModel(id: 101, userId: 3, text: 'Oi! Tudo bem?', time: '10:30', type: 'received'),
  MessageModel(id: 102, userId: 5, text: 'Adorei sua foto!', time: 'Ontem', type: 'received'),
  MessageModel(id: 103, userId: 6, text: 'Vamos marcar algo?', time: 'Segunda', type: 'received'),
  MessageModel(id: 201, userId: 1, text: 'Olá, prazer em conhecer.', time: '09:15', type: 'sent'),
  MessageModel(id: 202, userId: 4, text: 'Claro, me chama depois.', time: 'Ontem', type: 'sent'),
];

// ------------------ Home Page ------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<UserModel> get _likesReceived => _users.sublist(0, 5);
  List<UserModel> get _likesSent => _users.sublist(3, 8);
  List<UserModel> get _matches => _users.where((u) => u.id % 2 == 1).toList();
  List<UserModel> get _recentMatches => _matches.where((m) => m.recent).toList();
  List<UserModel> get _oldMatches => _matches.where((m) => !m.recent).toList();
  List<MessageModel> get _msgsReceived => _messages.where((m) => m.type == 'received').toList();
  List<MessageModel> get _msgsSent => _messages.where((m) => m.type == 'sent').toList();

  bool _drawerOpen = false;
  int _selectedIndex = 1;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
    final bool isMobile = MediaQuery.of(context).size.width < 1024;

    setState(() => _selectedIndex = index);

    if (index == 6) {
      if (isMobile && _drawerOpen) {
        Navigator.of(context).pop();
      }
      _logout();
      return;
    }

    if (index == 0) {
      if (isMobile && _drawerOpen) {
        Navigator.of(context).pop();
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeYouTubeStyleFlutter()),
      );
      return;
    }

    if (index == 1) {
      if (isMobile && _drawerOpen) {
        Navigator.of(context).pop();
      }
      return;
    }

    if (index == 2) {
      if (isMobile && _drawerOpen) {
        Navigator.of(context).pop();
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SnapsPage()),
      );
      return;
    }

    if (index == 3) {
      if (isMobile && _drawerOpen) {
        Navigator.of(context).pop();
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatPage()),
      );
      return;
    }

    if (index == 4) {
      if (isMobile && _drawerOpen) {
        Navigator.of(context).pop();
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PlansPage()),
      );
      return;
    }

    if (isMobile && _drawerOpen) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawerScrimColor: Colors.transparent,
      onDrawerChanged: (open) => setState(() => _drawerOpen = open),
      appBar: NomirroAppBar(
        isMobile: isMobile,
        drawerOpen: _drawerOpen,
        showCreateAction: false,
      ),
      drawer: isMobile
          ? Drawer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: SidebarMenu(
                compact: false,
                showDrawerHeader: true,
                selectedIndex: _selectedIndex,
                onItemSelected: _onItemTapped,
              ),
            )
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  // Tabs
                  Material(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.primary,
                      unselectedLabelColor: Colors.grey,
                      isScrollable: true,
                      tabs: [
                        _buildTab('Recebidos', Icons.thumb_up_alt_outlined),
                        _buildTab('Enviados', Icons.thumb_up_alt_outlined),
                        _buildTab('Matches', Icons.how_to_reg),
                        _buildTab('Inbox', Icons.message),
                        _buildTab('Enviadas', Icons.access_time),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Likes Received
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoBanner(context, '12 Pessoas', 'gostam de você recentemente', Icons.favorite),
                              const SizedBox(height: 12),
                              _responsiveGrid(_likesReceived),
                            ],
                          ),
                        ),

                        // Likes Sent
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            _infoBanner(context, 'Você curtiu', '5 pessoas esta semana', Icons.send, color: Colors.blue),
                            const SizedBox(height: 12),
                            _responsiveGrid(_likesSent),
                          ]),
                        ),

                        // Matches
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            // Recent Matches header
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Row(children: [
                                Container(width: 8, height: 32, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(8))),
                                const SizedBox(width: 8),
                                Text('Matches Recentes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              ]),
                              Chip(label: Text('${_recentMatches.length} Novos'), backgroundColor: Theme.of(context).colorScheme.primaryContainer),
                            ]),

                            const SizedBox(height: 12),
                            SizedBox(
                              height: 120,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _recentMatches.isEmpty ? 1 : _recentMatches.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  if (_recentMatches.isEmpty) return const Center(child: Text('Nenhum match recente.'));
                                  return RecentMatchCard(user: _recentMatches[index]);
                                },
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Old matches grid/list
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text('Conversas Anteriores', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                ),

                                LayoutBuilder(builder: (context, constraints) {
                                  final width = constraints.maxWidth;
                                  if (width > 900) {
                                    // grid 3 columns
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 3),
                                      itemCount: _oldMatches.length,
                                      itemBuilder: (context, idx) => OldMatchRow(user: _oldMatches[idx]),
                                    );
                                  } else if (width > 600) {
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3),
                                      itemCount: _oldMatches.length,
                                      itemBuilder: (context, idx) => OldMatchRow(user: _oldMatches[idx]),
                                    );
                                  } else {
                                    return Column(children: _oldMatches.map((u) => OldMatchRow(user: u)).toList());
                                  }
                                }),
                              ]),
                            ),
                          ]),
                        ),

                        // Messages received
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text('Mensagens Recebidas', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                              const SizedBox(height: 6),
                              ..._msgsReceived.map((m) => MessageItem(msg: m)),
                              if (_msgsReceived.isEmpty) Padding(padding: const EdgeInsets.all(24.0), child: Center(child: Text('Nenhuma mensagem recebida.', style: TextStyle(color: Colors.grey[500])))),
                            ]),
                          ),
                        ),

                        // Messages sent
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text('Mensagens Enviadas', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                              const SizedBox(height: 6),
                              ..._msgsSent.map((m) => MessageItem(msg: m)),
                              if (_msgsSent.isEmpty) Padding(padding: const EdgeInsets.all(24.0), child: Center(child: Text('Nenhuma mensagem enviada.', style: TextStyle(color: Colors.grey[500])))),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  Tab _buildTab(String label, IconData icon) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _infoBanner(BuildContext context, String title, String subtitle, IconData icon, {Color? color}) {
    final bg = (color == null) ? Colors.pink[50] : Colors.blue[50];
    final ic = (color == null) ? Icons.favorite : Icons.send;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.pink.shade700)),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.pink.shade400)),
        ]),
        Icon(ic, size: 28, color: Colors.pink.shade400),
      ]),
    );
  }

  Widget _responsiveGrid(List<UserModel> data) {
    return LayoutBuilder(builder: (context, constraints) {
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
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cross, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 3/4),
        itemCount: data.length,
        itemBuilder: (context, index) => UserCard(user: data[index]),
      );
    });
  }
}

// ------------------ Widgets ------------------
class UserCard extends StatefulWidget {
  final UserModel user;
  final bool showActionsMenu;
  final Future<void> Function(UserModel user)? onMessageTap;
  final Future<void> Function(UserModel user)? onLikeTap;
  final Future<void> Function(UserModel user)? onChatTap;

  const UserCard({
    super.key,
    required this.user,
    this.showActionsMenu = false,
    this.onMessageTap,
    this.onLikeTap,
    this.onChatTap,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          Image.network(
            widget.user.img,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: Colors.grey[300]),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0.15),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Info (texto) na parte inferior
          Positioned(
            left: 12,
            bottom: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.user.name}, ${widget.user.age}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.user.location,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Badge de status (apenas círculo) no canto superior esquerdo
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: widget.user.online
                    ? Colors.green.withValues(alpha: 0.18)
                    : Colors.grey.withValues(alpha: 0.14),
                shape: BoxShape.circle,
                border: widget.user.online
                    ? Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      )
                    : null,
              ),
              child: Icon(
                Icons.circle,
                size: 8,
                color: widget.user.online ? Colors.green : Colors.grey,
              ),
            ),
          ),
          // Menu de três pontinhos no canto superior direito (sempre acima dos demais conteúdos)
          if (widget.showActionsMenu)
            Positioned(
              top: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _menuOpen = !_menuOpen;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.40),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (_menuOpen)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _menuOpen = false;
                              });
                              if (widget.onLikeTap != null) {
                                await widget.onLikeTap!(widget.user);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.thumb_up_alt_outlined,
                                    size: 20,
                                    color: Colors.pinkAccent,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Like',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _menuOpen = false;
                              });
                              if (widget.onMessageTap != null) {
                                widget.onMessageTap!(widget.user);
                              }
                              // TODO: ação Beijo
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.message_outlined,
                                    size: 20,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Msg',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _menuOpen = false;
                              });
                              if (widget.onChatTap != null) {
                                await widget.onChatTap!(widget.user);
                              }
                              // TODO: ação Chat
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 20,
                                    color: Colors.greenAccent,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Chat',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class RecentMatchCard extends StatelessWidget {
  final UserModel user;
  const RecentMatchCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        children: [
          Stack(children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.pink.shade400, Colors.orange.shade300], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.all(3),
              child: ClipOval(child: Image.network(user.img, fit: BoxFit.cover, width: 66, height: 66, errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]))),
            ),
            if (user.online)
              Positioned(bottom: 2, right: 2, child: CircleAvatar(radius: 6, backgroundColor: Colors.green, foregroundColor: Colors.white))
          ]),
          const SizedBox(height: 6),
          Flexible(child: Text(user.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class OldMatchRow extends StatelessWidget {
  final UserModel user;
  const OldMatchRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(children: [
        Stack(children: [
          CircleAvatar(radius: 28, backgroundImage: NetworkImage(user.img), backgroundColor: Colors.grey[200]),
          Positioned(bottom: 0, right: 0, child: CircleAvatar(radius: 6, backgroundColor: user.online ? Colors.green : Colors.grey, foregroundColor: Colors.white)),
        ]),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${user.name}, ${user.age}', style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 6), Row(children: [const Icon(Icons.location_on, size: 14, color: Colors.grey), const SizedBox(width: 6), Text(user.location, style: const TextStyle(color: Colors.grey))])])),
        const SizedBox(width: 8),
        InkWell(onTap: () {}, child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(999)), child: const Icon(Icons.message, color: Colors.pink))),
      ]),
    );
  }
}

class MessageItem extends StatelessWidget {
  final MessageModel msg;
  const MessageItem({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    final user = _users.firstWhere(
      (u) => u.id == msg.userId,
      orElse: () => _users.first,
    );
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(children: [
        CircleAvatar(radius: 26, backgroundImage: NetworkImage(user.img), backgroundColor: Colors.grey[200]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(user.name, style: const TextStyle(fontWeight: FontWeight.w700)), Text(msg.time, style: const TextStyle(color: Colors.grey, fontSize: 12))]),
            const SizedBox(height: 6),
            Text(msg.text, style: const TextStyle(color: Colors.black87), overflow: TextOverflow.ellipsis),
          ]),
        )
      ]),
    );
  }
}

// EOF
