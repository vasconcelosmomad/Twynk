import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twynk_frontend/portals/app_bar.dart';
import 'package:twynk_frontend/portals/drawer.dart';
import 'package:twynk_frontend/portals/footer.dart';
import 'package:twynk_frontend/pages/encounters.dart';
import 'package:twynk_frontend/pages/ping.dart';
import 'package:twynk_frontend/pages/snaps.dart';
import 'package:twynk_frontend/pages/chat.dart';
import 'package:twynk_frontend/pages/login.dart';
import 'package:twynk_frontend/pages/payment_screen.dart';
import 'package:twynk_frontend/services/api_client.dart';

// ==================== BENEFÍCIOS ====================
final benefits = [
  Benefit(
      key: 'viewProfiles',
      label: 'Visualizar perfis',
      icon: Icons.person_search),
  Benefit(
      key: 'dailyLikes',
      label: 'Curtidas por dia',
      icon: Icons.favorite),
  Benefit(
      key: 'sendMessages',
      label: 'Enviar mensagens (não real time)',
      icon: Icons.mail_outline),
  Benefit(
      key: 'requestChat',
      label: 'Solicitar chat/vídeo',
      icon: Icons.videocam),
  Benefit(
      key: 'videoChatTime',
      label: 'Tempo de vídeo chat',
      icon: Icons.schedule),
  Benefit(
      key: 'seeWhoLiked',
      label: 'Ver quem curtiu você',
      icon: Icons.visibility),
  Benefit(
      key: 'privatePhotos',
      label: 'Envio de fotos privadas',
      icon: Icons.lock),
  Benefit(
      key: 'boosts',
      label: 'Boost (destaque no feed)',
      icon: Icons.flash_on),
  Benefit(
      key: 'initialCredits',
      label: 'Créditos iniciais',
      icon: Icons.trending_up),
  Benefit(
      key: 'prioritySupport',
      label: 'Suporte prioritário',
      icon: Icons.support_agent),
];

class Benefit {
  final String key;
  final String label;
  final IconData icon;
  Benefit({required this.key, required this.label, required this.icon});
}

// ==================== PLANOS ====================
class AppPlan {
  final String id;
  final String name;
  final String price;
  final String billing;
  final String description;
  final bool isPopular;

  final Map<String, String> benefits;

  final List<Color> gradient;
  final List<Color> buttonGradient;
  final Color accent;

  AppPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.billing,
    required this.description,
    required this.isPopular,
    required this.benefits,
    required this.gradient,
    required this.buttonGradient,
    required this.accent,
  });
}

final plans = [
  AppPlan(
    id: 'free',
    name: 'Gratuito',
    price: '0 MT',
    billing: 'Sempre',
    description: 'Comece a explorar sem custo.',
    accent: Colors.grey,
    gradient: [Colors.grey.shade100, Colors.grey.shade300],
    buttonGradient: [Colors.grey.shade500, Colors.grey.shade700],
    isPopular: false,
    benefits: {
      'viewProfiles': 'Sim',
      'dailyLikes': '10',
      'sendMessages': '5/dia',
      'requestChat': 'Não',
      'videoChatTime': 'Não',
      'seeWhoLiked': 'Não',
      'privatePhotos': 'Não',
      'boosts': 'Não',
      'initialCredits': '0',
      'prioritySupport': 'Não',
    },
  ),
  AppPlan(
    id: 'weekly',
    name: 'Semanal',
    price: '35 MT',
    billing: 'por semana',
    description: 'Ideal para testar os recursos premium.',
    accent: Colors.amber.shade600,
    gradient: [Colors.yellow.shade50, Colors.yellow.shade100],
    buttonGradient: [Colors.yellow.shade600, Colors.orange.shade500],
    isPopular: false,
    benefits: {
      'viewProfiles': 'Sim',
      'dailyLikes': '50',
      'sendMessages': '20/dia',
      'requestChat': 'Sim',
      'videoChatTime': '30 min/dia',
      'seeWhoLiked': 'Sim',
      'privatePhotos': 'Sim',
      'boosts': '1x/semana',
      'initialCredits': '50',
      'prioritySupport': 'Não',
    },
  ),
  AppPlan(
    id: 'biweekly',
    name: 'Quinzenal',
    price: '85 MT',
    billing: 'a cada 15 dias',
    description: 'Mais tempo para se conectar profundamente.',
    accent: Colors.teal.shade600,
    gradient: [Colors.teal.shade50, Colors.teal.shade100],
    buttonGradient: [Colors.teal.shade500, Colors.green.shade400],
    isPopular: false,
    benefits: {
      'viewProfiles': 'Sim',
      'dailyLikes': '100',
      'sendMessages': '50/dia',
      'requestChat': 'Sim',
      'videoChatTime': '60 min/dia',
      'seeWhoLiked': 'Sim',
      'privatePhotos': 'Sim',
      'boosts': '2x/quinzena',
      'initialCredits': '120',
      'prioritySupport': 'Sim',
    },
  ),
  AppPlan(
    id: 'monthly',
    name: 'Mensal',
    price: '110 MT',
    billing: 'por mês',
    description: 'Experiência completa e ilimitada.',
    accent: Colors.pink.shade600,
    gradient: [Colors.pink.shade50, Colors.pink.shade100],
    buttonGradient: [Colors.pink.shade500, Colors.purple.shade500],
    isPopular: true,
    benefits: {
      'viewProfiles': 'Sim',
      'dailyLikes': 'Ilimitado',
      'sendMessages': 'Ilimitado',
      'requestChat': 'Sim',
      'videoChatTime': '120 min/dia',
      'seeWhoLiked': 'Sim',
      'privatePhotos': 'Sim',
      'boosts': '4x/mês',
      'initialCredits': '250',
      'prioritySupport': 'Sim',
    },
  ),
];

// =====================================================
// ===============   PÁGINA PRINCIPAL   ================
// =====================================================

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  bool _drawerOpen = false;
  int _selectedDrawerIndex = 5;

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    ApiClient.instance.clearToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  void _onBottomNavTap(int index) {
    final isMobile = MediaQuery.of(context).size.width < 1024;
    setState(() => _selectedDrawerIndex = index);

    if (index == 0) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeYouTubeStyleFlutter()),
      );
      return;
    }

    if (index == 1) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      return;
    }

    if (index == 2) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SnapsPage()),
      );
      return;
    }

    if (index == 3) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatPage()),
      );
      return;
    }

    if (index == 4) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      return;
    }

    if (index == 5) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      // Já estamos na página de planos.
      return;
    }

    if (index == 6) {
      if (isMobile && _drawerOpen) Navigator.of(context).pop();
      _logout();
      return;
    }

    if (isMobile && _drawerOpen) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawerScrimColor: Colors.transparent,
      appBar: NomirroAppBar(
        isMobile: isMobile,
        drawerOpen: _drawerOpen,
        showCreateAction: false,
      ),
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobileLayout = constraints.maxWidth < 900;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    child: Column(
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 30),

                        /// Mobile cards
                        if (isMobileLayout)
                          Column(
                            children: plans
                                .map((plan) => Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 25),
                                      child: PlanCard(plan: plan),
                                    ))
                                .toList(),
                          ),

                        /// Desktop table
                        if (!isMobileLayout) _buildDesktopTable(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? Footer(
              currentIndex: 4,
              onTap: _onBottomNavTap,
            )
          : null,
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          "Desbloqueie seu",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.pink, Colors.purple],
          ).createShader(bounds),
          child: const Text(
            "Potencial de Match",
            style: TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Escolha o plano ideal e comece a encontrar conexões significativas.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ],
    );
  }

  // ---------------- DESKTOP TABLE ----------------
  Widget _buildDesktopTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header row
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  "Recurso / Plano",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ...plans.map(
                (p) => Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: p.id == 'free'
                        ? null
                        : () {
                            final raw = p.price.split(' ').first;
                            final value = double.tryParse(raw) ?? 0.0;
                            final initialAmount = value.toStringAsFixed(2);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PaymentScreen(
                                  initialAmount: initialAmount,
                                ),
                              ),
                            );
                          },
                    child: MouseRegion(
                      cursor: p.id == 'free'
                          ? SystemMouseCursors.basic
                          : SystemMouseCursors.click,
                      child: Column(
                        children: [
                          Icon(Icons.diamond, size: 26, color: p.accent),
                          const SizedBox(height: 4),
                          Text(
                            p.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: p.accent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.price,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),

          // Benefit rows
          Column(
            children: benefits.map((benefit) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Icon(benefit.icon, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                benefit.label,
                                style: const TextStyle(fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...plans.map((plan) {
                        return Expanded(
                          flex: 2,
                          child: Center(
                            child:
                                FeatureCell(value: plan.benefits[benefit.key]!),
                          ),
                        );
                      }),
                    ],
                  ),
                  const Divider(),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// ===============     PLAN CARD     ====================
// =====================================================

class PlanCard extends StatelessWidget {
  final AppPlan plan;
  const PlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: plan.gradient),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          width: plan.isPopular ? 4 : 2,
          color: plan.isPopular ? Colors.pink : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: plan.isPopular
                ? Colors.pink.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          if (plan.isPopular)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Mais Popular ✨",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),

          const SizedBox(height: 20),

          Icon(Icons.diamond, size: 36, color: plan.accent),
          const SizedBox(height: 10),

          Text(
            plan.name,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: plan.accent,
            ),
          ),
          Text(plan.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Text(plan.price,
              style:
                  const TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
          Text(plan.billing,
              style: const TextStyle(color: Colors.grey, fontSize: 16)),

          const SizedBox(height: 25),

          // Botão
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: plan.id == 'free'
                ? null
                : () {
                    final raw = plan.price.split(' ').first;
                    final value = double.tryParse(raw) ?? 0.0;
                    final initialAmount = value.toStringAsFixed(2);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PaymentScreen(
                          initialAmount: initialAmount,
                        ),
                      ),
                    );
                  },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: plan.buttonGradient),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  plan.id == 'free'
                      ? "Começar Grátis"
                      : "Assinar por ${plan.price}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Benefícios
          Column(
            children: benefits.map((b) {
              final val = plan.benefits[b.key]!;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(b.icon, size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text(b.label)),
                    FeatureCell(value: val),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// ============   CELULA DE BENEFÍCIO   ================
// =====================================================

class FeatureCell extends StatelessWidget {
  final String value;
  const FeatureCell({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value == "Sim") {
      return const Icon(Icons.check_circle, size: 22, color: Colors.green);
    }
    if (value == "Não") {
      return Icon(
        Icons.cancel,
        size: 22,
        color: Colors.red.withValues(alpha: 0.6),
      );
    }
    return Text(
      value,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
