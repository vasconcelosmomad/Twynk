import 'package:flutter/material.dart';
import 'package:twynk_frontend/portals/drawer.dart';
import 'package:twynk_frontend/portals/footer.dart';
import 'package:twynk_frontend/pages/ping.dart';
import 'package:twynk_frontend/pages/snaps.dart';
import 'package:twynk_frontend/pages/chat.dart';
import 'package:twynk_frontend/pages/plans.dart';
import 'package:twynk_frontend/pages/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  String activeTab = 'dadosGerais';
  late TabController _tabController;
  int _selectedIndex = 0;

  // Dados simulados do usuário para um perfil read-only
  final Map<String, dynamic> userData = {
    'premiumStatus': "Assinante Premium!",
    'lastAccess': "28/11/2025 às 14:30",
    'nickname': "Vasconcelos",
    'age': 35,
    'mainPhoto': "https://placehold.co/400x400/10b981/ffffff?text=V",
    'userId': "VASC-MZ-9034",
    'dadosGerais': {
      'sobre': "Atraente e simpático. Gosto de longas caminhadas, um bom livro e de cozinhar. Valorizo a honestidade e o bom humor.",
      'procura': ["namoro sério", "amizade"],
      'dataNascimento': "13/02/1990",
      'euSou': "Homem",
      'sexualidade': "Heterossexual",
      'estadoCivil': "Solteiro",
      'filhos': "1",
      'escolaridade': "Superior incompleto",
      'profissao': "Técnico de Farmácia",
      'religiao': "Não responder",
      'humor': "Amigável",
      'signo': "Aquário",
      'pais': "Moçambique",
      'provincia': "Nampula",
      'cidade': "Macira",
      'cep': "—",
      'moraCom': "Sozinho",
      'corPele': "Negra",
      'corOlhos': "Não responder",
      'corCabelos': "Não responder",
      'peso': "Não responder",
      'altura': "Não responder",
      'praticaEsporte': "Não responder",
      'fuma': "Não fumo",
      'bebe': "Ocasionalmente",
      'comoMeConsideroFisicamente': "Atraente e simpático.",
    },
    'fotos': [
      "https://placehold.co/300x200/fbbf24/000?text=Foto+1",
      "https://placehold.co/300x200/ef4444/000?text=Foto+2",
      "https://placehold.co/300x200/3b82f6/000?text=Foto+3",
      "https://placehold.co/300x200/10b981/000?text=Foto+4",
    ],
    'videosCurtos': [
      {'id': 1, 'title': "Dia na Praia", 'url': "https://placehold.co/300x400/c084fc/000?text=Vídeo+Curto+1"},
      {'id': 2, 'title': "Novo Hobby", 'url': "https://placehold.co/300x400/f472b6/000?text=Vídeo+Curto+2"},
      {'id': 3, 'title': "Comida Favorita", 'url': "https://placehold.co/300x400/60a5fa/000?text=Vídeo+Curto+3"},
    ],
    'interacoes': {
      'recebidas': {'likes': 124, 'mensagens': 42},
      'enviadas': {'likes': 89, 'mensagens': 15}
    }
  };

  final List<Map<String, dynamic>> tabs = [
    {'id': 'dadosGerais', 'label': 'Dados Gerais', 'icon': Icons.person},
    {'id': 'fotos', 'label': 'Fotos', 'icon': Icons.photo},
    {'id': 'videosCurtos', 'label': 'Vídeos Curtos', 'icon': Icons.video_library},
    {'id': 'interacoes', 'label': 'Interações', 'icon': Icons.flash_on},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        activeTab = tabs[_tabController.index]['id'];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 6) {
      Navigator.of(context).pop();
      return;
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
      // Já está na página de perfil (ping)
      return;
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SnapsPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChatPage()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PlansPage()),
      );
    } else if (index == 5) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PlansPage()),
      );
    } else if (MediaQuery.of(context).size.width < 1024) {
      Navigator.of(context).pop();
    }
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
              builder: (_) => const ProfilePage(),
            ),
          );
        } else if (value == 'plans') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PlansPage(),
            ),
          );
        } else if (value == 'logout') {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const LoginPage(),
            ),
            (route) => false,
          );
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color secondaryTextColor = isDark
        ? Colors.white70
        : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
            Colors.black54;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
          ),
        ),
        title: const Text(''),
        actions: [
          _buildUserMenu(context),
          const SizedBox(width: 12),
        ],
      ),
      drawer: isMobile
          ? Drawer(
              backgroundColor: theme.scaffoldBackgroundColor,
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
          if (isDesktop)
            Container(
              width: 240,
              color: theme.cardColor,
              child: SidebarMenu(
                compact: false,
                showDrawerHeader: false,
                selectedIndex: _selectedIndex,
                onItemSelected: _onItemTapped,
              ),
            ),
          Expanded(
            child: SafeArea(
              child: DefaultTabController(
                length: tabs.length,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: _buildProfileHeader(isMobile, isTablet),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _TabBarDelegate(
                          TabBar(
                            controller: _tabController,
                            tabs: tabs.map((tab) {
                              return Tab(
                                icon: Icon(tab['icon'], size: 20),
                                text: tab['label'],
                              );
                            }).toList(),
                            labelColor: theme.colorScheme.primary,
                            unselectedLabelColor: secondaryTextColor,
                            indicatorColor: theme.colorScheme.primary,
                            indicatorWeight: 4,
                            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                            unselectedLabelStyle:
                                const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDadosGerais(),
                      _buildFotos(),
                      _buildVideosCurtos(),
                      _buildInteracoes(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: (isMobile || isTablet)
          ? Footer(
              currentIndex: _selectedIndex > 4 ? 0 : _selectedIndex,
              onTap: _onItemTapped,
            )
          : null,
    );
  }

  Widget _buildProfileHeader(bool isMobile, bool isTablet) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color secondaryTextColor = isDark
        ? Colors.white70
        : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
            Colors.black54;
    final Color primaryTextColor =
        theme.textTheme.bodyLarge?.color ?? Colors.black87;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withAlpha(80),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Foto principal
              Container(
                height: isMobile ? 112 : 128,
                width: isMobile ? 112 : 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    userData['mainPhoto'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: secondaryTextColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: isMobile ? 16 : 24),
              // Informações do perfil
              Expanded(
                child: Column(
                  crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData['nickname'],
                      style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ) ??
                          TextStyle(
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Status Premium
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            userData['premiumStatus'],
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Último acesso (responsivo, evita overflow)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: secondaryTextColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Último Acesso: ${userData['lastAccess']}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: secondaryTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // ID do usuário
                    Text(
                      'ID: ${userData['userId']}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDadosGerais() {
    final dados = userData['dadosGerais'] as Map<String, dynamic>;
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width >= 900; // desktop / tablet landscape
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Sobre
          _buildSection(
            'Sobre ${userData['nickname']}',
            [
              Text(
                '"${dados['sobre']}"',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estou à Procura de uma Pessoa para:',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: (dados['procura'] as List<String>).map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.green.shade800,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Dados Pessoais (esquerda) + Localização/Aparência/Hábitos (direita quando isWide)
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildSection(
                    'Dados Pessoais',
                    [
                      _buildDetailItem(Icons.tag, 'Apelido', userData['nickname']),
                      _buildDetailItem(Icons.tag, 'Signo', dados['signo']),
                      _buildDetailItem(Icons.cake, 'Data de Nascimento', '${dados['dataNascimento']} (${userData['age']} anos)'),
                      _buildDetailItem(Icons.person, 'Eu sou', dados['euSou']),
                      _buildDetailItem(Icons.flash_on, 'Sexualidade', dados['sexualidade']),
                      _buildDetailItem(Icons.favorite, 'Estado Civil', dados['estadoCivil']),
                      _buildDetailItem(Icons.child_care, 'Filhos', dados['filhos']),
                      _buildDetailItem(Icons.school, 'Escolaridade', dados['escolaridade']),
                      _buildDetailItem(Icons.work, 'Profissão', dados['profissao']),
                      _buildDetailItem(Icons.handshake, 'Religião', dados['religiao']),
                      _buildDetailItem(Icons.sentiment_satisfied, 'Humor', dados['humor']),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildSection(
                        'Localização',
                        [
                          _buildDetailItem(Icons.public, 'País', dados['pais']),
                          _buildDetailItem(Icons.location_on, 'Província/Estado', dados['provincia']),
                          _buildDetailItem(Icons.location_city, 'Cidade', dados['cidade']),
                          _buildDetailItem(Icons.home, 'Mora com', dados['moraCom']),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        'Aparência',
                        [
                          _buildDetailItem(Icons.visibility, 'Cor da Pele', dados['corPele']),
                          _buildDetailItem(Icons.visibility, 'Cor dos Olhos', dados['corOlhos']),
                          _buildDetailItem(Icons.visibility, 'Cor dos Cabelos', dados['corCabelos']),
                          _buildDetailItem(Icons.monitor_weight, 'Peso', dados['peso']),
                          _buildDetailItem(Icons.height, 'Altura', dados['altura']),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            _buildSection(
              'Dados Pessoais',
              [
                _buildDetailItem(Icons.tag, 'Apelido', userData['nickname']),
                _buildDetailItem(Icons.tag, 'Signo', dados['signo']),
                _buildDetailItem(Icons.cake, 'Data de Nascimento', '${dados['dataNascimento']} (${userData['age']} anos)'),
                _buildDetailItem(Icons.person, 'Eu sou', dados['euSou']),
                _buildDetailItem(Icons.flash_on, 'Sexualidade', dados['sexualidade']),
                _buildDetailItem(Icons.favorite, 'Estado Civil', dados['estadoCivil']),
                _buildDetailItem(Icons.child_care, 'Filhos', dados['filhos']),
                _buildDetailItem(Icons.school, 'Escolaridade', dados['escolaridade']),
                _buildDetailItem(Icons.work, 'Profissão', dados['profissao']),
                _buildDetailItem(Icons.handshake, 'Religião', dados['religiao']),
                _buildDetailItem(Icons.sentiment_satisfied, 'Humor', dados['humor']),
              ],
            ),
            _buildSection(
              'Localização',
              [
                _buildDetailItem(Icons.public, 'País', dados['pais']),
                _buildDetailItem(Icons.location_on, 'Província/Estado', dados['provincia']),
                _buildDetailItem(Icons.location_city, 'Cidade', dados['cidade']),
                _buildDetailItem(Icons.home, 'Mora com', dados['moraCom']),
              ],
            ),
            _buildSection(
              'Aparência',
              [
                _buildDetailItem(Icons.visibility, 'Cor da Pele', dados['corPele']),
                _buildDetailItem(Icons.visibility, 'Cor dos Olhos', dados['corOlhos']),
                _buildDetailItem(Icons.visibility, 'Cor dos Cabelos', dados['corCabelos']),
                _buildDetailItem(Icons.monitor_weight, 'Peso', dados['peso']),
                _buildDetailItem(Icons.height, 'Altura', dados['altura']),
              ],
            ),
          ],

          // Hábitos + Auto-descrição
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildSection(
                    'Hábitos',
                    [
                      _buildDetailItem(Icons.sports_basketball, 'Pratica Esporte', dados['praticaEsporte']),
                      _buildDetailItem(Icons.smoking_rooms, 'Fuma', dados['fuma']),
                      _buildDetailItem(Icons.local_bar, 'Bebe', dados['bebe']),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSection(
                    'Como me considero fisicamente',
                    [
                      Text(
                        dados['comoMeConsideroFisicamente'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            _buildSection(
              'Hábitos',
              [
                _buildDetailItem(Icons.sports_basketball, 'Pratica Esporte', dados['praticaEsporte']),
                _buildDetailItem(Icons.smoking_rooms, 'Fuma', dados['fuma']),
                _buildDetailItem(Icons.local_bar, 'Bebe', dados['bebe']),
              ],
            ),
            _buildSection(
              'Como me considero fisicamente',
              [
                Text(
                  dados['comoMeConsideroFisicamente'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFotos() {
    final fotos = userData['fotos'] as List<String>;
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (width >= 1200) {
      crossAxisCount = 4; // desktop grande
    } else if (width >= 900) {
      crossAxisCount = 3; // desktop médio / large tablet
    } else if (width >= 600) {
      crossAxisCount = 2; // tablet / mobile landscape
    } else {
      crossAxisCount = 1; // mobile estreito (coluna única)
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Álbum de Fotos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 16),
          if (fotos.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              child: Text(
                'O usuário ainda não publicou fotos.',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: fotos.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      fotos[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 48, color: Colors.grey.shade600),
                              const SizedBox(height: 8),
                              Text(
                                'Imagem Indisponível',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildVideosCurtos() {
    final videos = userData['videosCurtos'] as List<Map<String, dynamic>>;
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (width >= 1200) {
      crossAxisCount = 3;
    } else if (width >= 800) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vídeos Curtos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 16),
          if (videos.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              child: Text(
                'O usuário ainda não publicou vídeos curtos.',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4,
              ),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            color: Colors.grey.shade200,
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                video['url'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.video_library, size: 48, color: Colors.grey.shade600),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Vídeo Indisponível',
                                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha:0.4),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.play_circle_outline, size: 48, color: Colors.white),
                                    const SizedBox(height: 8),
                                    Text(
                                      video['title'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
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
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInteracoes() {
    final interacoes = userData['interacoes'] as Map<String, dynamic>;
    final recebidas = interacoes['recebidas'] as Map<String, dynamic>;
    final enviadas = interacoes['enviadas'] as Map<String, dynamic>;
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width >= 900; // desktop / tablet landscape
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInteractionCard(
                    'Interações Recebidas',
                    recebidas['likes'],
                    recebidas['mensagens'],
                    true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInteractionCard(
                    'Interações Enviadas',
                    enviadas['likes'],
                    enviadas['mensagens'],
                    false,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                _buildInteractionCard(
                  'Interações Recebidas',
                  recebidas['likes'],
                  recebidas['mensagens'],
                  true,
                ),
                const SizedBox(height: 16),
                _buildInteractionCard(
                  'Interações Enviadas',
                  enviadas['likes'],
                  enviadas['mensagens'],
                  false,
                ),
              ],
            ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    final theme = Theme.of(context);
    final Color accentColor = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionCard(String title, int likes, int messages, bool isReceived) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isReceived ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isReceived ? Colors.green.shade300 : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on, size: 24, color: Colors.green.shade600),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, size: 20, color: Colors.red.shade500),
                    const SizedBox(width: 8),
                    Text(
                      'Likes',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$likes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.message, size: 20, color: Colors.blue.shade500),
                    const SizedBox(width: 8),
                    Text(
                      'Mensagens',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$messages',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade600,
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

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _TabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return false;
  }
}