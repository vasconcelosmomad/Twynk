import 'package:flutter/material.dart';
import 'package:twynk_frontend/portals/app_bar.dart';
import 'package:twynk_frontend/portals/drawer.dart';
import 'package:video_player/video_player.dart';

class ShortsPage extends StatefulWidget {
  const ShortsPage({super.key});

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  int _selectedIndex = 1;
  bool _drawerOpen = false;

  final List<String> _videoUrls = [
    'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
  ];

  final Map<int, VideoPlayerController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllerAtIndex(0);
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeControllerAtIndex(int index) async {
    if (index < 0 || index >= _videoUrls.length) return;
    if (_controllers.containsKey(index)) return;

    final controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrls[index]));
    _controllers[index] = controller;

    await controller.initialize();
    controller.setLooping(true);
    await controller.setVolume(0.0);

    if (index == _currentIndex) {
      await controller.play();
    }

    if (mounted) setState(() {});
  }

  void _onPageChanged(int index) async {
    final prev = _controllers[_currentIndex];
    prev?.pause();

    _currentIndex = index;

    await _initializeControllerAtIndex(index);

    final cur = _controllers[index];
    cur?.play();

    _unloadDistantControllers(index);

    if (mounted) setState(() {});
  }

  void _unloadDistantControllers(int centerIndex) {
    final keep = {centerIndex - 1, centerIndex, centerIndex + 1};
    final keysToRemove = <int>[];
    for (final key in _controllers.keys) {
      if (!keep.contains(key)) keysToRemove.add(key);
    }
    for (final k in keysToRemove) {
      _controllers[k]?.dispose();
      _controllers.remove(k);
    }
  }

  void _handleNavigation(int index, {bool fromDrawer = false}) {
    final bool isMobile = MediaQuery.of(context).size.width < 1024;

    setState(() => _selectedIndex = index);

    if (index == 0) {
      if (fromDrawer && isMobile && _drawerOpen) {
        Navigator.of(context).pop();
      }
      Navigator.of(context).maybePop();
      return;
    }

    if (index == 1) {
      if (fromDrawer && isMobile && _drawerOpen) {
        Navigator.of(context).pop();
      }
      return;
    }

    if (fromDrawer && isMobile && _drawerOpen) {
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
      appBar: isMobile
          ? null
          : TwynkAppBar(
              isMobile: isMobile,
              drawerOpen: _drawerOpen,
            ),
      drawer: !isMobile
          ? null
          : Drawer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: SidebarMenu(
                compact: false,
                showDrawerHeader: true,
                selectedIndex: _selectedIndex,
                onItemSelected: (index) => _handleNavigation(index, fromDrawer: true),
              ),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _videoUrls.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return _ShortVideoPage(
                  index: index,
                  videoCount: _videoUrls.length,
                  controller: _controllers[index],
                  onInitializeRequested: () => _initializeControllerAtIndex(index),
                  onLike: () => _onLike(index),
                  onMessage: () => _onMessage(index),
                  onProfile: () => _onProfile(index),
                  onNext: () {
                    if (index < _videoUrls.length - 1) {
                      _pageController.animateToPage(
                        index + 1,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  onPrevious: () {
                    if (index > 0) {
                      _pageController.animateToPage(
                        index - 1,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: null,
    );
  }

  void _onLike(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gostou do vídeo #\$index')),
    );
  }

  void _onMessage(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abrir chat com usuário do vídeo #\$index')),
    );
  }

  void _onProfile(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abrir perfil do usuário do vídeo #\$index')),
    );
  }
}

class _ShortVideoPage extends StatefulWidget {
  final int index;
  final int videoCount;
  final VideoPlayerController? controller;
  final VoidCallback onInitializeRequested;
  final VoidCallback onLike;
  final VoidCallback onMessage;
  final VoidCallback onProfile;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _ShortVideoPage({
    required this.index,
    required this.videoCount,
    required this.controller,
    required this.onInitializeRequested,
    required this.onLike,
    required this.onMessage,
    required this.onProfile,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<_ShortVideoPage> createState() => _ShortVideoPageState();
}

class _ShortVideoPageState extends State<_ShortVideoPage> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _togglePlayPause() {
    if (widget.controller == null) return;

    final controller = widget.controller!;
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      if (controller.value.volume == 0) {
        controller.setVolume(1.0);
      }
      controller.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    if (controller == null || !controller.value.isInitialized) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => widget.onInitializeRequested());
      return const Center(child: CircularProgressIndicator());
    }

    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color overlayShade =
        Colors.black.withValues(alpha: isDark ? 0.65 : 0.45);
    final Color outerBackground = theme.scaffoldBackgroundColor;
    final Color avatarBg =
        isDark ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: outerBackground)),
          Center(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller.value.size.width,
                          height: controller.value.size.height,
                          child: VideoPlayer(controller),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, overlayShade],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 120,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _IconButtonColumn(
                            icon: Icons.favorite,
                            label: 'Like',
                            onTap: widget.onLike,
                          ),
                          const SizedBox(height: 16),
                          _IconButtonColumn(
                            icon: Icons.message,
                            label: 'Msg',
                            onTap: widget.onMessage,
                          ),
                          const SizedBox(height: 16),
                          _IconButtonColumn(
                            icon: Icons.person,
                            label: 'Perfil',
                            onTap: widget.onProfile,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 24,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: widget.onProfile,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: avatarBg,
                                  child:
                                      const Icon(Icons.person, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Nome do Usuário',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Descrição curta do usuário - interesses, frase de efeito, etc.',
                            style: TextStyle(color: Colors.white70),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: controller.value.isPlaying ? 0.0 : 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.35),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(Icons.play_arrow,
                              size: 48, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isDesktop)
            Positioned(
              right: 24,
              top: 0,
              bottom: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.index > 0)
                      _ShortsNavButton(
                        onPressed: widget.onPrevious,
                        icon: Icons.keyboard_arrow_up,
                      ),
                    if (widget.index > 0 && widget.index < widget.videoCount - 1)
                      const SizedBox(height: 12),
                    if (widget.index < widget.videoCount - 1)
                      _ShortsNavButton(
                        onPressed: widget.onNext,
                        icon: Icons.keyboard_arrow_down,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ShortsNavButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ShortsNavButton({required this.icon, required this.onPressed});

  @override
  State<_ShortsNavButton> createState() => _ShortsNavButtonState();
}

class _ShortsNavButtonState extends State<_ShortsNavButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? Colors.white : Colors.black;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isHovering
              ? (isDark ? Colors.grey[800] : Colors.grey[300])
              : (isDark ? Colors.grey[900] : Colors.grey[200]),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.2).round()),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(widget.icon, color: color),
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
class _IconButtonColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _IconButtonColumn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}