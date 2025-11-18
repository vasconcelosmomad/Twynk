import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:twynk_frontend/portals/footer.dart';
import 'package:twynk_frontend/portals/app_bar.dart';

class ShortsPage extends StatefulWidget {
  const ShortsPage({Key? key}) : super(key: key);

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TwynkAppBar(
        isMobile: true,
        drawerOpen: false,
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _videoUrls.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return _ShortVideoPage(
            index: index,
            controller: _controllers[index],
            onInitializeRequested: () => _initializeControllerAtIndex(index),
            onLike: () => _onLike(index),
            onMessage: () => _onMessage(index),
            onProfile: () => _onProfile(index),
          );
        },
      ),
      bottomNavigationBar: Footer(
        currentIndex: 1,
        onTap: (index) {
          if (index != 1) {
            Navigator.pop(context);
          }
        },
      ),
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
  final VideoPlayerController? controller;
  final VoidCallback onInitializeRequested;
  final VoidCallback onLike;
  final VoidCallback onMessage;
  final VoidCallback onProfile;

  const _ShortVideoPage({
    Key? key,
    required this.index,
    required this.controller,
    required this.onInitializeRequested,
    required this.onLike,
    required this.onMessage,
    required this.onProfile,
  }) : super(key: key);

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

    return GestureDetector(
      onTap: _togglePlayPause,
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
                  colors: [Colors.transparent, Colors.black54],
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
            right: 100,
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
                        backgroundColor: Colors.white24,
                        child: const Icon(Icons.person, color: Colors.white),
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
                  color: Colors.black45,
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
    );
  }
}

class _IconButtonColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _IconButtonColumn({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

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