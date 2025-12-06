import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twynk_frontend/portals/footer.dart';
import 'package:twynk_frontend/services/api_client.dart';
import 'package:twynk_frontend/pages/login.dart';
import 'package:twynk_frontend/pages/proflie.dart';
import 'package:twynk_frontend/pages/plans.dart';
import 'package:twynk_frontend/pages/encounters.dart';
import 'package:twynk_frontend/pages/ping.dart';
import 'package:twynk_frontend/pages/snaps.dart';
import 'package:twynk_frontend/pages/chat.dart';
import 'package:twynk_frontend/models/snap.dart';
import 'package:twynk_frontend/widgets/visibility_modal.dart';

// -----------------------------
// Models (Video e Comment)
// -----------------------------
class CommentModel {
  final int id;
  final String user;
  final String text;
  final String date;
  final int? parentId;

  CommentModel({
    required this.id,
    required this.user,
    required this.text,
    required this.date,
    this.parentId,
  });
}

class VideoModel {
  final int id;
  final String title;
  final String status;
  final int views;
  final int likes;
  final int dislikes;
  final List<CommentModel> comments;
  final SnapVisibility visibility;

  VideoModel({
    required this.id,
    required this.title,
    required this.status,
    required this.views,
    required this.likes,
    required this.dislikes,
    required this.comments,
    this.visibility = SnapVisibility.public,
  });

  VideoModel copyWith({
    int? id,
    String? title,
    String? status,
    int? views,
    int? likes,
    int? dislikes,
    List<CommentModel>? comments,
    SnapVisibility? visibility,
  }) {
    return VideoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      comments: comments ?? this.comments,
      visibility: visibility ?? this.visibility,
    );
  }
}

// -----------------------------
// Dados iniciais (simulados)
// -----------------------------
final List<VideoModel> initialVideos = [
  VideoModel(
    id: 1,
    title: "Review Rápido do Novo Gadget Tech",
    status: 'Publicado',
    views: 1200,
    likes: 80,
    dislikes: 5,
    visibility: SnapVisibility.public,
    comments: [
      CommentModel(id: 101, user: "TechLover_99", text: "Muito bom! Quando sai a versão completa?", date: "2 horas atrás", parentId: null),
      CommentModel(id: 1011, user: "Creator_Handle", text: "Olá! A versão completa sai na próxima semana!", date: "1 hora atrás", parentId: 101),
      CommentModel(id: 102, user: "Curioso_01", text: "Onde posso comprar isso no Brasil?", date: "1 hora atrás", parentId: null),
    ],
  ),
  VideoModel(
    id: 2,
    title: "Desafio de 1 minuto: Culinária Extrema",
    status: 'Publicado',
    views: 85000,
    likes: 7200,
    dislikes: 150,
    visibility: SnapVisibility.public,
    comments: [
      CommentModel(id: 201, user: "Chef_Amador", text: "Tentei fazer e queimei tudo! kkkk", date: "4 dias atrás", parentId: null),
      CommentModel(id: 202, user: "ReceitasTop", text: "Ótima edição! Qual o segredo da transição?", date: "3 dias atrás", parentId: null),
      CommentModel(id: 2021, user: "Fã_de_Shorts", text: "É só prática! Adorei a ideia do vídeo.", date: "2 dias atrás", parentId: 202),
      CommentModel(id: 203, user: "Fã_de_Shorts", text: "Que vídeo viciante, assisti 5x!", date: "1 dia atrás", parentId: null),
    ],
  ),
  VideoModel(
    id: 4,
    title: "Reações Engraçadas de Pets a Limão",
    status: 'Publicado',
    views: 520000,
    likes: 45000,
    dislikes: 800,
    visibility: SnapVisibility.public,
    comments: [
      CommentModel(id: 401, user: "CatMom", text: "Meu gato fez exatamente o mesmo!", date: "1 mês atrás", parentId: null),
      CommentModel(id: 402, user: "ViralHunter", text: "Esse vai bater 1M fácil! Parabéns!", date: "3 semanas atrás", parentId: null),
      CommentModel(id: 403, user: "Anon_123", text: "Achei cruel :(", date: "2 semanas atrás", parentId: null),
    ],
  ),
  VideoModel(
    id: 5,
    title: "Tutorial de Desenho Rápido de 60 Segundos",
    status: 'Ideia',
    views: 900,
    likes: 50,
    dislikes: 2,
    visibility: SnapVisibility.private,
    comments: [
      CommentModel(id: 501, user: "ArtistaAmador", text: "Que traço rápido! Impressionante.", date: "5 horas atrás", parentId: null),
    ],
  ),
];

// -----------------------------
// Função utilitária formatNumber
// -----------------------------
String formatNumber(int num) {
  if (num >= 1000000) return '${(num / 1000000).toStringAsFixed(1)}M';
  if (num >= 1000) return '${(num / 1000).toStringAsFixed(1)}K';
  return num.toString();
}

// -----------------------------
// App Principal
// -----------------------------
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Painel Explorer - Flutter',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      home: const ExplorerPage(),
    );
  }
}

class ExplorerPage extends StatefulWidget {
  final bool openUploadOnStart;

  const ExplorerPage({super.key, this.openUploadOnStart = false});

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  final List<VideoModel> videos = initialVideos;
  int _selectedIndex = 2; // Explore

  void _onVisibilityChanged(VideoModel video, SnapVisibility newVisibility) {
    setState(() {
      final index = videos.indexWhere((v) => v.id == video.id);
      if (index != -1) {
        videos[index] = video.copyWith(visibility: newVisibility);
      }
    });
  }

  Future<void> _logout() async {
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
  void initState() {
    super.initState();
    if (widget.openUploadOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openUploadDialog();
      });
    }
  }

  void _openUploadDialog() {
    final parentContext = context;
    showDialog<void>(
      context: parentContext,
      builder: (dialogContext) {
        final navigator = Navigator.of(dialogContext);
        final messenger = ScaffoldMessenger.of(parentContext);

        Future<void> handlePick() async {
          final result = await FilePicker.platform.pickFiles(
            type: FileType.video,
            allowMultiple: false,
          );

          if (!navigator.mounted || !messenger.mounted) return;
          if (result == null || result.files.isEmpty) {
            navigator.pop();
            return;
          }

          final picked = result.files.first;
          navigator.pop();
          messenger.showSnackBar(
            SnackBar(
              content: Text('Selecionado: ${picked.name}'),
            ),
          );
        }

        return AlertDialog(
          title: const Text('Enviar vídeos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: InkWell(
                  onTap: handlePick,
                  customBorder: const CircleBorder(),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(dialogContext).colorScheme.primary.withValues(alpha: 0.12),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 36,
                      color: Theme.of(dialogContext).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Arraste e solte os arquivos de vídeo para fazer o envio'),
              const SizedBox(height: 8),
              const Text(
                'Seus vídeos ficarão privados até que você os publique.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 4),
              const Text(
                'Carregue vídeos curtos em formato retrato para o seu canal.',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => navigator.pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: handlePick,
              child: const Text('Selecionar arquivos'),
            ),
          ],
        );
      },
    );
  }

  void openVideoDetail(VideoModel video) {
    // Modal full-screen similar ao createPortal + bottom sheet do React
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VideoDetailModal(video: video),
    );
  }

  // calcula número de colunas responsivo (como grid-cols-2 sm:3 lg:4 xl:5)
  int _calculateCols(double width) {
    if (width >= 1500) return 5;
    if (width >= 1100) return 4;
    if (width >= 700) return 3;
    return 2;
  }

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeYouTubeStyleFlutter()),
      );
      return;
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      return;
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SnapsPage()),
      );
      return;
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatPage()),
      );
      return;
    }

    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PlansPage()),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final bool showFooter = width < 1024;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Painel Explorer'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(
          color: colorScheme.primary,
        ),
        centerTitle: false,
        actions: [
          if (isMobile)
            IconButton.filledTonal(
              onPressed: _openUploadDialog,
              icon: Icon(
                Icons.add_outlined,
                color: colorScheme.primary,
              ),
              tooltip: 'Criar',
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.all(6.0),
                minimumSize: const Size(36, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            )
          else
            Center(
              child: TextButton.icon(
                onPressed: _openUploadDialog,
                icon: Icon(Icons.add_outlined, color: colorScheme.primary),
                label: const Text('Criar'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  foregroundColor: colorScheme.primary,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PainelAssinantePage()),
                );
              } else if (value == 'plans') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PlansPage()),
                );
              } else if (value == 'logout') {
                _logout();
              }
            },
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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.16),
                  child: const Icon(Icons.person, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 4),
                Icon(Icons.more_vert, color: colorScheme.onSurface),
                const SizedBox(width: 8),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: LayoutBuilder(builder: (context, constraints) {
          final cols = _calculateCols(constraints.maxWidth);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Expanded(
                child: GridView.builder(
                  itemCount: videos.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 9 / 16, // mantém aspecto dos shorts
                  ),
                  itemBuilder: (context, index) {
                    return VideoCard(
                      video: videos[index], 
                      onTap: openVideoDetail,
                      onVisibilityChanged: _onVisibilityChanged,
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: showFooter
          ? Footer(
              currentIndex: _selectedIndex > 4 ? 0 : _selectedIndex,
              onTap: _onBottomNavTap,
            )
          : null,
    );
  }
}

// -----------------------------
// VideoCard widget
// -----------------------------
class VideoCard extends StatefulWidget {
  final VideoModel video;
  final void Function(VideoModel) onTap;
  final void Function(VideoModel, SnapVisibility)? onVisibilityChanged;
  const VideoCard({super.key, required this.video, required this.onTap, this.onVisibilityChanged});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  void _showVisibilityOptions(BuildContext context) {
    if (widget.onVisibilityChanged == null) return;
    
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => VisibilityModal(
        currentVisibility: widget.video.visibility,
        onVisibilityChanged: (newVisibility) {
          widget.onVisibilityChanged!(widget.video, newVisibility);
        },
      ),
    );
  }

  static const List<List<Color>> placeholderGradients = [
    [Color(0xFFEF4444), Color(0xFFEC4899)], // red -> pink
    [Color(0xFF14B8A6), Color(0xFF3B82F6)], // teal -> blue
    [Color(0xFFA78BFA), Color(0xFF6366F1)], // purple -> indigo
    [Color(0xFFF59E0B), Color(0xFFF97316)], // yellow -> orange
    [Color(0xFF374151), Color(0xFF111827)], // gray dark
  ];

  @override
  Widget build(BuildContext context) {
    final colors = placeholderGradients[widget.video.id % placeholderGradients.length];
    final durationSeconds = (widget.video.id * 13) % 60;

    return GestureDetector(
      onTap: () => widget.onTap(widget.video),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Miniatura (gradient)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colors[0].withAlpha(230), colors[1].withAlpha(230)],
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.play_arrow, size: 48, color: Colors.white.withAlpha(220)),
                    ),
                  ),
                ),

                // Overlay inferior com título e métricas
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withAlpha(200), Colors.black.withAlpha(0)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.video.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            _Metric(icon: Icons.remove_red_eye, text: formatNumber(widget.video.views), color: Colors.white),
                            _Metric(icon: Icons.thumb_up, text: formatNumber(widget.video.likes), color: Colors.greenAccent.shade400),
                            _Metric(icon: Icons.thumb_down, text: formatNumber(widget.video.dislikes), color: Colors.redAccent.shade100),
                            _Metric(icon: Icons.mode_comment, text: widget.video.comments.length.toString(), color: Colors.white),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                // Ícone de visibilidade no topo esquerdo
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: widget.onVisibilityChanged != null 
                        ? () => _showVisibilityOptions(context)
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(150),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.video.visibility == SnapVisibility.public 
                                ? Icons.public 
                                : Icons.lock,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.video.visibility == SnapVisibility.public 
                                ? 'Público'
                                : 'Privado',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Duração no topo direito
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withAlpha(150), borderRadius: BorderRadius.circular(20)),
                    child: Text('0:${durationSeconds.toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _Metric({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color.withAlpha(240)),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// -----------------------------
// VideoDetailModal (full screen)
// -----------------------------
class VideoDetailModal extends StatefulWidget {
  final VideoModel video;
  const VideoDetailModal({super.key, required this.video});

  @override
  State<VideoDetailModal> createState() => _VideoDetailModalState();
}

class _VideoDetailModalState extends State<VideoDetailModal> {
  // qual comentário está recebendo resposta (id), null = nada
  int? replyingToId;
  final Map<int, TextEditingController> replyControllers = {};
  final TextEditingController topCommentController = TextEditingController();

  void _onVisibilityChanged(SnapVisibility newVisibility) {
    setState(() {
      // Como não temos acesso à lista original, apenas mostramos feedback
      // Em um app real, isso atualizaria o estado global ou faria uma chamada à API
    });
  }

  @override
  void dispose() {
    for (var c in replyControllers.values) {
      c.dispose();
    }
    topCommentController.dispose();
    super.dispose();
  }

  // Agrupa comentários em threads (main + replies)
  List<_CommentThread> groupedComments() {
    final all = widget.video.comments;
    final main = all.where((c) => c.parentId == null).toList()
      ..sort((a, b) => b.id.compareTo(a.id)); // ordem inversa (mais recente primeiro)
    final Map<int, List<CommentModel>> repliesMap = {};
    for (var r in all.where((c) => c.parentId != null)) {
      repliesMap.putIfAbsent(r.parentId!, () => []).add(r);
    }
    return main.map((m) => _CommentThread(main: m, replies: repliesMap[m.id] ?? [])).toList();
  }

  void toggleReply(int commentId) {
    setState(() {
      if (replyingToId == commentId) {
        replyingToId = null;
      } else {
        replyingToId = commentId;
        replyControllers.putIfAbsent(commentId, () => TextEditingController());
      }
    });
  }

  void sendReply(int commentId) {
    final controller = replyControllers[commentId];
    if (controller == null) return;
    final text = controller.text.trim();
    if (text.isEmpty) return;

    // Simula envio: adiciona reply à lista (localmente, sem backend)
    final newReply = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch,
      user: "Você",
      text: text,
      date: "agora",
      parentId: commentId,
    );

    setState(() {
      widget.video.comments.add(newReply);
      controller.clear();
      replyingToId = null;
    });
  }

  void sendTopComment() {
    final text = topCommentController.text.trim();
    if (text.isEmpty) return;

    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch,
      user: "Você",
      text: text,
      date: "agora",
      parentId: null,
    );

    setState(() {
      widget.video.comments.add(newComment);
      topCommentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // para deixar full screen quando isScrollControlled = true
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.98,
        builder: (_, controller) {
          return Container(
            height: height,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                // Handle bar + header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(4))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.video.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Botão de visibilidade
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => VisibilityModal(
                              currentVisibility: widget.video.visibility,
                              onVisibilityChanged: _onVisibilityChanged,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.video.visibility == SnapVisibility.public 
                                    ? Icons.public 
                                    : Icons.lock,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.video.visibility.displayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

                // Conteúdo rolável: player + comentários
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Player simulado (aspect ratio)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade400, width: 4),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.play_arrow, size: 56, color: Colors.red.shade400),
                                    const SizedBox(height: 8),
                                    const Text('VÍDEO EM REPRODUÇÃO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text(widget.video.title, style: const TextStyle(color: Colors.white70)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Comentários: Título e campo para novo comentário
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Comentários (${widget.video.comments.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Campo para comentar no topo
                              Container(
                                decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TextField(
                                      controller: topCommentController,
                                      maxLines: 2,
                                      decoration: const InputDecoration.collapsed(hintText: "Adicione um comentário... (Simulado)"),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: sendTopComment,
                                          child: const Text('Comentar'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),
                              const Divider(),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),

                        // Lista de threads
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: groupedComments().map((thread) {
                              return Container(
                                padding: const EdgeInsets.only(bottom: 12),
                                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Comentário principal
                                    _CommentItem(
                                      comment: thread.main,
                                      onReplyTap: () => toggleReply(thread.main.id),
                                      isReplying: replyingToId == thread.main.id,
                                    ),

                                    // Campo de resposta dinâmico (se ativado)
                                    if (replyingToId == thread.main.id)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, top: 8),
                                        child: Container(
                                          decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              TextField(
                                                controller: replyControllers.putIfAbsent(thread.main.id, () => TextEditingController()),
                                                maxLines: 2,
                                                decoration: InputDecoration.collapsed(hintText: 'Respondendo a ${thread.main.user}... (Simulado)'),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  OutlinedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        replyingToId = null;
                                                      });
                                                    },
                                                    child: const Text('Cancelar'),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  ElevatedButton(
                                                    onPressed: () => sendReply(thread.main.id),
                                                    child: const Text('Enviar'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    // Respostas aninhadas
                                    if (thread.replies.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12, top: 8),
                                        child: Column(
                                          children: thread.replies.map((r) {
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: _CommentItem(
                                                comment: r,
                                                isReply: true,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 26),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Estrutura auxiliar para thread
class _CommentThread {
  final CommentModel main;
  final List<CommentModel> replies;
  _CommentThread({required this.main, required this.replies});
}

// -----------------------------
// Widget de item de comentário
// -----------------------------
class _CommentItem extends StatelessWidget {
  final CommentModel comment;
  final bool isReply;
  final VoidCallback? onReplyTap;
  final bool isReplying;

  const _CommentItem({
    required this.comment,
    this.isReply = false,
    this.onReplyTap,
    this.isReplying = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = theme.textTheme.bodyMedium?.color ?? (theme.brightness == Brightness.dark ? Colors.white : Colors.black87);
    final secondaryTextColor = theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7) ?? Colors.grey;
    final replyColor = colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar simplificado
        CircleAvatar(
          radius: isReply ? 14 : 18,
          backgroundColor: Colors.grey.shade300,
          child: Text(comment.user.substring(0, 1), style: const TextStyle(color: Colors.black87)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      comment.user,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  Text(
                    comment.date,
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  )
                ],
              ),
              const SizedBox(height: 6),
              Text(comment.text, style: TextStyle(color: textColor)),
              const SizedBox(height: 8),
              if (!isReply)
                GestureDetector(
                  onTap: onReplyTap,
                  child: Text(
                    isReplying ? 'Cancelar Resposta' : 'Responder',
                    style: TextStyle(color: replyColor, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
