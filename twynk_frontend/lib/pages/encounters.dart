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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount;

                      if (constraints.maxWidth > 1024) {
                        crossAxisCount = 4;
                      } else if (constraints.maxWidth > 600) {
                        crossAxisCount = 3;
                      } else {
                        crossAxisCount = 2;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: _encounterUsers.length,
                        itemBuilder: (context, i) {
                          return UserCard(
                            user: _encounterUsers[i],
                            showActionsMenu: true,
                          );
                        },
                      );
                    },
                  ),
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
}