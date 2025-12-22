import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  int _currentIndex = 0;
  Offset _parallaxOffset = Offset.zero;
  Timer? _carouselTimer;

  final List<String> _carouselItems = const [
    'assets/images/welcome_01.jpg',
    'assets/images/welcome_02.jpg',
    'assets/images/welcome_03.jpg',
  ];

  @override
  void initState() {
    super.initState();

    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _carouselItems.length;
      });
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    super.dispose();
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity == null) return;
    if (details.primaryVelocity! > 0) {
      setState(() {
        _currentIndex =
            (_currentIndex - 1 + _carouselItems.length) % _carouselItems.length;
      });
    } else if (details.primaryVelocity! < 0) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _carouselItems.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: MouseRegion(
        onHover: (event) {
          final w = size.width;
          final h = size.height;
          setState(() {
            _parallaxOffset = Offset(
              (event.localPosition.dx / w - 0.5) * 20,
              (event.localPosition.dy / h - 0.5) * 20,
            );
          });
        },
        child: GestureDetector(
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: Stack(
            children: [
              // Fundo com carrossel + parallax
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.translationValues(
                  _parallaxOffset.dx,
                  _parallaxOffset.dy,
                  0,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1200),
                  child: Container(
                    key: ValueKey<int>(_currentIndex),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(_carouselItems[_currentIndex]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              // Overlay gradiente para legibilidade
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.95),
                    ],
                  ),
                ),
              ),

              // Conteúdo principal
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const Spacer(),
                      _buildMainContent(context),
                      const Spacer(),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/icons/logo_02.png',
              height: 54,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 6),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  cs.primary,
                  cs.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: const Text(
                'Nomirro',
                style: TextStyle(
                  fontFamily: 'Michroma',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            _NavLink(
              label: 'Informações legais',
              color: Colors.white70,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LegalInfoPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;

    final Widget buttons = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: cs.onPrimary,
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: const Text('Criar Conta'),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    side:
                        BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    backgroundColor:
                        Colors.white.withValues(alpha: 0.05),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: const Text('Já tenho conta'),
                ),
              ),
            ],
          )
        : Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cs.primary, cs.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: cs.onPrimary,
                  ),
                  child: const Text('Criar Conta'),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  side:
                      BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Já tenho conta'),
              ),
            ],
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // badge de online
        //ClipRRect(
          //borderRadius: BorderRadius.circular(50),
          //child: BackdropFilter(
           // filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
           // child: Container(
              //padding:
                  //const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //color: Colors.white.withValues(alpha: 0.05),
              //child: Row(
               // mainAxisSize: MainAxisSize.min,
                //children: [
                  // Container(
                  //   width: 8,
                  //   height: 8,
                  //   decoration: const BoxDecoration(
                  //     color: Colors.green,
                  //     shape: BoxShape.circle,
                  //   ),
                  // ),
                  // const SizedBox(width: 8),
                  // const Text(
                  //   '2,430 pessoas online agora',
                  //   style: TextStyle(fontSize: 12),
                  // ),
               // ],
             // ),
            //),
          //),
        //),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: cs.primary.withValues(alpha: 0.7),
            ),
          ),
          child: const Text(
            'Bem-vindo à Nomirro',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Encontre pessoas que querem o mesmo que você.',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Uma comunidade inclusiva para amizades, encontros e relacionamentos sérios. '
          'Descubra conexões autênticas em um ambiente seguro e acolhedor.',
          style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
        ),
        const SizedBox(height: 32),
        buttons,
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: List.generate(_carouselItems.length, (index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              margin: const EdgeInsets.only(right: 8),
              height: 4,
              width: isActive ? 40 : 24,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        Row(
          children: [
            _buildSocialIcon(FontAwesomeIcons.tiktok),
            const SizedBox(width: 16),
            _buildSocialIcon(FontAwesomeIcons.facebook),
            const SizedBox(width: 16),
            _buildSocialIcon(FontAwesomeIcons.instagram),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return InkWell
(
      onTap: () {
        // TODO: adicionar navegação para redes sociais quando os links estiverem definidos
      },
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999),
        ),
        child: FaIcon(
          icon,
          color: Colors.white.withValues(alpha: 0.90),
          size: 18,
        ),
      ),
    );
  }
}
class LegalInfoPage extends StatelessWidget {
  const LegalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações Legais'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '1. Termos de Uso',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '1.1 Aceitação dos Termos\n'
              'Ao acessar ou usar o app Nomirro, você concorda com estes Termos de Uso e com nossa Política de Privacidade. '
              'Caso não concorde com algum item, não utilize o app.\n\n'
              '1.2 Requisitos de Idade\n'
              'O app é destinado apenas a maiores de 18 anos. Ao se registrar, você declara que possui idade legal para uso do app.\n\n'
              '1.3 Cadastro e Conta\n\n'
              '• É necessário fornecer informações verdadeiras no cadastro.\n'
              '• Cada usuário é responsável pela segurança de sua senha e dados de acesso.\n'
              '• Você é responsável por todas as atividades realizadas em sua conta.\n\n'
              '1.4 Uso Adequado\n\n'
              '• É proibido enviar conteúdo ofensivo, pornográfico, racista, discriminatório ou que viole leis locais.\n'
              '• É proibido usar o app para atividades comerciais não autorizadas.\n'
              '• O Nomirro reserva-se o direito de suspender ou excluir contas que violem os termos.\n\n'
              '1.5 Responsabilidade\n\n'
              '• O app não se responsabiliza por encontros presenciais entre usuários.\n'
              '• Todo conteúdo compartilhado é de responsabilidade exclusiva de quem o publica.\n'
              '• O app não garante compatibilidade ou sucesso em relacionamentos.\n\n'
              '1.6 Modificações\n'
              'O Nomirro pode alterar estes Termos de Uso a qualquer momento, sendo responsabilidade do usuário verificar periodicamente.\n\n'
              '2. Política de Privacidade\n\n'
              '2.1 Coleta de Dados\n'
              'Coletamos dados fornecidos pelo usuário, como: Nome, idade, gênero, localização aproximada, fotos e informações de perfil, '
              'além de dados de uso do app (interações, preferências e mensagens).\n\n'
              '2.2 Uso dos Dados\n\n'
              '• Melhorar a experiência do usuário e personalizar sugestões de match.\n'
              '• Enviar notificações sobre o app, promoções e atualizações.\n'
              '• Garantir segurança e prevenção de fraudes.\n\n'
              '2.3 Compartilhamento de Dados\n\n'
              '• Não vendemos dados a terceiros.\n'
              '• Podemos compartilhar dados com fornecedores de serviços que auxiliam na operação do app, sempre protegendo a privacidade.\n\n'
              '2.4 Segurança\n'
              'Adotamos medidas técnicas e organizacionais para proteger os dados do usuário, mas não podemos garantir 100% de segurança.\n\n'
              '2.5 Direitos do Usuário\n\n'
              '• O usuário pode solicitar acesso, correção ou exclusão de seus dados.\n'
              '• O usuário pode retirar o consentimento para uso de dados a qualquer momento.\n\n'
              '3. Política de Cancelamento e Exclusão de Conta\n\n'
              '• O usuário pode excluir sua conta a qualquer momento através das configurações do app.\n'
              '• Após exclusão, seus dados serão removidos, exceto informações que precisem ser retidas por exigências legais.\n\n'
              '4. Contato Legal\n\n'
              'Para dúvidas sobre os Termos de Uso ou Política de Privacidade, entre em contato:\n'
              'Email: suporte@nomirro.com',
              style: TextStyle(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const _NavLink({required this.label, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? Colors.white70,
      ),
    );

    if (onTap == null) {
      return textWidget;
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: textWidget,
      ),
    );
  }
}

// ================= COMPONENTES =================