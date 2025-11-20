import 'package:flutter/material.dart';
import '../portals/app_bar_copy.dart';
import '../portals/drawer.dart';
import '../portals/footer.dart';
import 'shorts.dart';
import '../themes/default_light.dart';
import '../themes/default_dark.dart';

// --- MODELO DE DADOS ---

/// Representa uma única foto na galeria.
class Photo {
  final int id;
  final String url;
  final String title;
  final bool isProfile;
  final bool isPrivate;

  Photo({
    required this.id,
    required this.url,
    required this.title,
    required this.isProfile,
    required this.isPrivate,
  });

  // Método para criar cópias com propriedades alteradas, facilitando a atualização de estado.
  Photo copyWith({
    bool? isProfile,
    bool? isPrivate,
  }) {
    return Photo(
      id: id,
      url: url,
      title: title,
      isProfile: isProfile ?? this.isProfile,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}

// --- MOCK DATA ---
final List<Photo> initialPhotos = [
  Photo(id: 1, url: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=500&q=60', isPrivate: false, isProfile: true, title: 'Paisagem'),
  Photo(id: 2, url: 'https://images.unsplash.com/photo-1500462918059-b1a0cb512f1d?auto=format&fit=crop&w=500&q=60', isPrivate: true, isProfile: false, title: 'Abstrato'),
  Photo(id: 3, url: 'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?auto=format&fit=crop&w=500&q=60', isPrivate: false, isProfile: false, title: 'Natureza'),
];

void main() {
  runApp(const PhotoMasterApp());
}

// --- WIDGET PRINCIPAL ---

class PhotoMasterApp extends StatefulWidget {
  final String initialView;
  const PhotoMasterApp({super.key, this.initialView = 'dashboard'});

  @override
  State<PhotoMasterApp> createState() => _PhotoMasterAppState();
}

class _PhotoMasterAppState extends State<PhotoMasterApp> {
  // Estado da aplicação
  List<Photo> _photos = initialPhotos;
  late String _currentView; // 'dashboard' ou 'edit-photos'
  int _selectedDrawerIndex = 3;
  bool _drawerOpen = false;

  @override
  void initState() {
    super.initState();
    _currentView = widget.initialView;
  }

  void _navigateTo(String view) {
    setState(() {
      _currentView = view;
    });
  }

  // --- Funções de Manipulação de Fotos ---

  void _handleDelete(int id) {
    // Em Flutter, usaríamos showDialog para confirmação, mas aqui usamos print para simplicidade.
    debugPrint('Confirmar exclusão da foto $id');
    setState(() {
      _photos = _photos.where((p) => p.id != id).toList();
    });
  }

  void _togglePrivacy(int id) {
    setState(() {
      _photos = _photos.map((p) => 
        p.id == id ? p.copyWith(isPrivate: !p.isPrivate) : p
      ).toList();
    });
  }

  void _setProfile(int id) {
    setState(() {
      _photos = _photos.map((p) => 
        p.copyWith(isProfile: p.id == id)
      ).toList();
    });
  }

  void _handleAddPhoto() {
    final newId = (_photos.isNotEmpty ? _photos.map((p) => p.id).reduce(
          (a, b) => a > b ? a : b) : 0) + 1;
    final newPhoto = Photo(
      id: newId,
      url: 'https://picsum.photos/seed/$newId/500/500', 
      isPrivate: false,
      isProfile: false,
      title: 'Nova Foto $newId',
    );
    setState(() {
      _photos = [..._photos, newPhoto];
    });
  }

  void _onBottomNavTap(int index) {
    final isMobile = MediaQuery.of(context).size.width < 1024;
    setState(() => _selectedDrawerIndex = index);

    if (index == 0) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      Navigator.of(context).maybePop();
      return;
    }
    if (index == 1) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ShortsPage()));
      return;
    }
    if (index == 3) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      return;
    }
    if (isMobile && _drawerOpen) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1024;

    return MaterialApp(
      title: 'PhotoMaster App',
      debugShowCheckedModeBanner: false,
      theme: defaultLightTheme,
      darkTheme: defaultDarkTheme,
      home: Scaffold(
        backgroundColor: Colors.white,
        drawerScrimColor: Colors.transparent,
        appBar: TwynkAppBar(isMobile: isMobile, drawerOpen: _drawerOpen),
        onDrawerChanged: (open) => setState(() => _drawerOpen = open),
        drawer: isMobile
            ? Drawer(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: SidebarMenu(
                  compact: false,
                  showDrawerHeader: true,
                  selectedIndex: _selectedDrawerIndex,
                  onItemSelected: (index) {
                    setState(() => _selectedDrawerIndex = index);
                    Navigator.of(context).pop();
                    _onBottomNavTap(index);
                  },
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
                  selectedIndex: _selectedDrawerIndex,
                  onItemSelected: _onBottomNavTap,
                ),
              ),
            Expanded(
              child: SafeArea(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1024),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _currentView == 'dashboard'
                          ? DashboardPage(
                              key: const ValueKey('dashboard'),
                              navigateTo: _navigateTo,
                              photos: _photos,
                            )
                          : EditPhotosPage(
                              key: const ValueKey('edit-photos'),
                              navigateTo: _navigateTo,
                              photos: _photos,
                              handleDelete: _handleDelete,
                              togglePrivacy: _togglePrivacy,
                              setProfile: _setProfile,
                              handleAddPhoto: _handleAddPhoto,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: isMobile
            ? Footer(
                currentIndex: _selectedDrawerIndex,
                onTap: _onBottomNavTap,
              )
            : null,
      ),
    );
  }
}

// --- WIDGETS DE PÁGINA ---

// Componente Simples de Card para o Dashboard
class StatCard extends StatelessWidget {
  final String title;
  final dynamic value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool compact = width <= 640;
    final double cardPadding = compact ? 14.0 : 24.0;
    final double iconPad = compact ? 8.0 : 12.0;
    final double iconSize = compact ? 20.0 : 24.0;
    final double valueFontSize = compact ? 20.0 : 24.0;
    final double titleFontSize = compact ? 13.0 : 14.0;
    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(iconPad),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999), // rounded-full
            ),
            child: Icon(icon, size: iconSize, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                  height: 1.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final Function(String) navigateTo;
  final List<Photo> photos;

  const DashboardPage({
    super.key,
    required this.navigateTo,
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    final totalPhotos = photos.length;
    final privatePhotos = photos.where((p) => p.isPrivate).length;
    final profilePhoto = photos.any((p) => p.isProfile);
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardAspect = screenWidth > 1024
        ? 3.0
        : screenWidth > 640
            ? 2.4
            : 1.8;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Header do Dashboard
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Painel de Controle',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B), // slate-800
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bem-vindo ao seu gerenciador de galeria.',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => navigateTo('edit-photos'),
              icon: const Icon(Icons.settings, size: 18),
              label: const Text('Gerenciar Fotos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Seção de Cards
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 1024
              ? 3
              : MediaQuery.of(context).size.width > 640
                  ? 2
                  : 1,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: cardAspect,
          children: [
            StatCard(
              title: "Total de Fotos",
              value: totalPhotos,
              icon: Icons.image,
              color: Colors.blue.shade500,
            ),
            StatCard(
              title: "Fotos Privadas",
              value: privatePhotos,
              icon: Icons.lock,
              color: Colors.purple.shade500,
            ),
            StatCard(
              title: "Foto de Perfil",
              value: profilePhoto ? "Definida" : "Pendente",
              icon: Icons.person,
              color: profilePhoto ? Colors.green.shade500 : Colors.orange.shade500,
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Preview Rápido
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Visualização Rápida da Galeria',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),
              photos.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 1024
                            ? 4
                            : MediaQuery.of(context).size.width > 640
                                ? 2
                                : 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: photos.length > 4 ? 4 : photos.length,
                      itemBuilder: (context, index) {
                        final photo = photos[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                photo.url,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) => 
                                  Container(
                                    color: Colors.grey.shade200, 
                                    child: const Center(child: Icon(Icons.error, color: Colors.red)),
                                  ),
                              ),
                              if (photo.isPrivate)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(Icons.lock, size: 12, color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    )
                  : Container(
                      alignment: Alignment.center,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid, width: 2),
                      ),
                      child: Text(
                        'Nenhuma foto adicionada ainda.',
                        style: TextStyle(color: Colors.grey.shade400),
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

class EditPhotosPage extends StatelessWidget {
  final Function(String) navigateTo;
  final List<Photo> photos;
  final Function(int) handleDelete;
  final Function(int) togglePrivacy;
  final Function(int) setProfile;
  final Function() handleAddPhoto;

  const EditPhotosPage({
    super.key,
    required this.navigateTo,
    required this.photos,
    required this.handleDelete,
    required this.togglePrivacy,
    required this.setProfile,
    required this.handleAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Header
        Container(
          padding: const EdgeInsets.only(bottom: 24.0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                children: [
                  IconButton(
                    onPressed: () => navigateTo('dashboard'),
                    icon: const Icon(Icons.arrow_back, size: 24),
                    padding: EdgeInsets.zero,
                    color: Colors.grey.shade600,
                    splashRadius: 24,
                  ),
                  const Text(
                    'Editar Fotos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: handleAddPhoto,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Adicionar Foto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Dicas Section
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            border: Border(left: BorderSide(color: Colors.blue.shade500, width: 4)),
            borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded, size: 20, color: Colors.blue.shade500),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dicas Importantes',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• Organize suas fotos aqui. As alterações são salvas automaticamente.', style: TextStyle(fontSize: 13, color: Colors.blue.shade700)),
                        Text('• Use o ícone de cadeado para tornar uma foto privada (invisível no perfil público).', style: TextStyle(fontSize: 13, color: Colors.blue.shade700)),
                        Text('• Apenas uma foto pode ser definida como foto de Perfil.', style: TextStyle(fontSize: 13, color: Colors.blue.shade700)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Grid de Fotos
        Text(
          'Sua Galeria (${photos.length})',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 1280
                ? 4 // xl:grid-cols-4
                : MediaQuery.of(context).size.width > 768
                    ? 3 // lg:grid-cols-3
                    : MediaQuery.of(context).size.width > 640
                        ? 2 // sm:grid-cols-2
                        : 1, // grid-cols-1
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 0.75, // Ajustado para acomodar o conteúdo abaixo da imagem
          ),
          itemCount: photos.length + 1, // +1 para o botão "Adicionar Nova Foto"
          itemBuilder: (context, index) {
            if (index == photos.length) {
              // Botão Grande de Adicionar (Card Vazio)
              return InkWell(
                onTap: handleAddPhoto,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid, width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 5)],
                        ),
                        child: const Icon(Icons.camera_alt, size: 24, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Adicionar Nova Foto',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B), // slate-600
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final photo = photos[index];
            return PhotoCard(
              photo: photo,
              togglePrivacy: togglePrivacy,
              setProfile: setProfile,
              handleDelete: handleDelete,
            );
          },
        ),
        ],
      ),
    );
  }
}

class PhotoCard extends StatelessWidget {
  final Photo photo;
  final Function(int) togglePrivacy;
  final Function(int) setProfile;
  final Function(int) handleDelete;

  const PhotoCard({
    super.key,
    required this.photo,
    required this.togglePrivacy,
    required this.setProfile,
    required this.handleDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: photo.isProfile ? Colors.green.shade500 : Colors.grey.shade200,
          width: photo.isProfile ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Área da Imagem
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    photo.url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,));
                    },
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade200, child: const Center(child: Icon(Icons.error, color: Colors.red))),
                  ),

                  // Overlay e Título (simulando hover com gradiente)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        photo.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  // Badges
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      children: [
                        if (photo.isPrivate)
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade600,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.lock, size: 10, color: Colors.white),
                                SizedBox(width: 4),
                                Text('Privada', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        if (photo.isProfile)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.person, size: 10, color: Colors.white),
                                SizedBox(width: 4),
                                Text('Perfil', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Ações
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool isNarrow = constraints.maxWidth < 240;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Toggle Privacy
                    if (!isNarrow)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  photo.isPrivate ? Icons.lock : Icons.lock_open,
                                  size: 16,
                                  color: photo.isPrivate ? Colors.purple.shade500 : Colors.grey.shade600,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    photo.isPrivate ? 'Visibilidade: Privada' : 'Visibilidade: Pública',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: photo.isPrivate,
                            onChanged: (value) => togglePrivacy(photo.id),
                            activeThumbColor: Colors.purple.shade500,
                            inactiveTrackColor: Colors.grey.shade300,
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                photo.isPrivate ? Icons.lock : Icons.lock_open,
                                size: 16,
                                color: photo.isPrivate ? Colors.purple.shade500 : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  photo.isPrivate ? 'Visibilidade: Privada' : 'Visibilidade: Pública',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Switch(
                              value: photo.isPrivate,
                              onChanged: (value) => togglePrivacy(photo.id),
                              activeThumbColor: Colors.purple.shade500,
                              inactiveTrackColor: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    // Botões de Ação
                    if (!isNarrow)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: photo.isProfile ? null : () => setProfile(photo.id),
                              icon: const Icon(Icons.person, size: 14),
                              label: Text(photo.isProfile ? 'Atual' : 'Definir Perfil'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: photo.isProfile ? Colors.green.shade50 : Colors.white,
                                foregroundColor: photo.isProfile ? Colors.green.shade700 : Colors.grey.shade600,
                                side: BorderSide(
                                  color: photo.isProfile ? Colors.green.shade200 : Colors.grey.shade200,
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => handleDelete(photo.id),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade100),
                                color: Colors.white,
                              ),
                              child: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade500),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton.icon(
                            onPressed: photo.isProfile ? null : () => setProfile(photo.id),
                            icon: const Icon(Icons.person, size: 14),
                            label: Text(photo.isProfile ? 'Atual' : 'Definir Perfil'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: photo.isProfile ? Colors.green.shade50 : Colors.white,
                              foregroundColor: photo.isProfile ? Colors.green.shade700 : Colors.grey.shade600,
                              side: BorderSide(
                                color: photo.isProfile ? Colors.green.shade200 : Colors.grey.shade200,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 36,
                              height: 36,
                              child: IconButton(
                                onPressed: () => handleDelete(photo.id),
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}