import 'dart:async';
import 'package:flutter/material.dart';
import 'package:twynk_frontend/themes/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import 'login.dart';
import 'register.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Timer? _imageTimer;
  Timer? _floatTimer;
  bool _useAltImages = false;
  bool _floatUp = true;

  @override
  void initState() {
    super.initState();

    // Troca das imagens (grid + card flutuante) a cada 3 segundos.
    _imageTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() {
        _useAltImages = !_useAltImages;
      });
    });

    // Animação de flutuação mais rápida e contínua.
    _floatTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() {
        _floatUp = !_floatUp;
      });
    });
  }

  @override
  void dispose() {
    _imageTimer?.cancel();
    _floatTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    final bool isMobile = size.width < 600;
    final bool isTablet = size.width >= 600 && size.width < 1024;

    final double imageContainerHeight = isMobile
        ? size.height * 0.5
        : (isTablet ? size.height * 0.6 : size.height * 0.7);

    final EdgeInsets imageContainerMargin = isMobile
        ? EdgeInsets.zero
        : EdgeInsets.only(
            top: size.height * 0.01,
            bottom: size.height * 0.01,
            right: 24,
          );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            children: [
              // ================= IMAGENS =================
              Expanded(
                flex: isMobile ? 0 : 1,
                child: Container(
                  height: imageContainerHeight,
                  margin: imageContainerMargin,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        cs.primaryContainer.withValues(alpha: 0.45),
                        cs.secondaryContainer.withValues(alpha: 0.45),
                      ],
                    ),
                    // Mobile: base arredondada (esquerda e direita).
                    // Desktop: apenas os cantos direito (superior e inferior).
                    borderRadius: isMobile
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          )
                        : const BorderRadius.only(
                            topRight: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                  ),
                  child: Center(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _ImageCard(
                          image: _useAltImages
                              ? 'assets/images/welcome_03.png'
                              : 'assets/images/welcome_01.png',
                          colors: const [Color(0xFF141E30), Color(0xFF243B55)],
                        ),
                        _ImageCard(
                          image: _useAltImages
                              ? 'assets/images/welcome_04.png'
                              : 'assets/images/welcome_02.png',
                          colors: const [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                        ),
                        _ImageCard(
                          image: _useAltImages
                              ? 'assets/images/welcome_05.png'
                              : 'assets/images/welcome_03.png',
                          colors: const [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
                        ),
                        _ImageCard(
                          image: _useAltImages
                              ? 'assets/images/welcome_06.png'
                              : 'assets/images/welcome_04.png',
                          colors: const [Color(0xFF243B55), Color(0xFF141E30)],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ================= CONTEÚDO DESKTOP / TABLET =================
              if (!isMobile)
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              'assets/icons/logo_02.png',
                              height: 44,
                            ),
                            const SizedBox(height: 24),
                            RichText(
                              text: TextSpan(
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                                children: [
                                  const TextSpan(text: 'Encontre alguém '),
                                  TextSpan(
                                    text: 'especial',
                                    style: TextStyle(color: cs.primary),
                                  ),
                                  const TextSpan(text: ' hoje.'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Menos acaso. Mais afinidade. Histórias reais começam com um simples "Olá".',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: cs.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChangeNotifierProvider(
                                      create: (_) => LocationProvider()..fetchPaises(),
                                      child: const RegisterPage(),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.favorite_border),
                              label: const Text('Criar Conta Gratuita'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                                minimumSize: const Size.fromHeight(56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.lg),
                                ),
                                backgroundColor: cs.primary,
                                foregroundColor: cs.onPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              },
                              child: const Text('Já tenho conta'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                                minimumSize: const Size.fromHeight(56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.lg),
                                ),
                                foregroundColor: cs.primary,
                                side: BorderSide(color: cs.primary),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.7),
                                ),
                                children: const [
                                  TextSpan(
                                    text:
                                        'Ao se registrar, você concorda com nossos ',
                                  ),
                                  TextSpan(
                                    text: 'Termos & Condições',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(
                                    text:
                                        '. Saiba como usamos seus dados em nossa ',
                                  ),
                                  TextSpan(
                                    text: 'Política de Privacidade',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(text: '.'),
                                ],
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

          // ================= CARD FLUTUANTE (MOBILE) =================
          if (isMobile)
            Positioned(
              top: size.height * 0.32,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(0, _floatUp ? -8 : 8, 0),
                child: _FloatingCard(useAltImages: _useAltImages),
              ),
            ),

          // ================= BOTÕES MOBILE (FORA DO CARD) =================
          if (isMobile)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                            create: (_) => LocationProvider()..fetchPaises(),
                            child: const RegisterPage(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Criar Conta Gratuita'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text('Já tenho conta'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      foregroundColor: cs.primary,
                      side: BorderSide(color: cs.primary),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.7),
                      ),
                      children: const [
                        TextSpan(
                          text:
                              'Ao se registrar, você concorda com nossos ',
                        ),
                        TextSpan(
                          text: 'Termos & Condições',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text:
                              '. Saiba como usamos seus dados em nossa ',
                        ),
                        TextSpan(
                          text: 'Política de Privacidade',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: '.'),
                      ],
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

// ================= COMPONENTES =================

class _ImageCard extends StatelessWidget {
  final String image;
  final List<Color> colors;

  const _ImageCard({
    required this.image,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(28),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  final bool useAltImages;

  const _FloatingCard({required this.useAltImages});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        width: size.width * 0.92,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cs.surface.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, 14),
              color: Colors.black.withValues(alpha: 0.25),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/logo_02.png', height: 36),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Avatar(
                  url: useAltImages
                      ? 'assets/images/welcome_05.png'
                      : 'assets/images/welcome_01.png',
                ),
                const SizedBox(width: 12),
                _Avatar(
                  url: useAltImages
                      ? 'assets/images/welcome_06.png'
                      : 'assets/images/welcome_02.png',
                ),
              ],
            ),
             const SizedBox(height: 8),
           _ChipText('Laços, amizades e encontros.'),
            const SizedBox(height: 16),
            _ChipText('Menos acaso. Mais afinidade.'),
            const SizedBox(height: 8),
            _ChipText('Histórias reais começam com um simples "Olá".'),
          ],
        ),
      ),
    );
  }
}

class _ChipText extends StatelessWidget {
  final String text;

  const _ChipText(this.text);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String url;

  const _Avatar({required this.url});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundImage: AssetImage(url),
    );
  }
}