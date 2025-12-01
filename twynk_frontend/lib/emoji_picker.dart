import 'package:flutter/material.dart';

class EmojiPicker extends StatelessWidget {
  final Function(String emoji) onEmojiSelected;

  const EmojiPicker({super.key, required this.onEmojiSelected});

  final List<String> emojis = const [
    '😀', '😁', '😂', '🤣', '😅', '😊', '😍', '😘', '😎', '😢', '😭', '😡', '🤔', '🤨', '😴', '😇',
    '🎉', '✨', '🔥', '⭐', '💫', '⚡', '🌟', '💖', '💘', '💝',
    '👍', '👌', '🙏', '🤝', '🙌', '👏', '🤌', '🤏',
    '🍽', '🍔', '🍕', '🍟', '🍗', '🥗', '🍱', '🍜',
    '📱', '💻', '🖥', '⌨', '🖱',
    '✔', '❌', '⚠', '❗', '❓',
    '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8, // quantidade por linha
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onEmojiSelected(emojis[index]),
            child: Center(
              child: Text(
                emojis[index],
                style: const TextStyle(fontSize: 26),
              ),
            ),
          );
        },
      ),
    );
  }
}
