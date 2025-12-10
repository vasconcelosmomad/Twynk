import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/user.dart';
import 'package:twynk_frontend/services/upload_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final UploadService _uploadService = UploadService();
  final ImagePicker _imagePicker = ImagePicker();
  File? _localProfileImage;
  bool _uploadingProfile = false;
  Uint8List? _webProfileBytes;

  // Dados Pessoais
  late String _apelido;
  late String _signo;
  late String _dataNascimento;
  late String _euSou;
  late String _sexualidade;
  late String _estadoCivil;
  late String _filhos;
  late String _escolaridade;
  late String _profissao;
  late String _humor;

  // Localização
  late String _pais;
  late String _provincia;
  late String _cidade;
  late String _moraCom;

  // Aparência
  late String _corPele;
  late String _corOlhos;
  late String _corCabelos;
  late String _peso;
  late String _altura;

  // Hábitos
  late String _praticaEsporte;
  late String _fuma;
  late String _bebe;

  // Descrição física
  late String _comoMeConsideroFisicamente;

  // Listas de opções para selects
  static const List<String> signos = [
    'Áries', 'Touro', 'Gêmeos', 'Câncer', 'Leão', 'Virgem',
    'Libra', 'Escorpião', 'Sagitário', 'Capricórnio', 'Aquário', 'Peixes'
  ];

  static const List<String> sexualidades = [
    'Heterossexual', 'Homossexual', 'Bissexual', 'Pansexual', 'Assexual', 'Não responder'
  ];

  static const List<String> estadosCivis = [
    'Solteiro', 'Casado', 'Divorciado', 'Separado', 'Viúvo', 'União estável', 'Não responder'
  ];

  static const List<String> escolaridades = [
    'Ensino fundamental incompleto', 'Ensino fundamental completo',
    'Ensino médio incompleto', 'Ensino médio completo',
    'Superior incompleto', 'Superior completo', 'Pós-graduação', 'Não responder'
  ];

  static const List<String> humores = [
    'Amigável', 'Sério', 'Extrovertido', 'Introvertido', 'Romântico', 'Aventureiro',
    'Calmo', 'Animado', 'Tímido', 'Confiante', 'Não responder'
  ];

  static const List<String> paises = [
    'Moçambique', 'Brasil', 'Portugal', 'Angola', 'África do Sul', 'Outro'
  ];

  static const List<String> provinciasMocambique = [
    'Maputo Cidade', 'Maputo Província', 'Gaza', 'Inhambane', 'Manica',
    'Sofala', 'Tete', 'Zambézia', 'Nampula', 'Niassa', 'Cabo Delgado'
  ];

  static const List<String> coresOlhos = [
    'Castanhos', 'Azuis', 'Verdes', 'Pretos', 'Cinza', 'Não responder'
  ];

  static const List<String> coresCabelos = [
    'Preto', 'Castanho', 'Loiro', 'Ruivo', 'Grisalho', 'Careca', 'Não responder'
  ];

  static const List<String> pesos = [
    'Abaixo do peso', 'Peso normal', 'Acima do peso', 'Não responder'
  ];

  static const List<String> alturas = [
    'Baixo', 'Médio', 'Alto', 'Não responder'
  ];

  static const List<String> praticaEsporte = [
    'Sim, regularmente', 'Sim, ocasionalmente', 'Não pratico', 'Não responder'
  ];

  static const List<String> fuma = [
    'Sim', 'Não', 'Ocasionalmente', 'Não responder'
  ];

  static const List<String> bebe = [
    'Sim, regularmente', 'Ocasionalmente', 'Não bebo', 'Não responder'
  ];

  @override
  void initState() {
    super.initState();
    // Obter usuário logado do AppProvider para preencher com dados reais
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final User? user = appProvider.currentUser;

    // Helpers locais para manter valores válidos nas listas de opções
    String ensureInOptions(String? value, List<String> options, String fallback) {
      if (value != null && options.contains(value)) {
        return value;
      }
      return fallback;
    }

    String mapGeneroToDescricao(String? genero) {
      switch (genero) {
        case 'masculino':
          return 'Homem';
        case 'feminino':
          return 'Mulher';
        default:
          return 'Outro';
      }
    }

    String formatDate(DateTime? date) {
      if (date == null) return '';
      final d = date.day.toString().padLeft(2, '0');
      final m = date.month.toString().padLeft(2, '0');
      final y = date.year.toString();
      return '$d/$m/$y';
    }

    String mapBoolToSimNao(bool? value) {
      if (value == true) return 'Sim';
      if (value == false) return 'Não';
      return 'Não responder';
    }

    String mapBoolToPraticaEsporte(bool? value) {
      if (value == true) return 'Sim, regularmente';
      if (value == false) return 'Não pratico';
      return 'Não responder';
    }

    String mapBoolToBebe(bool? value) {
      if (value == true) return 'Sim, regularmente';
      if (value == false) return 'Não bebo';
      return 'Não responder';
    }

    if (user != null) {
      // Dados vindo do backend (User.php)
      _apelido = user.apelido ?? '';
      _signo = ensureInOptions(user.signo, signos, signos.first);
      _dataNascimento = formatDate(user.dataNascimento);
      _euSou = mapGeneroToDescricao(user.genero);
      _sexualidade = ensureInOptions(user.sexualidade, sexualidades, sexualidades.last);
      _estadoCivil = ensureInOptions(user.estadoCivil, estadosCivis, estadosCivis.last);
      _filhos = user.filhos?.toString() ?? '';
      _escolaridade = ensureInOptions(user.escolaridade, escolaridades, escolaridades.last);
      _profissao = user.profissao ?? '';
      _humor = ensureInOptions(user.humor, humores, humores.last);

      // Localização: por enquanto usamos valores padrão, pois o backend expõe apenas IDs
      _pais = paises.first;
      _provincia = provinciasMocambique.first;
      _cidade = '';
      _moraCom = user.moraCom ?? '';

      // Aparência
      _corPele = user.corPele ?? '';
      _corOlhos = ensureInOptions(user.corOlhos, coresOlhos, coresOlhos.last);
      _corCabelos = ensureInOptions(user.corCabelos, coresCabelos, coresCabelos.last);
      _peso = pesos.last;
      _altura = alturas.last;

      // Hábitos
      _praticaEsporte = ensureInOptions(
        mapBoolToPraticaEsporte(user.praticaEsporte),
        praticaEsporte,
        praticaEsporte.last,
      );
      _fuma = ensureInOptions(
        mapBoolToSimNao(user.fuma),
        fuma,
        fuma.last,
      );
      _bebe = ensureInOptions(
        mapBoolToBebe(user.bebe),
        bebe,
        bebe.last,
      );

      _comoMeConsideroFisicamente = user.comoMeConsideroFisicamente ?? '';
    } else {
      // Fallback: valores padrão caso não haja usuário logado
      _apelido = 'Vasconcelos';
      _signo = 'Aquário';
      _dataNascimento = '13/02/1990';
      _euSou = 'Homem';
      _sexualidade = 'Heterossexual';
      _estadoCivil = 'Solteiro';
      _filhos = '1';
      _escolaridade = 'Superior incompleto';
      _profissao = 'Técnico de Farmácia';
      _humor = 'Amigável';

      _pais = 'Moçambique';
      _provincia = 'Nampula';
      _cidade = 'Macira';
      _moraCom = 'Sozinho';

      _corPele = 'Negra';
      _corOlhos = 'Não responder';
      _corCabelos = 'Não responder';
      _peso = 'Não responder';
      _altura = 'Não responder';

      _praticaEsporte = 'Não responder';
      _fuma = 'Não';
      _bebe = 'Ocasionalmente';

      _comoMeConsideroFisicamente = 'Atraente e simpático.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 768;
    final bool isTablet = width >= 768 && width < 1024;
    final bool isDesktop = width >= 1024;

    final double maxFormWidth = isDesktop
        ? 900
        : (isTablet ? 720 : double.infinity);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Perfil',
          style: TextStyle(color: theme.textTheme.titleLarge?.color),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxFormWidth),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfilePhotoSection(isMobile),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Dados Pessoais'),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildTextField(
                        label: 'Apelido',
                        initialValue: _apelido,
                        onSaved: (v) => _apelido = v ?? '',
                      ),
                      _buildSelectField(
                        label: 'Signo',
                        value: _signo,
                        options: signos,
                        onChanged: (v) => _signo = v ?? _signo,
                      ),
                    ),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildDateField(
                        label: 'Data de Nascimento',
                        value: _dataNascimento,
                        onSaved: (v) => _dataNascimento = v ?? '',
                      ),
                      _buildTextField(
                        label: 'Eu sou',
                        initialValue: _euSou,
                        onSaved: (v) => _euSou = v ?? '',
                      ),
                    ),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildSelectField(
                        label: 'Sexualidade',
                        value: _sexualidade,
                        options: sexualidades,
                        onChanged: (v) => _sexualidade = v ?? _sexualidade,
                      ),
                      _buildSelectField(
                        label: 'Estado Civil',
                        value: _estadoCivil,
                        options: estadosCivis,
                        onChanged: (v) => _estadoCivil = v ?? _estadoCivil,
                      ),
                    ),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildTextField(
                        label: 'Filhos',
                        initialValue: _filhos,
                        onSaved: (v) => _filhos = v ?? '',
                      ),
                      _buildSelectField(
                        label: 'Escolaridade',
                        value: _escolaridade,
                        options: escolaridades,
                        onChanged: (v) => _escolaridade = v ?? _escolaridade,
                      ),
                    ),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildTextField(
                        label: 'Profissão',
                        initialValue: _profissao,
                        onSaved: (v) => _profissao = v ?? '',
                      ),
                      _buildSelectField(
                        label: 'Humor',
                        value: _humor,
                        options: humores,
                        onChanged: (v) => _humor = v ?? _humor,
                      ),
                    ),

                    const SizedBox(height: 24),
                    _buildSectionTitle('Localização'),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildSelectField(
                        label: 'País',
                        value: _pais,
                        options: paises,
                        onChanged: (v) => _pais = v ?? _pais,
                      ),
                      _buildSelectField(
                        label: 'Província/Estado',
                        value: _provincia,
                        options: provinciasMocambique,
                        onChanged: (v) => _provincia = v ?? _provincia,
                      ),
                    ),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildTextField(
                        label: 'Cidade',
                        initialValue: _cidade,
                        onSaved: (v) => _cidade = v ?? '',
                      ),
                      _buildTextField(
                        label: 'Mora com',
                        initialValue: _moraCom,
                        onSaved: (v) => _moraCom = v ?? '',
                      ),
                    ),

                    const SizedBox(height: 24),
                    _buildSectionTitle('Aparência'),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildTextField(
                        label: 'Cor da Pele',
                        initialValue: _corPele,
                        onSaved: (v) => _corPele = v ?? '',
                      ),
                      _buildSelectField(
                        label: 'Cor dos Olhos',
                        value: _corOlhos,
                        options: coresOlhos,
                        onChanged: (v) => _corOlhos = v ?? _corOlhos,
                      ),
                    ),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildSelectField(
                        label: 'Cor dos Cabelos',
                        value: _corCabelos,
                        options: coresCabelos,
                        onChanged: (v) => _corCabelos = v ?? _corCabelos,
                      ),
                      _buildSelectField(
                        label: 'Peso',
                        value: _peso,
                        options: pesos,
                        onChanged: (v) => _peso = v ?? _peso,
                      ),
                    ),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildSelectField(
                        label: 'Altura',
                        value: _altura,
                        options: alturas,
                        onChanged: (v) => _altura = v ?? _altura,
                      ),
                    ),

                    const SizedBox(height: 24),
                    _buildSectionTitle('Hábitos'),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildSelectField(
                        label: 'Pratica Esporte',
                        value: _praticaEsporte,
                        options: praticaEsporte,
                        onChanged: (v) => _praticaEsporte = v ?? _praticaEsporte,
                      ),
                      _buildSelectField(
                        label: 'Fuma',
                        value: _fuma,
                        options: fuma,
                        onChanged: (v) => _fuma = v ?? _fuma,
                      ),
                    ),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildSelectField(
                        label: 'Bebe',
                        value: _bebe,
                        options: bebe,
                        onChanged: (v) => _bebe = v ?? _bebe,
                      ),
                    ),

                    const SizedBox(height: 24),
                    _buildSectionTitle('Como me considero fisicamente'),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildTextField(
                        label: 'Descrição',
                        initialValue: _comoMeConsideroFisicamente,
                        onSaved: (v) => _comoMeConsideroFisicamente = v ?? '',
                        maxLines: 3,
                      ),
                    ),

                    const SizedBox(height: 32),
                    Align(
                      alignment:
                          isMobile ? Alignment.center : Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _handleSave,
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar alterações'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleChangeProfilePhoto() async {
    if (kIsWeb) {
      await _handleChangeProfilePhotoWeb();
    } else {
      await _handleChangeProfilePhotoNative();
    }
  }

  Future<void> _handleChangeProfilePhotoWeb() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (picked == null) {
        return;
      }

      final bytes = await picked.readAsBytes();

      setState(() {
        _webProfileBytes = bytes;
        _localProfileImage = null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar foto: $e')),
        );
      }
    }
  }

  Future<void> _handleChangeProfilePhotoNative() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (picked == null) {
        return;
      }

      final file = File(picked.path);

      setState(() {
        _localProfileImage = file;
        _uploadingProfile = true;
      });

      // Usa o fluxo de presign -> upload -> register para tipo "profile"
      final presign = await _uploadService.getPresignedUrl(file, 'profile');

      await _uploadService.uploadFileToPresignedUrl(
        file,
        presign['uploadUrl'] as String,
        'application/octet-stream',
      );

      await _uploadService.registerMedia(
        presign['key'] as String,
        file,
        'profile',
      );

      setState(() {
        _uploadingProfile = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto de perfil atualizada com sucesso.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _uploadingProfile = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar foto de perfil: $e'),
          ),
        );
      }
    }
  }

  Widget _buildProfilePhotoSection(bool isMobile) {
    final theme = Theme.of(context);
    final double avatarSize = isMobile ? 96 : 112;

    Widget avatarChild;
    if (kIsWeb && _webProfileBytes != null) {
      avatarChild = ClipOval(
        child: Image.memory(
          _webProfileBytes!,
          fit: BoxFit.cover,
        ),
      );
    } else if (!kIsWeb && _localProfileImage != null) {
      avatarChild = ClipOval(
        child: Image.file(
          _localProfileImage!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      avatarChild = Icon(
        Icons.person,
        size: avatarSize * 0.6,
        color: theme.colorScheme.onSurfaceVariant,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: avatarSize,
          width: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary,
              width: 3,
            ),
          ),
          child: ClipOval(
            child: Material(
              color: theme.colorScheme.surface,
              child: Center(child: avatarChild),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Foto de perfil',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Escolha uma foto para ser exibida no seu perfil.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed:
                    _uploadingProfile ? null : _handleChangeProfilePhoto,
                icon: _uploadingProfile
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.camera_alt),
                label: Text(
                  _uploadingProfile
                      ? 'Enviando...'
                      : 'Alterar foto de perfil',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados de perfil salvos (simulação).'),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildResponsiveRow(bool isWide, Widget first, [Widget? second]) {
    if (!isWide || second == null) {
      return first;
    }
    return Row(
      children: [
        Expanded(child: first),
        const SizedBox(width: 16),
        Expanded(child: second),
      ],
    );
  }

  Widget _buildSelectField({
    required String label,
    required String value,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String value,
    required void Function(String?) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.tryParse(value) ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            final formattedDate = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
            onSaved(formattedDate);
          }
        },
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required void Function(String?) onSaved,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: onSaved,
      ),
    );
  }
}

