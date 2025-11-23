import 'dart:async';
import 'package:flutter/material.dart';
import 'package:twynk_frontend/l10n/app_localizations.dart';
import 'login.dart';
import '../themes/default_dark.dart';
import '../themes/default_light.dart';
import '../themes/nomirro_colors.dart';
import '../services/language_controller.dart';

// -----------------------------------------------------------------------------
// Cores e Temas (compartilhadas em themes/twynk_colors.dart)
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Custom Two-Bar Menu Icon
// -----------------------------------------------------------------------------

class _TwoBarMenuIcon extends StatelessWidget {
  final Color color;
  final double size;

  const _TwoBarMenuIcon({required this.color, this.size = 22});

  @override
  Widget build(BuildContext context) {
    final double barHeight = size * 0.1; // thin bars
    final double topWidth = size;        // longer top bar
    final double bottomWidth = size * 0.7; // shorter bottom bar
    final double spacing = size * 0.28;  // vertical spacing between bars

    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: topWidth,
            height: barHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(barHeight),
            ),
          ),
          SizedBox(height: spacing),
          Container(
            width: bottomWidth,
            height: barHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(barHeight),
            ),
          ),
        ],
      ),
    );
  }
}

 // -----------------------------------------------------------------------------
 // Helpers de tipografia responsiva
 // -----------------------------------------------------------------------------
 double sectionTitleSize(BuildContext context) {
   final double w = MediaQuery.of(context).size.width;
   if (w >= 1024) return 40; // desktop
   if (w >= 600) return 34;  // tablet
   return 28;                 // mobile
 }

 double heroTitleSize(BuildContext context) {
   final double w = MediaQuery.of(context).size.width;
   if (w >= 1280) return 64; // large desktop
   if (w >= 768) return 56;  // desktop/tablet grande
   if (w >= 600) return 48;  // tablet
   return 32;                // mobile
 }

class FAQSection extends StatelessWidget {
  final bool isDark;
  final Color headerBg;
  final Alignment gradientCenter;

  const FAQSection({super.key, required this.isDark, required this.headerBg, this.gradientCenter = const Alignment(-0.6, -0.6)});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // Decide gradient variant based on whether this section is using alt BG or header BG
    final Color sectionBg = headerBg;
    final Color titleColor = isDark ? Colors.white : Colors.black87;
    final Color bodyColor = isDark ? Colors.white70 : Colors.black54;

    return Container(
      decoration: BoxDecoration(
        color: sectionBg,
      ),
      padding: const EdgeInsets.symmetric(vertical: 96.0, horizontal: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  loc.faqTitle,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: sectionTitleSize(context),
                    fontWeight: FontWeight.w900,
                    color: titleColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _faqTile(
                context,
                loc.faqQ1Title,
                loc.faqQ1Body,
                bodyColor,
              ),
              Divider(height: 1, thickness: 1, color: (isDark ? Colors.white : Colors.black).withAlpha(20)),
              _faqTile(
                context,
                loc.faqQ2Title,
                loc.faqQ2Body,
                bodyColor,
              ),
              Divider(height: 1, thickness: 1, color: (isDark ? Colors.white : Colors.black).withAlpha(20)),
              _faqTile(
                context,
                loc.faqQ3Title,
                loc.faqQ3Body,
                bodyColor,
              ),
              Divider(height: 1, thickness: 1, color: (isDark ? Colors.white : Colors.black).withAlpha(20)),
              _faqTile(
                context,
                loc.faqQ4Title,
                loc.faqQ4Body,
                bodyColor,
              ),
              Divider(height: 1, thickness: 1, color: (isDark ? Colors.white : Colors.black).withAlpha(20)),
              _faqTile(
                context,
                loc.faqQ5Title,
                loc.faqQ5Body,
                bodyColor,
              ),
              Divider(height: 1, thickness: 1, color: (isDark ? Colors.white : Colors.black).withAlpha(20)),
              _faqTile(
                context,
                loc.faqQ6Title,
                loc.faqQ6Body,
                bodyColor,
              ),
              Divider(height: 1, thickness: 1, color: (isDark ? Colors.white : Colors.black).withAlpha(20)),
              _faqTile(
                context,
                loc.faqQ7Title,
                loc.faqQ7Body,
                bodyColor,
              ),
              Divider(height: 1, thickness: 1, color: (isDark ? Colors.white : Colors.black).withAlpha(20)),
              _faqTile(
                context,
                loc.faqQ8Title,
                loc.faqQ8Body,
                bodyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _faqTile(BuildContext context, String title, String content, Color bodyColor) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        collapsedIconColor: Theme.of(context).colorScheme.primary,
        iconColor: Theme.of(context).colorScheme.primary,
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        children: [
          Text(
            content,
            style: TextStyle(fontSize: 16, height: 1.5, color: bodyColor),
          ),
        ],
      ),
    );
  }
}

class _AboutMarqueeRow extends StatefulWidget {
  final List<Widget> items;

  const _AboutMarqueeRow({required this.items});

  @override
  State<_AboutMarqueeRow> createState() => _AboutMarqueeRowState();
}

class _AboutMarqueeRowState extends State<_AboutMarqueeRow> with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  Timer? _timer;

  // pixels per tick = speedPxPerSec * (tickMs/1000)
  static const double _speedPxPerSec = 50; // tune for preferred speed
  static const int _tickMs = 16; // ~60fps

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: _tickMs), (_) {
      if (!_controller.hasClients) return;
      final double delta = _speedPxPerSec * (_tickMs / 1000.0);
      final double max = _controller.position.maxScrollExtent;
      double next = _controller.offset + delta;
      if (next >= max) {
        // reset to start for seamless loop
        _controller.jumpTo(0);
      } else {
        _controller.jumpTo(next);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Choose a card width responsive to viewport
        final double maxWidth = constraints.maxWidth;
        double itemWidth = 320;
        if (maxWidth > 1100) itemWidth = 360;
        if (maxWidth < 700) itemWidth = 280;

        final List<Widget> base = widget.items
            .map((w) => SizedBox(width: itemWidth, child: w))
            .toList();
        // Duplicate to allow seamless loop without gap
        final List<Widget> display = [...base, ...base];

        return MouseRegion(
          onEnter: (_) {
            _timer?.cancel();
          },
          onExit: (_) {
            _start();
          },
          child: SizedBox(
            height: 300, // increased to avoid text overflow on narrow widths
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: display.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: display[index],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  final ThemeMode themeMode;
  final Function(bool isDark) onThemeToggle;

  const WelcomePage({super.key, required this.themeMode, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return NomirroLandingPage(
      themeMode: themeMode,
      onThemeToggle: onThemeToggle,
    );
  }
}

class NomirroLandingPage extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(bool isDark) onThemeToggle;

  const NomirroLandingPage({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  State<NomirroLandingPage> createState() => _NomirroLandingPageState();
}

class _NomirroLandingPageState extends State<NomirroLandingPage> {
  final GlobalKey heroKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey howItWorksKey = GlobalKey();
  final GlobalKey featuresKey = GlobalKey();
  final GlobalKey downloadKey = GlobalKey();

  bool _drawerOpen = false;

  final ScrollController _scrollController = ScrollController();
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.hasClients && _scrollController.offset > 300;
      if (show != _showFab) {
        setState(() => _showFab = show);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToSection(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutQuad,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.themeMode == ThemeMode.dark || (widget.themeMode == ThemeMode.system && Theme.of(context).brightness == Brightness.dark);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 768;
    final bool isMobile = screenWidth < 600;

    final Color headerBg = Theme.of(context).scaffoldBackgroundColor;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: headerBg,
        textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme.apply(
          bodyColor: isDark ? Colors.white70 : Colors.black87,
          displayColor: isDark ? Colors.white : Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: headerBg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: colorScheme.primary),
        ),
      ),
      child: Scaffold(
        drawerScrimColor: Colors.transparent,
        onDrawerChanged: (open) => setState(() => _drawerOpen = open),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64.0),
          child: _NomirroAppBar(
            isDesktop: isDesktop,
            isDark: isDark,
            onThemeToggle: widget.onThemeToggle,
            scrollToSection: scrollToSection,
            aboutKey: aboutKey,
            howItWorksKey: howItWorksKey,
            featuresKey: featuresKey,
            downloadKey: downloadKey,
            drawerOpen: _drawerOpen,
            headerBg: headerBg,
          ),
        ),
        drawer: isDesktop ? null : Builder(
          builder: (ctx) {
            final double statusBarTop = MediaQuery.of(ctx).padding.top;
            final double appBarHeight = Theme.of(ctx).appBarTheme.toolbarHeight ?? 64.0;
            final double drawerTopOffset = statusBarTop + appBarHeight - 1.0;
            return Padding(
              padding: EdgeInsets.only(top: drawerTopOffset),
              child: _NomirroDrawer(
                scrollToSection: scrollToSection,
                aboutKey: aboutKey,
                howItWorksKey: howItWorksKey,
                featuresKey: featuresKey,
                downloadKey: downloadKey,
                isDark: isDark,
                headerBg: headerBg,
              ),
            );
          },
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              _HeroSection(key: heroKey, isDark: isDark, headerBg: headerBg),
              _AboutSection(key: aboutKey, isDesktop: isDesktop, isDark: isDark, headerBg: headerBg, gradientCenter: const Alignment(0.6, -0.6)),
              _HowItWorksSection(key: howItWorksKey, isDesktop: isDesktop, isDark: isDark, sectionBg: headerBg, gradientCenter: const Alignment(-0.6, -0.6)),
              _FeaturesSection(key: featuresKey, isDesktop: isDesktop, isDark: isDark, sectionBg: headerBg, gradientCenter: const Alignment(0.6, -0.6)),
              FAQSection(isDark: isDark, headerBg: headerBg, gradientCenter: const Alignment(-0.6, -0.6)),
              _DownloadSection(key: downloadKey, isDark: isDark, sectionBg: headerBg, gradientCenter: const Alignment(0.6, -0.6)),
              _NomirroFooter(isDark: isDark, headerBg: headerBg),
            ],
          ),
        ),
        floatingActionButton: AnimatedSlide(
          duration: const Duration(milliseconds: 200),
          offset: _showFab ? Offset.zero : const Offset(0, 1.5),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _showFab ? 1 : 0,
            child: FloatingActionButton(
              onPressed: () {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                  );
                }
              },
              mini: isMobile,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              child: const Icon(Icons.arrow_upward),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// AppBar (Cabeçalho) (Mantido como antes)
// -----------------------------------------------------------------------------

class _NomirroAppBar extends StatelessWidget {
  final bool isDesktop;
  final bool isDark;
  final Function(bool isDark) onThemeToggle;
  final Function(GlobalKey key) scrollToSection;
  final GlobalKey aboutKey;
  final GlobalKey howItWorksKey;
  final GlobalKey featuresKey;
  final GlobalKey downloadKey;
  final bool drawerOpen;
  final Color headerBg;

  const _NomirroAppBar({
    required this.isDesktop,
    required this.isDark,
    required this.onThemeToggle,
    required this.scrollToSection,
    required this.aboutKey,
    required this.howItWorksKey,
    required this.featuresKey,
    required this.downloadKey,
    required this.drawerOpen,
    required this.headerBg,
  });

  @override
  Widget build(BuildContext context) {
    final String appBarHex = '#${headerBg.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    debugPrint('Nomirro Color Debug -> AppBar BG: $appBarHex');
    return AppBar(
      backgroundColor: headerBg,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: isDesktop
          ? null
          : Builder(
              builder: (ctx) {
                final Color iconColor = Theme.of(ctx).appBarTheme.iconTheme?.color ?? Theme.of(ctx).colorScheme.primary;
                return IconButton(
                  tooltip: drawerOpen ? 'Fechar menu' : 'Abrir menu',
                  onPressed: () {
                    if (drawerOpen) {
                      Navigator.of(ctx).pop();
                    } else {
                      Scaffold.of(ctx).openDrawer();
                    }
                  },
                  icon: drawerOpen
                      ? Icon(Icons.close, color: iconColor)
                      : _TwoBarMenuIcon(color: iconColor, size: 22),
                );
              },
            ),
      title: const _NomirroLogo(),
      centerTitle: false,
      titleSpacing: isDesktop ? 96.0 : 4.0,
      actions: <Widget>[
        if (isDesktop) ..._buildDesktopNav(context),
        _buildLanguageButton(context),
        _buildThemeToggleButton(context),
        if (isDesktop) const SizedBox(width: 96) else const SizedBox(width: 16),
      ],
    );
  }

  List<Widget> _buildDesktopNav(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return [
      TextButton(
        onPressed: () => scrollToSection(aboutKey),
        child: Text(
          loc.navAbout,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
      TextButton(
        onPressed: () => scrollToSection(howItWorksKey),
        child: Text(
          loc.navHowItWorks,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
      TextButton(
        onPressed: () => scrollToSection(featuresKey),
        child: Text(
          loc.navFeatures,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        },
        child: Text(
          loc.navLogin,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0),
        child: ElevatedButton(
          onPressed: () => scrollToSection(downloadKey),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            elevation: 4,
          ),
          child: Text(
            loc.navSignUp,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];
  }

  Widget _buildLanguageButton(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Idioma / Language',
      icon: const Icon(Icons.language),
      position: PopupMenuPosition.under,
      offset: const Offset(0, 4),
      onSelected: (value) {
        final lang = value == 'en' ? AppLanguage.en : AppLanguage.pt;
        LanguageController.instance.setLanguage(lang);
      },
      itemBuilder: (context) => const [
        PopupMenuItem<String>(
          value: 'pt',
          child: Text('Português'),
        ),
        PopupMenuItem<String>(
          value: 'en',
          child: Text('English'),
        ),
      ],
    );
  }

  Widget _buildThemeToggleButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        isDark ? Icons.light_mode : Icons.dark_mode,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: () => onThemeToggle(!isDark),
      tooltip: isDark ? 'Alternar para Tema Claro' : 'Alternar para Tema Escuro',
    );
  }
}

// -----------------------------------------------------------------------------
// Drawer (Menu Mobile) (Mantido como antes)
// -----------------------------------------------------------------------------

class _NomirroDrawer extends StatelessWidget {
  final Function(GlobalKey key) scrollToSection;
  final GlobalKey aboutKey;
  final GlobalKey howItWorksKey;
  final GlobalKey featuresKey;
  final GlobalKey downloadKey;
  final bool isDark;
  final Color headerBg;

  const _NomirroDrawer({
    required this.scrollToSection,
    required this.aboutKey,
    required this.howItWorksKey,
    required this.featuresKey,
    required this.downloadKey,
    required this.isDark,
    required this.headerBg,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final Color drawerBg = headerBg;
    final String headerHex = '#${headerBg.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    final String drawerHex = '#${drawerBg.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    debugPrint('Nomirro Color Debug -> Header BG: $headerHex, Drawer BG: $drawerHex');
    return Drawer(
      backgroundColor: drawerBg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: drawerBg,
          scaffoldBackgroundColor: drawerBg,
          colorScheme: Theme.of(context).colorScheme.copyWith(
            surface: drawerBg,
            surfaceTint: Colors.transparent,
          ),
        ),
        child: Container(
          color: drawerBg,
          child: ListTileTheme(
            tileColor: drawerBg,
            child: Material(
              color: drawerBg,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        _buildDrawerItem(context, loc.navAbout, aboutKey, icon: Icons.info_outline),
                        _buildDrawerItem(context, loc.navHowItWorks, howItWorksKey, icon: Icons.help_outline),
                        _buildDrawerItem(context, loc.navFeatures, featuresKey, icon: Icons.favorite_border),
                        _buildDrawerItem(context, loc.navLogin, null, icon: Icons.login),
                        _buildDrawerItem(context, loc.navSignUp, downloadKey, icon: Icons.app_registration, isPrimary: true),
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            loc.footerCopyright,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, GlobalKey? key, {bool isPrimary = false, required IconData icon}) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
        leading: Icon(
          icon,
          color: isPrimary ? colorScheme.primary : (isDark ? Colors.white70 : Colors.black54),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: isPrimary ? colorScheme.primary : (isDark ? Colors.white : Colors.black87),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (title == 'Login') {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
            return;
          }
          if (key != null) {
            scrollToSection(key);
          }
        },
      ),
    );
  }
}


// -----------------------------------------------------------------------------
// Logo Widget (Mantido como antes)
// -----------------------------------------------------------------------------

class _NomirroLogo extends StatelessWidget {
  const _NomirroLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Image.asset('assets/icons/logo_02.png'),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Seção Hero (COM AJUSTE DE BORDA E SOMBRA 3D NO CARROSSEL)
// -----------------------------------------------------------------------------

class _HeroSection extends StatefulWidget {
  final bool isDark;
  final Color headerBg;
  
  const _HeroSection({super.key, required this.isDark, required this.headerBg});

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final List<String> _heroImages = [
    'assets/images/hero_01.png',
    'assets/images/hero_02.png',
    'assets/images/hero_03.png',
    'assets/images/hero_04.png',
  ];
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Inicia rotação automática das imagens
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() {
        _currentPage = (_currentPage + 1) % (_heroImages.isNotEmpty ? _heroImages.length : 1);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache hero images to make theme switching smoother
    for (final path in _heroImages) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 768;
    final bool isTablet = screenWidth > 600 && screenWidth <= 768;

    return Container(
      decoration: BoxDecoration(
        color: widget.headerBg,
      ), 
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 96.0 : 60.0,
        horizontal: isDesktop ? 48.0 : 24.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isDesktop || isTablet
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: _buildTextContent(context, TextAlign.left),
        ),
        const SizedBox(width: 64, height: 80),
        Expanded(
          flex: 1,
          child: _buildImageCarousel(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildTextContent(context, TextAlign.center),
        const SizedBox(height: 48),
        _buildImageCarousel(context),
      ],
    );
  }

  Widget _buildTextContent(BuildContext context, TextAlign textAlign) {
    final double w = MediaQuery.of(context).size.width;
    final bool isMobile = w <= 600;
    final TextAlign titleAlign = isMobile ? TextAlign.justify : textAlign;
    final loc = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String titleText = loc.heroTitle;
    final String subtitleText = loc.heroSubtitle;
    final String ctaText = loc.heroCta;

    return Column(
      crossAxisAlignment: textAlign == TextAlign.left
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          titleText,
          textAlign: titleAlign,
          style: TextStyle(
            fontSize: heroTitleSize(context),
            fontWeight: FontWeight.w900,
            height: 1.1,
            color: widget.isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          subtitleText,
          textAlign: titleAlign,
          style: TextStyle(
            fontSize: w > 600 ? 22 : 16,
            color: widget.isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 40),
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () { /* Baixar Agora */ },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 8,
                  ),
                  child: Text(ctaText,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        else
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: textAlign == TextAlign.left
                ? WrapAlignment.start
                : WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () { /* Baixar Agora */ },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 10,
                ),
                child: Text(
                  ctaText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildImageCarousel(BuildContext context) {
    final double carouselHeight = MediaQuery.of(context).size.width > 768 ? 550 : 400;

    final String currentPath = _heroImages.isNotEmpty
      ? _heroImages[_currentPage % _heroImages.length]
      : (widget.isDark ? 'assets/images/hero_02.png' : 'assets/images/hero_01.png');
    final String prevPath = _heroImages.isNotEmpty
        ? _heroImages[(_currentPage - 1 + _heroImages.length) % _heroImages.length]
        : currentPath;
    final String nextPath = _heroImages.isNotEmpty
        ? _heroImages[(_currentPage + 1) % _heroImages.length]
        : currentPath;

  return Container(
    height: carouselHeight,
    decoration: const BoxDecoration(),
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Back-left (previous)
        Transform.translate(
          offset: const Offset(-32.0, 4.0),
          child: Transform.rotate(
            angle: -0.035,
            child: Transform.scale(
              scale: 0.9,
              child: Opacity(
                opacity: 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    prevPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Back-right (next)
        Transform.translate(
          offset: const Offset(32.0, 4.0),
          child: Transform.rotate(
            angle: 0.035,
            child: Transform.scale(
              scale: 0.9,
              child: Opacity(
                opacity: 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    nextPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Front (current) with shadow, repaint boundary and animation
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(31),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: RepaintBoundary(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                return FadeTransition(
                  opacity: curved,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero).animate(curved),
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
                      child: child,
                    ),
                  ),
                );
              },
              child: Image.asset(
                currentPath,
                key: ValueKey(currentPath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  final fallback = _heroImages.isNotEmpty ? _heroImages.first : currentPath;
                  return Image.asset(
                    fallback,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: widget.isDark ? DefaultDark.sidebar : DefaultLight.bg,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: widget.isDark ? Colors.white30 : Colors.grey,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        ),
      ],
    ),
  );
  }
}

class _AboutSection extends StatelessWidget {
  final bool isDesktop;
  final bool isDark;
  final Color headerBg;
  final Alignment gradientCenter;

  const _AboutSection({super.key, required this.isDesktop, required this.isDark, required this.headerBg, this.gradientCenter = const Alignment(-0.6, -0.6)});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: headerBg,
      ),
      padding: const EdgeInsets.symmetric(vertical: 96.0, horizontal: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                loc.aboutTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: sectionTitleSize(context),
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                loc.aboutParagraph1,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 20,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                loc.aboutParagraph2,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 18,
                  color: isDark ? Colors.white60 : Colors.black45,
                ),
              ),
              const SizedBox(height: 56),

              Builder(builder: (context) {
                final children = [
                  _AboutItem(icon: Icons.favorite_border, title: loc.aboutItem1Title, description: loc.aboutItem1Body, isDark: isDark),
                  _AboutItem(icon: Icons.place_outlined, title: loc.aboutItem2Title, description: loc.aboutItem2Body, isDark: isDark),
                  _AboutItem(icon: Icons.chat_bubble_outline, title: loc.aboutItem3Title, description: loc.aboutItem3Body, isDark: isDark),
                  _AboutItem(icon: Icons.balance_outlined, title: loc.aboutItem4Title, description: loc.aboutItem4Body, isDark: isDark),
                  _AboutItem(icon: Icons.auto_awesome, title: loc.aboutItem5Title, description: loc.aboutItem5Body, isDark: isDark),
                  _AboutItemPremium(isDark: isDark),
                ];
                final double w = MediaQuery.of(context).size.width;
                final bool isMobile = w < 700;
                if (isMobile) {
                  return Column(
                    children: [
                      for (int i = 0; i < children.length; i++) ...[
                        if (i > 0) const SizedBox(height: 16),
                        children[i],
                      ]
                    ],
                  );
                }
                return _AboutMarqueeRow(items: children);
              }),

              const SizedBox(height: 56),

            ],
          ),
        ),
      ),
    );
  }
}

class _AboutItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDark;

  const _AboutItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  State<_AboutItem> createState() => _AboutItemState();
}

class _AboutItemState extends State<_AboutItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: _hover ? 2.0 : 1.0,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withAlpha(38),
                      blurRadius: 18,
                      spreadRadius: 0,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: NomirroColors.accentLight.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NomirroColors.accentDark.withAlpha(128), width: 1.5),
                ),
                alignment: Alignment.center,
                child: Icon(widget.icon, color: Theme.of(context).colorScheme.secondary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: widget.isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: widget.isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutItemPremium extends StatefulWidget {
  final bool isDark;

  const _AboutItemPremium({required this.isDark});

  @override
  State<_AboutItemPremium> createState() => _AboutItemPremiumState();
}

class _AboutItemPremiumState extends State<_AboutItemPremium> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: _hover ? 2.0 : 1.0,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withAlpha(38),
                      blurRadius: 18,
                      spreadRadius: 0,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: NomirroColors.accentLight.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NomirroColors.accentDark.withAlpha(128), width: 1.5),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.workspace_premium, color: NomirroColors.accentDark, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.aboutPremiumTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: widget.isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      loc.aboutPremiumBody,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: widget.isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutCarouselGrid extends StatefulWidget {
  final List<Widget> items;

  const _AboutCarouselGrid({required this.items});

  @override
  State<_AboutCarouselGrid> createState() => _AboutCarouselGridState();
}

class _AboutCarouselGridState extends State<_AboutCarouselGrid> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  List<List<Widget>> _pages = const [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _buildPages();
    _startAutoScroll();
  }

  void _buildPages() {
    final List<Widget> items = List.of(widget.items);
    _pages = [];
    for (int i = 0; i < items.length; i += 6) {
      _pages.add(items.sublist(i, i + 6 > items.length ? items.length : i + 6));
    }
    if (_pages.isEmpty) {
      _pages = [[]];
    }
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || _pages.isEmpty) return;
      setState(() {
        _currentPage = (_currentPage + 1) % _pages.length;
      });
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant _AboutCarouselGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _buildPages();
      _currentPage = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double horizontalGap = 24;
        final double verticalGap = 24;
        final int columns = 3;
        final int rows = 2;
        final double totalHGap = horizontalGap * (columns - 1);
        final double itemWidth = (maxWidth - totalHGap) / columns;
        final double approxItemHeight = 260; // increased further to prevent bottom overflow and show full text
        final double gridHeight = rows * approxItemHeight + verticalGap * (rows - 1);

        return SizedBox(
          width: double.infinity,
          height: gridHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            padEnds: true,
            itemBuilder: (context, pageIndex) {
              final pageItems = _pages[pageIndex];
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: verticalGap,
                  crossAxisSpacing: horizontalGap,
                  childAspectRatio: itemWidth / approxItemHeight,
                ),
                itemCount: pageItems.length,
                itemBuilder: (context, index) {
                  return pageItems[index];
                },
              );
            },
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// Seção Como Funciona (Mantido como antes)
// -----------------------------------------------------------------------------

class _HowItWorksSection extends StatelessWidget {
  final bool isDesktop;
  final bool isDark;
  final Color sectionBg;
  final Alignment gradientCenter;
  
  const _HowItWorksSection({super.key, required this.isDesktop, required this.isDark, required this.sectionBg, this.gradientCenter = const Alignment(-0.6, -0.6)});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final steps = [
      _HowItWorksStep(
        number: '01',
        title: loc.howStep1Title,
        description: loc.howStep1Body,
        icon: Icons.person_add_alt_1,
      ),
      _HowItWorksStep(
        number: '02',
        title: loc.howStep2Title,
        description: loc.howStep2Body,
        icon: Icons.swipe,
      ),
      _HowItWorksStep(
        number: '03',
        title: loc.howStep3Title,
        description: loc.howStep3Body,
        icon: Icons.chat_bubble_outline,
      ),
    ];
    return Container(
      decoration: BoxDecoration(
        color: sectionBg,
      ),
      padding: const EdgeInsets.symmetric(vertical: 96.0, horizontal: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Text(
                loc.howTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: sectionTitleSize(context),
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).textTheme.displayLarge?.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                loc.howSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(204),
                ),
              ),
              const SizedBox(height: 80),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (isDesktop || constraints.maxWidth > 700) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: steps[0]),
                        const SizedBox(width: 40),
                        Expanded(child: steps[1]),
                        const SizedBox(width: 40),
                        Expanded(child: steps[2]),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        steps[0],
                        const SizedBox(height: 48),
                        steps[1],
                        const SizedBox(height: 48),
                        steps[2],
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HowItWorksStep extends StatefulWidget {
  final String number;
  final String title;
  final String description;
  final IconData icon;

  const _HowItWorksStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  State<_HowItWorksStep> createState() => _HowItWorksStepState();
}

class _HowItWorksStepState extends State<_HowItWorksStep> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: _hover ? 2.0 : 1.0,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withAlpha(38),
                      blurRadius: 18,
                      spreadRadius: 0,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withAlpha(128), width: 1.5),
                ),
                alignment: Alignment.center,
                child: Icon(widget.icon, color: Theme.of(context).colorScheme.primary, size: 32),
              ),
              const SizedBox(height: 24),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(179),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Seção de Recursos (Features)
// -----------------------------------------------------------------------------

class _FeaturesSection extends StatelessWidget {
  final bool isDesktop;
  final bool isDark;
  final Color sectionBg;
  final Alignment gradientCenter;
  
  const _FeaturesSection({super.key, required this.isDesktop, required this.isDark, required this.sectionBg, this.gradientCenter = const Alignment(-0.6, -0.6)});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: sectionBg,
      ),
      padding: const EdgeInsets.symmetric(vertical: 96.0, horizontal: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                loc.featuresTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: sectionTitleSize(context),
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                loc.featuresSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 80),

              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  double cardHeight = 200;

                  if (isDesktop || constraints.maxWidth > 900) {
                    crossAxisCount = 3;
                    cardHeight = 240;
                  } else if (constraints.maxWidth > 550) {
                    crossAxisCount = 2;
                    cardHeight = 220;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 32,
                      mainAxisSpacing: 32,
                      mainAxisExtent: cardHeight,
                    ),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return _FeatureCard(
                            icon: Icons.flash_on,
                            title: loc.feature1Title,
                            description: loc.feature1Body,
                            height: cardHeight,
                          );
                        case 1:
                          return _FeatureCard(
                            icon: Icons.verified_user,
                            title: loc.feature2Title,
                            description: loc.feature2Body,
                            height: cardHeight,
                          );
                        default:
                          return _FeatureCard(
                            icon: Icons.security,
                            title: loc.feature3Title,
                            description: loc.feature3Body,
                            height: cardHeight,
                          );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final double height;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.height,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Material(
          elevation: 0,
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          animationDuration: Duration.zero,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: widget.height,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: _hover ? 2.0 : 1.0,
              ),
              boxShadow: _hover
                  ? [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withAlpha(isDark ? 51 : 38),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(widget.icon, color: Theme.of(context).colorScheme.secondary, size: 28),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    widget.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Seção de Download (CTA Final) 
// -----------------------------------------------------------------------------

class _DownloadSection extends StatelessWidget {
  final bool isDark;
  final Color sectionBg;
  final Alignment gradientCenter;
  
  const _DownloadSection({super.key, required this.isDark, required this.sectionBg, this.gradientCenter = const Alignment(-0.6, -0.6)});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: sectionBg,
      ),
      padding: const EdgeInsets.symmetric(vertical: 96.0, horizontal: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Text(
                loc.ctaTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: sectionTitleSize(context),
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                loc.ctaSubtitle,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 48),
              Builder(builder: (context) {
                final double w = MediaQuery.of(context).size.width;
                final bool isMobile = w < 600;
                final buttons = <Widget>[
                  _StoreButton(
                    assetIconPath: 'assets/icons/app_store.png',
                    text: loc.ctaAppStore,
                    backgroundColor: colorScheme.primary,
                    textColor: colorScheme.onPrimary,
                    onPressed: () { /* Link App Store */ },
                  ),
                  const SizedBox(width: 12),
                  _StoreButton(
                    assetIconPath: 'assets/icons/play_store.png',
                    text: loc.ctaPlayStore,
                    backgroundColor: colorScheme.primary,
                    textColor: colorScheme.onPrimary,
                    onPressed: () { /* Link Google Play */ },
                  ),
                ];
                if (isMobile) {
                  return Row(
                    children: [
                      Expanded(child: buttons[0]),
                      buttons[1],
                      Expanded(child: buttons[2]),
                    ],
                  );
                }
                return Wrap(
                  spacing: 24,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: buttons,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreButton extends StatelessWidget {
  final String? assetIconPath;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _StoreButton({
    this.assetIconPath,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final bool isMobile = w < 600;
    final bool isVerySmall = w < 360;

    final EdgeInsetsGeometry btnPadding = isMobile
        ? (isVerySmall
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 12))
        : const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    final double iconSz = isMobile ? (isVerySmall ? 22 : 24) : 28;
    final double fontSz = isMobile ? (isVerySmall ? 15 : 16) : 18;
    final double radius = isMobile ? (isVerySmall ? 10 : 12) : 15;
    final double elevation = isMobile ? 4 : 8;

    final Widget leadingWidget = (assetIconPath != null)
        ? Image.asset(assetIconPath!, width: iconSz, height: iconSz, fit: BoxFit.contain)
        : Icon(Icons.apps, size: iconSz);

    final Widget button = ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: btnPadding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        elevation: elevation,
        side: backgroundColor == Colors.white ? BorderSide(color: Colors.grey.shade300) : null,
      ),
      icon: leadingWidget,
      label: Text(text, style: TextStyle(fontSize: fontSz, fontWeight: FontWeight.w700)),
    );

    return button;
  }
}

// -----------------------------------------------------------------------------
// Rodapé (Footer) 
// -----------------------------------------------------------------------------

class _NomirroFooter extends StatelessWidget {
  final bool isDark;
  final Color headerBg;
  
  const _NomirroFooter({
    required this.isDark,
    required this.headerBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: headerBg,
        border: Border(
          top: BorderSide(
            color: isDark 
                ? Colors.white.withAlpha(25) 
                : Colors.black.withAlpha(25),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Image.asset('assets/icons/logo_02.png', height:32),
                ],
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 600;

                  if (isMobile) {
                    return Column(
                      children: [
                        _linkRow(context),
                        const SizedBox(height: 24),
                        _copyrightText(context),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _copyrightText(context),
                        _linkRow(context),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _copyrightText(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Text(
      loc.footerCopyright,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: isDark ? Colors.white54 : Colors.black54,
        fontSize: 14,
      ),
    );
  }

  Widget _linkRow(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _FooterLink(
          label: loc.footerTerms,
          onPressed: () { /* Link Termos de Uso */ },
          isDark: isDark,
        ),
        _FooterLink(
          label: loc.footerPrivacy,
          onPressed: () { /* Link Política de Privacidade */ },
          isDark: isDark,
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isDark;

  const _FooterLink({
    required this.label,
    required this.onPressed,
    required this.isDark,
  });

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton(
        onPressed: widget.onPressed,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: _isHovered
                ? Theme.of(context).colorScheme.primary
                : (widget.isDark ? Colors.white70 : Colors.black54),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}