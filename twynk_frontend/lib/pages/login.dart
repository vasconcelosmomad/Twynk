import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'register.dart';
import 'home.dart';
import '../services/auth_service.dart';
// Cores do gradiente principal usadas em botões
const Color _primaryCyan = Color(0xFF50C0C8); // #50c0c8
const Color _secondaryBlue = Color(0xFF6BC9FF); // #6bc9ff

// ----------------------------------------------------
// 2. Componente de Página de Login (Theme-Aware e Responsivo)
// ----------------------------------------------------

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _showMessage(String message, String type) {
    final theme = Theme.of(context);
    Color backgroundColor = theme.colorScheme.primary;
    if (type == 'error') {
      backgroundColor = Colors.red.shade700;
    } else if (type == 'success') {
      backgroundColor = Colors.green.shade700;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
        duration: const Duration(milliseconds: 3000),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Por favor, preencha o e-mail e a palavra-passe.', 'error');
      return;
    }
    if (password.length < 6) {
      _showMessage('Palavra-passe muito curta. Tente novamente.', 'error');
      return;
    }

    final result = await AuthService.instance.login(email: email, password: password);
    if (result['success'] == true) {
      _showMessage('Login efetuado com sucesso!', 'success');
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeYouTubeStyleFlutter()),
      );
    } else {
      final msg = (result['error'] as String?) ?? 'Erro ao autenticar';
      _showMessage(msg, 'error');
    }
  }

  void _handleSocialLogin(String provider) {
    _showMessage('A tentar iniciar sessão com $provider. Funcionalidade em desenvolvimento...', 'info');
  }

  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // ----------------------------------------------------
    // Lógica de Responsividade: Define a largura máxima do Card
    // ----------------------------------------------------
    // Para telas menores (Mobile/Tablet), usa 85% da largura.
    // Para telas maiores (Web/Desktop), limita a um máximo de 400px.
    final double cardMaxWidth = screenWidth < 600 ? screenWidth * 0.96 : 420.0;
    
    // Define o breakpoint para mobile (geralmente < 600)
    const double mobileBreakpoint = 600.0;
    final bool isMobile = screenWidth < mobileBreakpoint;
    
    // Lista de sombras que será aplicada. Vazia em dispositivos móveis.
    final List<BoxShadow> boxShadows = screenWidth < mobileBreakpoint
        ? [] // Sem sombra para mobile
        : [
            // Sombras existentes para Tablet/Web/Desktop
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
              blurRadius: 25,
              offset: const Offset(0, 20),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 8),
            ),
          ];

    // Cor de fundo para o Scaffold
    final Color scaffoldBackground = isDark 
        ? theme.scaffoldBackgroundColor
        : theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12.0 : 24.0,
            vertical: isMobile ? 12.0 : 24.0,
          ),
          // Aplica a limitação de largura
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: cardMaxWidth),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 32.0,
                vertical: isMobile ? 20.0 : 32.0,
              ),
              // Cor de fundo do Card (adapta-se ao tema)
              decoration: BoxDecoration(
                color: isMobile ? scaffoldBackground : Theme.of(context).cardColor, 
                borderRadius: BorderRadius.circular(16),
                boxShadow: boxShadows, // Aplica a lista dinâmica de sombras
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logotipo e Título com Gradiente
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/logo_02.png',
                          height: 46,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Encontre o seu par perfeito.',
                          style: TextStyle(
                            // Usa onSurface.withOpacity para se adaptar ao tema
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Campos de Formulário
                  // EMAIL
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      labelText: 'E-mail',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Digite seu e-mail';
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) return 'Digite um e-mail válido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // SENHA
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Digite sua senha';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Link "Esqueceu a Palavra-passe" (alinhado à direita)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _showMessage('A página de recuperação de palavra-passe ainda não está ligada.', 'info');
                        },
                        child: Text(
                          'Esqueceu a palavra-passe?',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Botão Principal de Login (estilo azul claro do Google)
                  OutlinedButton(
                    onPressed: () async { await _handleLogin(); },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.lightBlue,
                      side: const BorderSide(color: Colors.lightBlueAccent),
                    ),
                    child: const Text(
                      'Entrar no Twynk',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // O separador "OU" foi removido. Aumentamos o espaçamento para manter a separação visual.
                  const SizedBox(height: 40), 

                  // Opção de Login Social (Google) com fundo gradiente
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [_primaryCyan, _secondaryBlue],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryCyan.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _handleSocialLogin('Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      icon: Image.asset(
                        'assets/icons/google_32.png',
                        fit: BoxFit.contain,
                      ),
                      label: const Text(
                        'Continuar com Google',
                        style: TextStyle(
                          color: Colors.white, // Texto branco
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Link "Criar Conta"
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Novo no Twynk? ',
                        style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Crie uma conta',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.lightBlue, // Usa a cor primária do tema
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
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
}