import 'package:flutter/material.dart';
import 'package:twynk_frontend/themes/app_theme.dart';
import 'welcome.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../services/auth_service.dart';

// --- DADOS E CONSTANTES ---

const List<String> kGenderOptions = ['Homem', 'Mulher', 'Outro'];
const List<String> kLookingForOptions = [
  'Homem',
  'Mulher',
  'Homem ou Mulher',
  'Mulher ou Homem'
];
const List<String> kAppearanceOptions = [
  'Negro',
  'Mestiço',
  'Branco',
  'Moreno',
  'Oriental',
  'Outros'
];
const List<String> kEducationOptions = [
  '1º grau completo',
  '1º grau incompleto',
  'Superior completo',
  'Superior incompleto',
  'Pós-graduado',
  'Mestrado',
  'Doutorado'
];
const List<String> kCountryOptions = [
  'Angola',
  'Brasil',
  'Cabo Verde',
  'Guiné-Bissau',
  'Moçambique',
  'Portugal',
  'São Tomé e Príncipe',
  'Timor-Leste',
  'Guiné Equatorial'
];

final Map<String, Map<String, List<String>>> kLocations = {
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

// Gerador de Idades (18 a 60+)
final List<String> kAgeOptions = List.generate(43, (i) => (18 + i).toString())
  ..add('60+');

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers para campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  // State para Selects
  String? _gender;
  String? _lookingFor;
  DateTime? _birthDate;
  String? _appearance;
  String? _education;
  String? _country;
  String? _province;
  String? _city;

  // UI State
  final bool _obscurePassword = true;
  Map<String, String?> _errors = {};

  // Computed Properties (Getters)
  List<String> get _provinces {
    // Mantido apenas por compatibilidade; dropdowns agora usam LocationProvider.
    if (_country == null || !kLocations.containsKey(_country)) return [];
    return kLocations[_country]!.keys.toList();
  }

  List<String> get _cities {
    // Mantido apenas por compatibilidade; dropdowns agora usam LocationProvider.
    if (_country == null || _province == null) return [];
    return kLocations[_country]?[_province] ?? [];
  }

  // Handlers
  void _handleChangeCountry(String? value) {
    setState(() {
      _country = value;
      _province = null;
      _city = null;
      _errors.remove('country');
    });
    final location = Provider.of<LocationProvider>(context, listen: false);
    final selected = location.paises.where((p) => p.nome == value).toList();
    final String? paisId = selected.isNotEmpty ? selected.first.id : null;
    location.fetchProvincias(paisId: paisId);
  }

  void _handleChangeProvince(String? value) {
    setState(() {
      _province = value;
      _city = null;
      _errors.remove('province');
    });
    final location = Provider.of<LocationProvider>(context, listen: false);
    final selected = location.provincias.where((p) => p.nome == value).toList();
    final String? provinciaId = selected.isNotEmpty ? selected.first.id : null;
    location.fetchCidades(provinciaId: provinciaId);
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final DateTime lastDate = DateTime(now.year - 18, now.month, now.day);
    final DateTime firstDate = DateTime(now.year - 100, now.month, now.day);

    DateTime initialDate = _birthDate ?? DateTime(now.year - 25, now.month, now.day);
    if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    } else if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Selecione sua data de nascimento',
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthDateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
        _errors.remove('age');
      });
    }
  }

  bool _validate() {
    final Map<String, String?> newErrors = {};
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (_gender == null) newErrors['gender'] = 'Selecione uma opção';
    if (_lookingFor == null) newErrors['lookingFor'] = 'Selecione uma opção';
    if (_nameController.text.trim().isEmpty) newErrors['name'] = 'Nome é obrigatório';
    if (_birthDate == null) newErrors['age'] = 'Selecione a data de nascimento';
    if (_country == null) newErrors['country'] = 'Selecione o país';
    if (_province == null) newErrors['province'] = 'Selecione a província';
    if (_city == null) newErrors['city'] = 'Selecione a cidade';
    if (_appearance == null) newErrors['appearance'] = 'Selecione a aparência'; // Adicionado validação visual
    if (_education == null) newErrors['education'] = 'Selecione a escolaridade';

    if (_emailController.text.trim().isEmpty) {
      newErrors['email'] = 'E-mail é obrigatório';
    } else if (!emailRegex.hasMatch(_emailController.text)) {
      newErrors['email'] = 'E-mail inválido';
    }

    if (_passwordController.text.isEmpty) {
      newErrors['password'] = 'Senha é obrigatória';
    } else if (_passwordController.text.length < 6) {
      newErrors['password'] = 'Mínimo de 6 caracteres';
    }

    if (_otpController.text.isEmpty) {
      newErrors['otp'] = 'Código OTP necessário';
    } else if (_otpController.text.length < 4) {
      newErrors['otp'] = 'Código inválido';
    }

    setState(() {
      _errors = newErrors;
    });

    return newErrors.isEmpty;
  }

  void _showSnackBar(String message, {bool isError = false, bool isInfo = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color bgColor = colorScheme.primary;
    IconData icon = Icons.check_circle;

    if (isError) {
      bgColor = Colors.red.shade700;
      icon = Icons.error_outline;
    } else if (isInfo) {
      bgColor = colorScheme.secondary;
      icon = Icons.info_outline;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleVerifyOTP() async {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (_emailController.text.isEmpty || !emailRegex.hasMatch(_emailController.text)) {
      _showSnackBar('Informe um e-mail válido primeiro.', isError: true);
      setState(() {
        _errors['email'] = 'E-mail necessário para OTP';
      });
      return;
    }
    final email = _emailController.text.trim();

    final result = await AuthService.instance.sendOtp(email: email);
    if (result['success'] == true) {
      final msg = (result['message'] as String?) ?? 'Código OTP enviado para $email';
      _showSnackBar(msg, isInfo: true);
    } else {
      final msg = (result['error'] as String?) ?? 'Erro ao enviar código OTP.';
      _showSnackBar(msg, isError: true);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_validate()) {
      _showSnackBar('Verifique os campos obrigatórios.', isError: true);
      return;
    }

    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();

    final otpResult = await AuthService.instance.verifyOtp(
      email: email,
      otp: otp,
    );

    if (otpResult['success'] != true) {
      final msg = (otpResult['error'] as String?) ?? 'Código OTP inválido ou expirado.';
      _showSnackBar(msg, isError: true);
      setState(() {
        _errors['otp'] = 'Código OTP inválido ou expirado.';
      });
      return;
    }

    final location = Provider.of<LocationProvider>(context, listen: false);

    final paisList =
        location.paises.where((p) => p.nome == _country).toList(growable: false);
    final provinciaList = location.provincias
        .where((p) => p.nome == _province)
        .toList(growable: false);
    final cidadeList =
        location.cidades.where((c) => c.nome == _city).toList(growable: false);

    final String? paisId = paisList.isNotEmpty ? paisList.first.id : null;
    final String? provinciaId =
        provinciaList.isNotEmpty ? provinciaList.first.id : null;
    final String? cidadeId = cidadeList.isNotEmpty ? cidadeList.first.id : null;

    String? mapGenero(String? value) {
      switch (value) {
        case 'Homem':
          return 'masculino';
        case 'Mulher':
          return 'feminino';
        case 'Outro':
          return 'outro';
        default:
          return null;
      }
    }

    String? mapInteresse(String? value) {
      switch (value) {
        case 'Homem':
          return 'masculino';
        case 'Mulher':
          return 'feminino';
        case 'Homem ou Mulher':
        case 'Mulher ou Homem':
          return 'ambos';
        default:
          return null;
      }
    }

    String? formatDate(DateTime? date) {
      if (date == null) return null;
      final year = date.year.toString().padLeft(4, '0');
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '$year-$month-$day';
    }

    String? buildLocalizacao() {
      final parts = <String>[];
      if (_city != null && _city!.isNotEmpty) parts.add(_city!);
      if (_province != null && _province!.isNotEmpty) parts.add(_province!);
      if (_country != null && _country!.isNotEmpty) parts.add(_country!);
      if (parts.isEmpty) return null;
      return parts.join(', ');
    }

    final Map<String, dynamic> data = {
      'nome': _nameController.text.trim(),
      'apelido': _lastNameController.text.trim().isEmpty
          ? null
          : _lastNameController.text.trim(),
      'genero': mapGenero(_gender),
      'interesse': mapInteresse(_lookingFor),
      'data_nascimento': formatDate(_birthDate),
      'email': email,
      'password': _passwordController.text,
      // Campos adicionais compatíveis com o backend
      'cor_pele': _appearance,
      'escolaridade': _education,
      'otp': otp,
      'pais_id': paisId,
      'provincia_id': provinciaId,
      'cidade_id': cidadeId,
    };

    _showSnackBar('Enviando cadastro...', isInfo: true);

    final result = await AuthService.instance.register(data: data);
    if (result['success'] == true) {
      _showSnackBar('Cadastro realizado com sucesso! Faça login.', isInfo: true);
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      final msg = (result['error'] as String?) ?? 'Erro ao registar';
      _showSnackBar(msg, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final double cardMaxWidth = screenWidth < 600
        ? screenWidth * 0.98
        : (screenWidth < 1024
            ? 720.0
            : (screenWidth < 1440
                ? 960.0
                : 1100.0));
    const double mobileBreakpoint = 600.0;
    final bool isMobile = screenWidth < mobileBreakpoint;

    final List<BoxShadow> boxShadows = [];

    final Color scaffoldBackground = theme.scaffoldBackgroundColor;
    final Color primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: AppBar(
        backgroundColor: scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const WelcomePage(),
              ),
            );
          },
        ),
        title: Text(
          'Criar conta',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12.0 : 24.0,
            vertical: isMobile ? 12.0 : 24.0,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: cardMaxWidth),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 32.0,
                vertical: isMobile ? 20.0 : 28.0,
              ),
              decoration: BoxDecoration(
                color: isMobile ? scaffoldBackground : theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: boxShadows,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 1;
                      if (constraints.maxWidth > 600) crossAxisCount = 2;
                      if (constraints.maxWidth > 1000) crossAxisCount = 3;

                      if (crossAxisCount == 1) {
                        return Column(
                          children: _buildFormChildren(),
                        );
                      }

                      const double spacing = 24;
                      final double itemWidth =
                          (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                              crossAxisCount;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: _buildFormChildren()
                            .map((widget) => SizedBox(width: itemWidth, child: widget))
                            .toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: _buildTextField(
                      controller: _otpController,
                      label: 'Código OTP',
                      icon: Icons.verified_user_outlined,
                      hint: 'Insira o código recebido no e-mail',
                      errorText: _errors['otp'],
                      maxLength: 6,
                      onChanged: (_) => setState(() => _errors.remove('otp')),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (isMobile)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async { await _handleSubmit(); },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: primaryColor,
                          side: BorderSide.none,
                        ),
                        child: const Text(
                          'Finalizar cadastro',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () async { await _handleSubmit(); },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: primaryColor,
                            side: BorderSide.none,
                          ),
                          child: const Text(
                            'Finalizar cadastro',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Já tem uma conta? ',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Fazer login',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

  // Retorna a lista de inputs para ser usada no Column ou Wrap
  List<Widget> _buildFormChildren() {
    final location = Provider.of<LocationProvider>(context);
    final paises = location.paises;
    final provincias = location.provincias;
    final cidades = location.cidades;
    return [
      _buildDropdown(
        label: "Eu sou",
        icon: Icons.person_outline,
        value: _gender,
        items: kGenderOptions,
        onChanged: (v) => setState(() { _gender = v; _errors.remove('gender'); }),
        errorText: _errors['gender'],
      ),
      _buildDropdown(
        label: "Procuro por",
        icon: Icons.favorite_border,
        value: _lookingFor,
        items: kLookingForOptions,
        onChanged: (v) => setState(() { _lookingFor = v; _errors.remove('lookingFor'); }),
        errorText: _errors['lookingFor'],
      ),
      _buildTextField(
        controller: _nameController,
        label: "Nome próprio",
        icon: Icons.badge_outlined,
        hint: "Seu primeiro nome",
        errorText: _errors['name'],
        onChanged: (_) => setState(() => _errors.remove('name')),
      ),
      _buildTextField(
        controller: _lastNameController,
        label: "Apelido",
        icon: Icons.sentiment_satisfied_alt,
        hint: "Como deseja ser chamado(a)",
        errorText: _errors['apelido'],
        onChanged: (_) => setState(() => _errors.remove('apelido')),
      ),
      _buildTextField(
        controller: _birthDateController,
        label: "Data de nascimento",
        icon: Icons.calendar_today,
        hint: "Selecione sua data de nascimento",
        errorText: _errors['age'],
        readOnly: true,
        onTap: () => _pickBirthDate(),
      ),
      _buildDropdown(
        label: "Aparência",
        icon: Icons.visibility_outlined,
        value: _appearance,
        items: kAppearanceOptions,
        onChanged: (v) => setState(() { _appearance = v; _errors.remove('appearance'); }),
        errorText: _errors['appearance'],
      ),
      _buildDropdown(
        label: "Escolaridade",
        icon: Icons.school_outlined,
        value: _education,
        items: kEducationOptions,
        onChanged: (v) => setState(() { _education = v; _errors.remove('education'); }),
        errorText: _errors['education'],
      ),
      _buildDropdown(
        label: "País",
        icon: Icons.public,
        value: _country,
        items: paises.map((p) => p.nome).toList(),
        onChanged: _handleChangeCountry,
        errorText: _errors['country'],
      ),
      _buildDropdown(
        label: "Província",
        icon: Icons.map_outlined,
        value: _province,
        items: provincias.map((p) => p.nome).toList(),
        onChanged: _handleChangeProvince,
        disabled: _country == null || provincias.isEmpty,
        hintText: _country == null ? "Selecione o país primeiro" : "Selecione",
        errorText: _errors['province'],
      ),
      _buildDropdown(
        label: "Cidade",
        icon: Icons.location_city,
        value: _city,
        items: cidades.map((c) => c.nome).toList(),
        onChanged: (v) => setState(() { _city = v; _errors.remove('city'); }),
        disabled: _province == null || cidades.isEmpty,
        hintText: _province == null ? "Selecione a província primeiro" : "Selecione",
        errorText: _errors['city'],
      ),
      _buildTextField(
        controller: _emailController,
        label: "E-mail",
        icon: Icons.mail_outline,
        hint: "seu@email.com",
        inputType: TextInputType.emailAddress,
        errorText: _errors['email'],
        onChanged: (_) => setState(() => _errors.remove('email')),
      ),
      _buildTextField(
        controller: _passwordController,
        label: "Senha",
        icon: Icons.lock_outline,
        hint: "******",
        isPassword: true,
        errorText: _errors['password'],
        onChanged: (_) => setState(() => _errors.remove('password')),
      ),
      // Botão Enviar OTP
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Espaçador visual para alinhar com os inputs
          const SizedBox(height: 25), 
          SizedBox(
            height: 52,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _handleVerifyOTP,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.indigo, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.white,
                foregroundColor: Colors.indigo,
              ),
              child: const Text("Enviar Código OTP", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    ];
  }

  // --- Widgets Reutilizáveis ---

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool isPassword = false,
    String? errorText,
    TextInputType inputType = TextInputType.text,
    int? maxLength,
    void Function(String)? onChanged,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword && _obscurePassword,
          keyboardType: inputType,
          onChanged: onChanged,
          maxLength: maxLength,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            counterText: "", // esconde o contador quando maxLength é usado
            prefixIcon: Icon(icon, color: cs.primary),
            filled: true,
            fillColor: cs.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: cs.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            errorText: errorText,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    bool disabled = false,
    String hintText = "Selecione",
    String? errorText,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: value,
          items: items.map((String val) {
            return DropdownMenuItem(value: val, child: Text(val));
          }).toList(),
          onChanged: disabled ? null : onChanged,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            prefixIcon: Icon(
              icon,
              color: disabled ? theme.disabledColor : cs.primary,
            ),
            filled: true,
            fillColor: cs.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: cs.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            errorText: errorText,
          ),
          icon: Icon(
            Icons.arrow_drop_down_outlined,
            color: cs.onSurface.withValues(alpha: 0.7),
          ),
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 16,
          ),
          isExpanded: true,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}