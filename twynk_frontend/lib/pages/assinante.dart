import 'package:flutter/material.dart';
import '../themes/twynk_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../portals/app_bar.dart';
import '../portals/drawer.dart';
import '../portals/footer.dart';
import 'shorts.dart';
import 'photo_edit.dart';
import 'login.dart';
import 'twynks.dart';
import '../services/api_client.dart';

class PainelAssinantePage extends StatefulWidget {
  const PainelAssinantePage({super.key});

  @override
  State<PainelAssinantePage> createState() => _PainelAssinantePageState();
}

class _PainelAssinantePageState extends State<PainelAssinantePage> {
  String activeTab = 'recebidas';
  int selectedDrawerIndex = 3;
  bool _drawerOpen = false;

  void _onBottomNavTap(int index) {
    final isMobile = MediaQuery.of(context).size.width < 1024;
    setState(() => selectedDrawerIndex = index);
    if (index == 0) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeYouTubeStyleFlutter()));
      return;
    }
    if (index == 1) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ShortsPage()));
      return;
    }
    if (index == 5) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      _logout();
      return;
    }
    if (index == 3) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      return;
    }
    if (isMobile && _drawerOpen) Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1024;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawerScrimColor: Colors.transparent,
      appBar: NomirroAppBar(isMobile: isMobile, drawerOpen: _drawerOpen),
      onDrawerChanged: (open) => setState(() => _drawerOpen = open),
      drawer: isMobile
          ? Drawer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: SidebarMenu(
                compact: false,
                showDrawerHeader: true,
                selectedIndex: selectedDrawerIndex,
                onItemSelected: (index) => _onBottomNavTap(index),
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
                selectedIndex: selectedDrawerIndex,
                onItemSelected: _onBottomNavTap,
              ),
            ),
          Expanded(
            child: SafeArea(
              child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;

          // Use a centered max width like the original Tailwind layout
          final maxContentWidth = width > 1200 ? 1100.0 : width;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topCardsSection(width),
                    const SizedBox(height: 20),
                    _tabsSection(width),
                    const SizedBox(height: 20),
                    _sectionHeader('Últimas visitas recebidas'),
                    const SizedBox(height: 10),
                    _visitorsGrid(width, [
                      _visitorCard('Cassiana', 29, '8960 Km', 'https://i.pravatar.cc/150?u=cassiana'),
                      _visitorCard('Juliane', 37, '8628 Km', 'https://i.pravatar.cc/150?u=juliane'),
                      _visitorCard('Lívia Andrade', 22, '8974 Km', 'https://i.pravatar.cc/150?u=livia'),
                    ]),
                    const SizedBox(height: 20),
                    _sectionHeader('Últimas visitas realizadas'),
                    const SizedBox(height: 10),
                    _visitorsGrid(width, [
                      _visitorCard('Paula s2', 42, '8922 Km', 'https://i.pravatar.cc/150?u=paula'),
                      _visitorCard('Juliane', 37, '8628 Km', 'https://i.pravatar.cc/150?u=juliane'),
                    ]),
                    const SizedBox(height: 20),
                    _sectionHeader('Sugestões de perfis:'),
                    const SizedBox(height: 10),
                    _visitorsGrid(width, [
                      _visitorCard('Anchita mutunta', 46, '60 Km', 'https://i.pravatar.cc/150?u=anchita'),
                      _visitorCard('Kiara', 28, '60 Km', 'https://i.pravatar.cc/150?u=kiara1'),
                      _visitorCard('Kiara', 28, '60 Km', 'https://i.pravatar.cc/150?u=kiara2'),
                      _visitorCard('Miranda', 29, '60 Km', 'https://i.pravatar.cc/150?u=miranda'),
                    ]),
                  ],
                ),
              ),
            ),
          );
        }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? Footer(
              currentIndex: selectedDrawerIndex > 3 ? 0 : selectedDrawerIndex,
              onTap: _onBottomNavTap,
            )
          : null,
    );
  }

  // Top cards: responsive - side-by-side on wide screens, stacked on small
  Widget _topCardsSection(double width) {
    final isWide = width >= 800;

    final leftCard = Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=vasconcelos'),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _actionItem(Icons.search, 'Buscar perfis'),
                _actionItem(Icons.camera_alt, 'Editar fotos', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PhotoMasterApp(initialView: 'edit-photos')));
                }),
                _actionItem(Icons.edit, 'Editar perfil'),
                _actionItem(Icons.settings, 'Configurar busca'),
              ],
            ),
          )
        ],
      ),
    );

    final rightCard = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Olá Vasconcelos!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Dica:', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(40, 24), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text('(ver +)', style: TextStyle(color: NomirroColors.primary, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Acesse seu perfil com frequência, para que ele fique nas primeiras posições das buscas e seja mais visitado.',
            style: TextStyle(fontSize: 13),
          )
        ],
      ),
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: leftCard),
          const SizedBox(width: 12),
          Expanded(flex: 4, child: rightCard),
        ],
      );
    } else {
      return Column(
        children: [
          leftCard,
          const SizedBox(height: 12),
          rightCard,
        ],
      );
    }
  }

  Widget _actionItem(IconData icon, String label, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(label, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  // Tabs section: responsive grid for stats
  Widget _tabsSection(double width) {
    return Container(
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Row(children: [
            _tabButton('recebidas', 'Interações Recebidas'),
            _tabButton('realizadas', 'Interações Realizadas'),
          ]),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _statsGrid(width, activeTab == 'recebidas'
                ? [
                    _statItem(Icons.star, 'Favoritos', '0'),
                    _statItem(Icons.mail, 'Mensagens', '7'),
                    _statItem(Icons.thumb_up, 'Likes', '3'),
                    _statItem(Icons.visibility, 'Visitas', '0'),
                  ]
                : [
                    _statItem(Icons.star_border, 'Favoritos', '2'),
                    _statItem(Icons.search, 'Mensagens', '6'),
                    _statItem(Icons.thumb_up_alt_outlined, 'Likes', '3'),
                    _statItem(Icons.history, 'Visitas', '0'),
                  ]),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String id, String label) {
    final bool selected = activeTab == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => activeTab = id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? NomirroColors.accentLight.withAlpha(40) : Colors.white,
            border: Border(
              bottom: BorderSide(color: selected ? NomirroColors.primary : Colors.transparent, width: 2),
            ),
          ),
          child: Center(child: Text(label, style: TextStyle(color: selected ? NomirroColors.primary : Colors.grey, fontWeight: FontWeight.w600))),
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF1F5F9)),
            child: Icon(icon, size: 20, color: NomirroColors.primary),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statsGrid(double width, List<Widget> stats) {
    int crossAxisCount;
    double childAspectRatio;

    if (width >= 1200) {
      crossAxisCount = 4;
      childAspectRatio = 2.8;
    } else if (width >= 800) {
      crossAxisCount = 2;
      childAspectRatio = 3.0;
    } else if (width >= 600) {
      crossAxisCount = 2;
      childAspectRatio = 3.4;
    } else {
      crossAxisCount = 1;
      childAspectRatio = 3.2;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: stats,
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(60, 28), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: const Text('ver mais', style: TextStyle(color: NomirroColors.primary)),
        )
      ],
    );
  }

  Widget _visitorsGrid(double width, List<Widget> cards) {
    int crossAxisCount;
    double childAspectRatio = 3.2;

    if (width >= 1400) {
      crossAxisCount = 4;
    } else if (width >= 1000) {
      crossAxisCount = 3;
    } else if (width >= 600) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: cards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => cards[index],
    );
  }

  Widget _visitorCard(String name, int age, String distance, String image) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: _boxDecoration(),
        child: Row(
          children: [
            CircleAvatar(radius: 28, backgroundImage: NetworkImage(image), backgroundColor: Colors.grey[200]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('$age anos', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_pin, size: 18, color: Colors.grey),
                const SizedBox(height: 4),
                Text(distance, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    );
  }
}
