import 'package:flutter/material.dart';
import '../themes/nomirro_colors.dart';
import 'package:flutter/gestures.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  // Selections
  String? _gender; // Eu sou
  String? _lookingFor; // Procuro por
  String? _age; // Idade
  String? _appearance; // Aparência
  String? _education; // Escolaridade
  String? _country; // País
  String? _province; // Província
  String? _city; // Cidade

  // Data
  final List<String> _genderOptions = const [
    'Homem',
    'Mulher',
    'Outro',
  ];

  final List<String> _lookingForOptions = const [
    'Homem',
    'Mulher',
    'Homem ou Mulher',
    'Mulher ou Homem',
  ];

  late final List<String> _ageOptions = [
    ...List.generate(43, (i) => (18 + i).toString()), // 18..60
    '60+',
  ];

  final List<String> _appearanceOptions = const [
    'Negro',
    'Mestiço',
    'Branco',
    'Moreno',
    'Oriental',
    'Outros',
  ];

  final List<String> _educationOptions = const [
    '1º grau completo',
    '1º grau incompleto',
    'Superior completo',
    'Superior incompleto',
    'Pós-graduado',
    'Mestrado',
    'Doutorado',
  ];

  final List<String> _countryOptions = const [
    'Angola',
    'Brasil',
    'Cabo Verde',
    'Guiné-Bissau',
    'Moçambique',
    'Portugal',
    'São Tomé e Príncipe',
    'Timor-Leste',
    'Guiné Equatorial',
  ];

  // País -> Províncias -> Cidades (exemplos mínimos para demonstrar a dinâmica)
  final Map<String, Map<String, List<String>>> _locations = {
    'Angola': {
      'Luanda': ['Kilamba', 'Talatona', 'Cazenga'],
      'Benguela': ['Benguela', 'Lobito', 'Catumbela'],
      'Huíla': ['Lubango', 'Matala', 'Quipungo'],
    },
    'Brasil': {
      'São Paulo': ['São Paulo', 'Campinas', 'Santos'],
      'Rio de Janeiro': ['Rio de Janeiro', 'Niterói', 'Petrópolis'],
      'Minas Gerais': ['Belo Horizonte', 'Uberlândia', 'Juiz de Fora'],
    },
    'Cabo Verde': {
      'Santiago': ['Praia', 'Assomada'],
      'São Vicente': ['Mindelo'],
    },
    'Guiné-Bissau': {
      'Bissau': ['Bissau'],
      'Biombo': ['Quinhámel'],
    },
    'Moçambique': {
      'Maputo': ['Maputo', 'Matola'],
      'Sofala': ['Beira', 'Dondo'],
    },
    'Portugal': {
      'Lisboa': ['Lisboa', 'Oeiras', 'Amadora'],
      'Porto': ['Porto', 'Vila Nova de Gaia', 'Matosinhos'],
      'Braga': ['Braga', 'Guimarães'],
    },
    'São Tomé e Príncipe': {
      'Água Grande': ['São Tomé'],
      'Mé-Zóchi': ['Trindade'],
    },
    'Timor-Leste': {
      'Díli': ['Díli'],
      'Baucau': ['Baucau'],
    },
    'Guiné Equatorial': {
      'Bioko Norte': ['Malabo'],
      'Litoral': ['Bata'],
    },
  };

  void _onCountryChanged(String? value) {
    setState(() {
      _country = value;
      _province = null;
      _city = null;
    });
  }

  void _onProvinceChanged(String? value) {
    setState(() {
      _province = value;
      _city = null;
    });
  }

  void _showMessage(String message, String type) {
    final theme = Theme.of(context);
    Color backgroundColor = theme.colorScheme.primary;
    if (type == 'error') {
      backgroundColor = Colors.red.shade700;
    } else if (type == 'success') {
      backgroundColor = Colors.green.shade700;
    } else if (type == 'info') {
      backgroundColor = NomirroColors.primary;
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: options
          .map((e) => DropdownMenuItem<String>(
                value: e,
                child: SizedBox(
                  height: 48,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      e,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
      onChanged: onChanged,
      isExpanded: true,
      itemHeight: 48,
      menuMaxHeight: 320,
      icon: Icon(
        Icons.arrow_drop_down_outlined,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      // Estilo do texto selecionado (sem negrito)
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: theme.colorScheme.onSurface,
      ),
      dropdownColor: theme.colorScheme.surface,
      validator: (v) => v == null || v.isEmpty ? 'Selecione $label' : null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelText: label,
        // Removido prefixIcon para não sobrepor o texto selecionado
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
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    bool obscure = false,
    String? Function(String?)? validator,
    String? hint,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        prefixIcon: icon != null ? Icon(icon, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
      ),
      validator: validator ?? (v) => (v == null || v.isEmpty) ? 'Preencha $label' : null,
    );
  }

  Widget _gradientButton({required Widget child, required VoidCallback onPressed}) {
    final primary = NomirroColors.primary;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [NomirroColors.accentGreen, primary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: child,
      ),
    );
  }

  Widget _solidBlueButton({required String text, required VoidCallback onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: NomirroColors.primary,
        side: const BorderSide(color: NomirroColors.accentLight),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Grid responsivo: 1 coluna no mobile, 2 colunas em tablets, até 3 no desktop
  Widget _responsiveFormGrid({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wide = constraints.maxWidth >= 1024;
        final double spacing = wide ? 16 : 12;
        const double minItemWidth = 280; // garante inputs confortáveis
        // Define número de colunas baseado na largura disponível
        int columns = (constraints.maxWidth + spacing) ~/ (minItemWidth + spacing);
        if (columns < 1) columns = 1;
        // Limita a até 3 colunas em desktops largos
        if (columns > 3) columns = 3;
        final double itemWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((w) => SizedBox(width: itemWidth, child: w))
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final double cardMaxWidth = screenWidth < 600
        ? screenWidth * 0.98
        : (screenWidth < 1024
            ? 720.0 // tablets
            : (screenWidth < 1440
                ? 960.0 // desktop médio
                : 1100.0)); // desktop largo
    const double mobileBreakpoint = 600.0;
    final bool isMobile = screenWidth < mobileBreakpoint;

    final List<BoxShadow> boxShadows = const [];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12.0 : 24.0,
            vertical: isMobile ? 12.0 : 24.0,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: cardMaxWidth,
            ),
            child: Container(
              padding: EdgeInsets.only(
                left: isMobile ? 16.0 : 32.0,
                right: isMobile ? 16.0 : 32.0,
                top: isMobile ? 16.0 : 28.0,
                bottom: isMobile ? 8.0 : 12.0,
              ),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: boxShadows,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/logo_02.png',
                          height: 42,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 28),
                  // Conteúdo rolável: formulário (não força expansão quando curto)
                  Flexible(
                    fit: FlexFit.loose,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Crie a sua conta',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _responsiveFormGrid(children: [
                      // Eu sou
                      _buildDropdown(
                        label: 'Eu sou',
                        value: _gender,
                        options: _genderOptions,
                        onChanged: (v) => setState(() => _gender = v),
                      ),

                      // Procuro por
                      _buildDropdown(
                        label: 'Procuro por',
                        value: _lookingFor,
                        options: _lookingForOptions,
                        onChanged: (v) => setState(() => _lookingFor = v),
                      ),

                      // Nome ou apelido
                      _buildTextField(
                        label: 'Nome ou apelido',
                        controller: _nameController,
                        icon: Icons.person_outline,
                        hint: 'Como deseja ser chamado',
                      ),

                      // Idade
                      _buildDropdown(
                        label: 'Idade',
                        value: _age,
                        options: _ageOptions,
                        onChanged: (v) => setState(() => _age = v),
                      ),

                      // Aparência
                      _buildDropdown(
                        label: 'Aparência',
                        value: _appearance,
                        options: _appearanceOptions,
                        onChanged: (v) => setState(() => _appearance = v),
                      ),

                      // Escolaridade
                      _buildDropdown(
                        label: 'Escolaridade',
                        value: _education,
                        options: _educationOptions,
                        onChanged: (v) => setState(() => _education = v),
                      ),

                      // País
                      _buildDropdown(
                        label: 'País',
                        value: _country,
                        options: _countryOptions,
                        onChanged: _onCountryChanged,
                      ),

                      // Província (depende do País)
                      _buildDropdown(
                        label: 'Província',
                        value: _province,
                        options: _country == null
                            ? []
                            : _locations[_country!]!.keys.toList(),
                        onChanged: _onProvinceChanged,
                      ),

                      // Cidade (depende da Província)
                      _buildDropdown(
                        label: 'Cidade',
                        value: _city,
                        options: (_country != null && _province != null)
                            ? _locations[_country!]![_province!] ?? []
                            : [],
                        onChanged: (v) => setState(() => _city = v),
                      ),

                      // Email
                      _buildTextField(
                        label: 'E-mail',
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        hint: 'seu@email.com',
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Digite seu e-mail';
                          final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                          if (!emailRegex.hasMatch(v)) return 'Digite um e-mail válido';
                          return null;
                        },
                      ),

                      // Senha
                      _buildTextField(
                        label: 'Senha',
                        controller: _passwordController,
                        icon: Icons.lock_outline,
                        obscure: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Digite sua senha';
                          if (v.length < 6) return 'Mínimo de 6 caracteres';
                          return null;
                        },
                      ),
                            ]),
                            const SizedBox(height: 12),

                            // Verificar OTP
                            _solidBlueButton(
                              text: 'Verificar OTP',
                              onPressed: () {
                                final email = _emailController.text.trim();
                                final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                                if (email.isEmpty || !emailRegex.hasMatch(email)) {
                                  _showMessage('Informe um e-mail válido antes de verificar o OTP.', 'error');
                                  return;
                                }
                                _showMessage('OTP enviado para $email (demo).', 'success');
                              },
                            ),
                            const SizedBox(height: 12),

                            // OTP
                            _buildTextField(
                              label: 'Código OTP',
                              controller: _otpController,
                              icon: Icons.verified_outlined,
                              hint: 'Digite o código recebido',
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Digite o código OTP';
                                if (v.length < 4) return 'Código inválido';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Cadastrar (gradiente)
                            _gradientButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() != true) {
                                  _showMessage('Corrija os campos obrigatórios.', 'error');
                                  return;
                                }
                                if (_country == null || _province == null || _city == null) {
                                  _showMessage('Selecione País, Província e Cidade.', 'error');
                                  return;
                                }
                                _showMessage('Cadastro realizado com sucesso! (demo)', 'success');
                              },
                              child: const Text(
                                'Cadastrar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Já é cadastrado? ',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Login!',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: NomirroColors.primary,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).pop();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}