import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../portals/app_bar_copy.dart';
import '../portals/drawer.dart';
import '../portals/footer.dart';
import '../services/api_client.dart';
import 'login.dart';
import '../themes/nomirro_colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> users = [
    {'id': '1', 'name': 'Alice Silva', 'lastMessage': 'Claro, combinado para amanhã!', 'time': '10:30', 'avatarColor': '0xFFE57373'},
    {'id': '2', 'name': 'Bruno Costa', 'lastMessage': 'Enviei o documento PDF.', 'time': 'Ontem', 'avatarColor': '0xFF64B5F6'},
    {'id': '3', 'name': 'Carla Lima', 'lastMessage': 'Não se preocupe com isso.', 'time': 'Seg', 'avatarColor': '0xFF81C784'},
    {'id': '4', 'name': 'Daniel Alves', 'lastMessage': 'A reunião foi cancelada.', 'time': '01/11', 'avatarColor': '0xFFFFF176'},
    {'id': '5', 'name': 'Helena Santos', 'lastMessage': 'Obrigada pela ajuda!', 'time': '28/10', 'avatarColor': '0xFFF48FB1'},
    {'id': '6', 'name': 'Fábio Melo', 'lastMessage': 'Certo, vou verificar.', 'time': '25/10', 'avatarColor': '0xFF7986CB'},
    {'id': '7', 'name': 'Gabriela Nunes', 'lastMessage': 'Pode me ligar mais tarde?', 'time': '20/10', 'avatarColor': '0xFFBA68C8'},
    {'id': '8', 'name': 'Igor Rocha', 'lastMessage': 'Chegando em 5 minutos.', 'time': '15/10', 'avatarColor': '0xFF4DB6AC'},
  ];

  final List<Map<String, dynamic>> initialMessages = [
    {'id': 1, 'content': 'Olá Alice, você viu o e-mail que enviei sobre o projeto?', 'time': '10:20', 'isMine': true},
    {'id': 2, 'content': 'Oi! Vi sim, agora pouco. Parece que está tudo certo.', 'time': '10:22', 'isMine': false},
    {'id': 3, 'content': 'Ótimo. Precisamos finalizar os ajustes na próxima semana.', 'time': '10:25', 'isMine': true},
    {'id': 4, 'content': 'Claro, combinado para amanhã! Já deixei as pendências separadas.', 'time': '10:30', 'isMine': false},
  ];

  Map<String, String>? selectedUser;
  late List<Map<String, dynamic>> messages;

  final ScrollController _messagesController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  bool isChatListVisible = true;
  int selectedDrawerIndex = 3;
  bool _drawerOpen = false;

  @override
  void initState() {
    super.initState();
    selectedUser = users.first;
    messages = List<Map<String, dynamic>>.from(initialMessages);
  }

  @override
  void dispose() {
    _messagesController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _selectUser(Map<String, String> user, BoxConstraints constraints) {
    setState(() {
      selectedUser = user;
      if (constraints.maxWidth < 768) isChatListVisible = false;
    });
  }

  void _backToList() {
    setState(() => isChatListVisible = true);
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'content': text,
        'time': _timeNow(),
        'isMine': true,
      });
      _textController.clear();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_messagesController.hasClients) {
        _messagesController.animateTo(
          _messagesController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile == null) return;
    final bytes = await pickedFile.readAsBytes();
    if (!mounted) return;

    setState(() {
      messages.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'imageBytes': bytes,
        'time': _timeNow(),
        'isMine': true,
      });
    });

    _scrollToBottom();
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (pickedFile == null) return;
    final bytes = await pickedFile.readAsBytes();
    if (!mounted) return;

    setState(() {
      messages.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'imageBytes': bytes,
        'time': _timeNow(),
        'isMine': true,
      });
    });

    _scrollToBottom();
  }

  void _showImageOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.lightBlue),
                title: const Text('Selecionar da galeria'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: NomirroColors.primary),
                title: const Text('Tirar foto'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _takePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _timeNow() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}';
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

  void _onBottomNavTap(int index) {
    final isMobile = MediaQuery.of(context).size.width < 1024;
    setState(() => selectedDrawerIndex = index);

    if (index == 6) {
      if (isMobile && _drawerOpen) Navigator.pop(context);
      _logout();
      return;
    }
  }

  Widget _avatar(String name, String colorHex) {
    final initials = name
        .split(' ')
        .where((s) => s.isNotEmpty)
        .map((s) => s[0])
        .take(2)
        .join()
        .toUpperCase();
    return CircleAvatar(
      backgroundColor: Color(int.parse(colorHex)),
      child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }

  Widget _chatListItem(Map<String, String> user, bool isSelected, BoxConstraints constraints) {
    return InkWell(
      onTap: () => _selectUser(user, constraints),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? NomirroColors.primary.withValues(alpha: 0.08) : null,
          border: isSelected ? const Border(left: BorderSide(color: NomirroColors.primary, width: 4)) : null,
        ),
        child: Row(
          children: [
            _avatar(user['name']!, user['avatarColor']!),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user['name']!,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Flexible(
                        flex: 0,
                        child: Text(
                          user['time']!,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(user['lastMessage']!, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageBubble(Map<String, dynamic> message) {
    final mine = message['isMine'] as bool;
    final bg = mine ? NomirroColors.primary : Colors.grey.shade100;
    final String? content = message['content'] as String?;
    final Uint8List? imageBytes = message['imageBytes'] as Uint8List?;
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1024;
    final double maxBubbleWidth = isDesktop ? 560 : 380;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: mine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Align(
            alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(maxWidth: maxBubbleWidth),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(mine ? 16 : 4),
                  bottomRight: Radius.circular(mine ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (imageBytes != null && imageBytes.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 260,
                            maxHeight: 260,
                          ),
                          child: Image.memory(
                            imageBytes,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  if (content != null && content.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: imageBytes != null && imageBytes.isNotEmpty ? 8 : 0,
                        ),
                        child: Text(
                          content,
                          style: TextStyle(
                            color: mine ? Colors.white : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    message['time'],
                    style: TextStyle(
                      fontSize: 11,
                      color: (mine ? Colors.white : Colors.black).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawerScrimColor: Colors.transparent,
      appBar: (!isMobile || isChatListVisible)
          ? NomirroAppBar(isMobile: isMobile, drawerOpen: _drawerOpen)
          : null,
      onDrawerChanged: (open) => setState(() => _drawerOpen = open),
      drawer: isMobile
          ? Drawer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: SidebarMenu(
                compact: false,
                showDrawerHeader: true,
                selectedIndex: selectedDrawerIndex,
                onItemSelected: _onBottomNavTap,
              ),
            )
          : null,
      body: Row(
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 1024;

                  final containerDecoration = BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: isDesktop ? BorderRadius.circular(12) : BorderRadius.zero,
                    border: isDesktop ? Border.all(color: Colors.grey.shade300) : null,
                  );

                  final chatList = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 40),
                            hintText: 'Buscar chats...',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            filled: true,
                            fillColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white12
                                : const Color(0xFFF6EAFE),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 20,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : NomirroColors.accentDark,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          // ✅ reverse removido para corrigir espaçamento
                          padding: EdgeInsets.zero,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final isSelected =
                                selectedUser != null && selectedUser!['id'] == user['id'];
                            return _chatListItem(user, isSelected, constraints);
                          },
                        ),
                      ),
                    ],
                  );

                  final chatWindow = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 8 : 2,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            if (!isDesktop && !isChatListVisible)
                              IconButton(
                                onPressed: _backToList,
                                icon: const Icon(Icons.arrow_back),
                                padding: const EdgeInsets.all(4),
                                iconSize: 26,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                            if (selectedUser != null)
                              _avatar(selectedUser!['name']!, selectedUser!['avatarColor']!),
                            const SizedBox(width: 12),
                            if (selectedUser != null)
                              Expanded(
                                child: Text(
                                  selectedUser!['name']!,
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Chamada de vídeo',
                              onPressed: () {},
                              icon: const Icon(Icons.videocam),
                              style: IconButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(6),
                                backgroundColor:
                                    NomirroColors.primary.withValues(alpha: 0.16),
                                foregroundColor: NomirroColors.accentDark,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: PopupMenuButton<String>(
                                tooltip: 'Mais opções',
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) {
                                  switch (value) {
                                    case 'end':
                                      break;
                                    case 'report':
                                      break;
                                    case 'block':
                                      break;
                                    case 'clear':
                                      break;
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem<String>(
                                    value: 'end',
                                    child: Text('Encerrar chat'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'report',
                                    child: Text('Denunciar'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'block',
                                    child: Text('Bloquear'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'clear',
                                    child: Text('Limpar conversa'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: _messagesController,
                          itemCount: messages.length,
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 8 : 4,
                            vertical: 10,
                          ),
                          itemBuilder: (context, index) => _messageBubble(messages[index]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 8 : 4,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                minLines: 1,
                                maxLines: 3,
                                onChanged: (_) => setState(() {}),
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: selectedUser != null
                                      ? 'Digite sua mensagem para ${selectedUser!['name']}...'
                                      : 'Digite sua mensagem...',
                                  hintStyle: TextStyle(color: Colors.grey[600]),
                                  filled: true,
                                  fillColor: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white12
                                      : const Color(0xFFF6EAFE),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.emoji_emotions_outlined,
                                      size: 22,
                                      color: Colors.black,
                                    ),
                                  ),
                                  suffixIcon: SizedBox(
                                    width: 80,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: _showImageOptions,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.attach_file,
                                              size: 22,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        InkWell(
                                          onTap: _textController.text.trim().isEmpty
                                              ? () {}
                                              : _sendMessage,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Icon(
                                              _textController.text.trim().isEmpty
                                                  ? Icons.mic
                                                  : Icons.send,
                                              size: 22,
                                              color: _textController.text.trim().isEmpty
                                                  ? NomirroColors.accentDark
                                                  : NomirroColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );

                  if (!isDesktop) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200, minHeight: 0),
                          child: Container(
                            decoration: containerDecoration,
                            child: Column(
                              children: [
                                Expanded(
                                  child: isChatListVisible ? chatList : chatWindow,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200, minHeight: 0),
                        child: Container(
                          decoration: containerDecoration,
                          child: Row(
                            children: [
                              SizedBox(width: 320, child: chatList),
                              Expanded(child: chatWindow),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? Footer(currentIndex: selectedDrawerIndex > 4 ? 0 : selectedDrawerIndex, onTap: _onBottomNavTap)
          : null,
    );
  }
}
