import 'package:flutter/material.dart';

class GoogleSignInWebButton extends StatelessWidget {
  final Future<void> Function(String token) onSuccess;
  final void Function(String message) onError;

  const GoogleSignInWebButton({
    super.key,
    required this.onSuccess,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
