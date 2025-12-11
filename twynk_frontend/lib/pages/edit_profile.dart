import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/location_provider.dart';
import '../models/user.dart';
import '../models/pais.dart';
import '../models/provincia.dart';
import '../models/cidade.dart';
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

  List<Pais> _paisesDisponiveis = [];
  List<Provincia> _provinciasDisponiveis = [];
  String? _paisIdSelecionado;
  String? _provinciaIdSelecionada;
  List<Cidade> _cidadesDisponiveis = [];
  String? _cidadeIdSelecionada;

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

  static const List<String> coresOlhos = [
    'Castanhos', 'Azuis', 'Verdes', 'Pretos', 'Cinza', 'Não responder'
  ];

  static const List<String> coresCabelos = [
    'Preto', 'Castanho', 'Loiro', 'Ruivo', 'Grisalho', 'Careca', 'Não responder'
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
      _pais = '';
      _provincia = '';
      _cidade = '';
      _moraCom = user.moraCom ?? '';

      // Aparência
      _corPele = user.corPele ?? '';
      _corOlhos = ensureInOptions(user.corOlhos, coresOlhos, coresOlhos.last);
      _corCabelos = ensureInOptions(user.corCabelos, coresCabelos, coresCabelos.last);
      _peso = user.peso?.toString() ?? '';
      _altura = user.altura?.toString() ?? '';

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
      _peso = '';
      _altura = '';

      _praticaEsporte = 'Não responder';
      _fuma = 'Não';
      _bebe = 'Ocasionalmente';

      _comoMeConsideroFisicamente = 'Atraente e simpático.';
    }
    // Carrega dados de localização após o primeiro frame para evitar setState durante o build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLocationData(user);
    });
  }

  Future<void> _loadLocationData(User? user) async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    try {
      await locationProvider.fetchPaises();
      final paisesCarregados = locationProvider.paises;
      String? paisIdSelecionado = _paisIdSelecionado;
      if (user?.paisId != null && paisesCarregados.isNotEmpty) {
        final correspondentes = paisesCarregados.where((p) => p.id == user!.paisId!.toString()).toList();
        if (correspondentes.isNotEmpty) {
          paisIdSelecionado = correspondentes.first.id;
        }
      }
      paisIdSelecionado ??= paisesCarregados.isNotEmpty ? paisesCarregados.first.id : null;

      List<Provincia> provinciasCarregadas = [];
      if (paisIdSelecionado != null) {
        await locationProvider.fetchProvincias(paisId: paisIdSelecionado);
        provinciasCarregadas = locationProvider.provincias;
      }

      String? provinciaIdSelecionada = _provinciaIdSelecionada;
      if (user?.provinciaId != null && provinciasCarregadas.isNotEmpty) {
        final correspondentesProv = provinciasCarregadas.where((p) => p.id == user!.provinciaId!.toString()).toList();
        if (correspondentesProv.isNotEmpty) {
          provinciaIdSelecionada = correspondentesProv.first.id;
        }
      }
      provinciaIdSelecionada ??= provinciasCarregadas.isNotEmpty ? provinciasCarregadas.first.id : null;

      List<Cidade> cidadesCarregadas = [];
      String? cidadeIdSelecionada = _cidadeIdSelecionada;
      if (provinciaIdSelecionada != null) {
        await locationProvider.fetchCidades(provinciaId: provinciaIdSelecionada);
        cidadesCarregadas = locationProvider.cidades;
        if (user?.cidadeId != null && cidadesCarregadas.isNotEmpty) {
          final correspondentesCidade = cidadesCarregadas
              .where((c) => c.id == user!.cidadeId!.toString())
              .toList();
          if (correspondentesCidade.isNotEmpty) {
            cidadeIdSelecionada = correspondentesCidade.first.id;
          }
        }
      }
      cidadeIdSelecionada ??= cidadesCarregadas.isNotEmpty ? cidadesCarregadas.first.id : null;

      if (!mounted) return;
      setState(() {
        _paisesDisponiveis = paisesCarregados;
        _provinciasDisponiveis = provinciasCarregadas;
        _paisIdSelecionado = paisIdSelecionado;
        _provinciaIdSelecionada = provinciaIdSelecionada;
        _cidadesDisponiveis = cidadesCarregadas;
        _cidadeIdSelecionada = cidadeIdSelecionada;
        if (paisIdSelecionado != null && paisesCarregados.isNotEmpty) {
          final paisSelecionado = paisesCarregados.firstWhere(
            (p) => p.id == paisIdSelecionado,
            orElse: () => paisesCarregados.first,
          );
          _pais = paisSelecionado.nome;
        }
        if (provinciaIdSelecionada != null && provinciasCarregadas.isNotEmpty) {
          final provinciaSelecionada = provinciasCarregadas.firstWhere(
            (p) => p.id == provinciaIdSelecionada,
            orElse: () => provinciasCarregadas.first,
          );
          _provincia = provinciaSelecionada.nome;
        }
        if (cidadeIdSelecionada != null && cidadesCarregadas.isNotEmpty) {
          final cidadeSelecionada = cidadesCarregadas.firstWhere(
            (c) => c.id == cidadeIdSelecionada,
            orElse: () => cidadesCarregadas.first,
          );
          _cidade = cidadeSelecionada.nome;
        }
      });
    } catch (_) {}
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

    final List<String> paisOptions =
        _paisesDisponiveis.map((p) => p.nome).toList();
    final List<String> provinciaOptions =
        _provinciasDisponiveis.map((p) => p.nome).toList();
    final List<String> cidadeOptions = _cidadesDisponiveis.isNotEmpty
        ? _cidadesDisponiveis.map((c) => c.nome).toList()
        : (_cidade.isNotEmpty ? [_cidade] : []);
    final bool hasPaisOptions = paisOptions.isNotEmpty;
    final bool hasProvinciaOptions = provinciaOptions.isNotEmpty;
    final bool hasCidadeOptions = cidadeOptions.isNotEmpty;

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
                      _buildSelectField(
                        label: 'Eu sou',
                        value: _euSou,
                        options: const ['Homem', 'Mulher', 'Outro'],
                        onChanged: (v) => _euSou = v ?? _euSou,
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
                      hasPaisOptions
                          ? _buildSelectField(
                              label: 'País',
                              value: _pais,
                              options: paisOptions,
                              onChanged: (v) async {
                                if (v == null) return;
                                setState(() {
                                  _pais = v;
                                });
                                if (_paisesDisponiveis.isEmpty) return;
                                final selecionado = _paisesDisponiveis.firstWhere(
                                  (p) => p.nome == v,
                                  orElse: () => _paisesDisponiveis.first,
                                );
                                _paisIdSelecionado = selecionado.id;
                                final locationProvider = Provider.of<LocationProvider>(context, listen: false);
                                await locationProvider.fetchProvincias(paisId: _paisIdSelecionado);
                                final provinciasAtualizadas = locationProvider.provincias;
                                if (!mounted) return;
                                setState(() {
                                  _provinciasDisponiveis = provinciasAtualizadas;
                                  if (provinciasAtualizadas.isNotEmpty) {
                                    _provinciaIdSelecionada = provinciasAtualizadas.first.id;
                                    _provincia = provinciasAtualizadas.first.nome;
                                  }
                                });
                              },
                            )
                          : _buildTextField(
                              label: 'País',
                              initialValue: _pais,
                              onSaved: (v) => _pais = v ?? '',
                            ),
                      hasProvinciaOptions
                          ? _buildSelectField(
                              label: 'Província/Estado',
                              value: _provincia,
                              options: provinciaOptions,
                              onChanged: (v) {
                                if (v == null) return;
                                setState(() {
                                  _provincia = v;
                                });
                                if (_provinciasDisponiveis.isEmpty) return;
                                final selecionada = _provinciasDisponiveis.firstWhere(
                                  (p) => p.nome == v,
                                  orElse: () => _provinciasDisponiveis.first,
                                );
                                _provinciaIdSelecionada = selecionada.id;
                                // Ao mudar a província, recarrega cidades
                                () async {
                                  final locationProvider = Provider.of<LocationProvider>(context, listen: false);
                                  await locationProvider.fetchCidades(provinciaId: _provinciaIdSelecionada);
                                  final cidadesAtualizadas = locationProvider.cidades;
                                  if (!mounted) return;
                                  setState(() {
                                    _cidadesDisponiveis = cidadesAtualizadas;
                                    if (cidadesAtualizadas.isNotEmpty) {
                                      _cidadeIdSelecionada = cidadesAtualizadas.first.id;
                                      _cidade = cidadesAtualizadas.first.nome;
                                    }
                                  });
                                }();
                              },
                            )
                          : _buildTextField(
                              label: 'Província/Estado',
                              initialValue: _provincia,
                              onSaved: (v) => _provincia = v ?? '',
                            ),
                    ),
                    _buildResponsiveRow(
                      !isMobile,
                      hasCidadeOptions
                          ? _buildSelectField(
                              label: 'Cidade',
                              value: _cidade,
                              options: cidadeOptions,
                              onChanged: (v) {
                                if (v == null) return;
                                setState(() {
                                  _cidade = v;
                                });
                                if (_cidadesDisponiveis.isEmpty) return;
                                final selecionadaCidade = _cidadesDisponiveis.firstWhere(
                                  (c) => c.nome == v,
                                  orElse: () => _cidadesDisponiveis.first,
                                );
                                _cidadeIdSelecionada = selecionadaCidade.id;
                              },
                            )
                          : _buildTextField(
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
                      _buildNumberField(
                        label: 'Peso (kg)',
                        initialValue: _peso,
                        onSaved: (v) => _peso = v?.trim() ?? '',
                      ),
                    ),
                    _buildResponsiveRow(
                      !isMobile,
                      _buildNumberField(
                        label: 'Altura (cm)',
                        initialValue: _altura,
                        onSaved: (v) => _altura = v?.trim() ?? '',
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

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    _formKey.currentState?.save();

    DateTime? parseBirthDate(String value) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      try {
        final parts = trimmed.split('/');
        if (parts.length == 3) {
          final d = int.parse(parts[0]);
          final m = int.parse(parts[1]);
          final y = int.parse(parts[2]);
          return DateTime(y, m, d);
        }
      } catch (_) {}
      return null;
    }

    String? mapDescricaoToGenero(String value) {
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

    int? parseIntOrNull(String value) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return int.tryParse(trimmed);
    }

    double? parseDoubleOrNull(String value) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return double.tryParse(trimmed.replaceAll(',', '.'));
    }

    bool? parsePraticaEsporte(String value) {
      switch (value) {
        case 'Sim, regularmente':
          return true;
        case 'Não pratico':
          return false;
        default:
          return null;
      }
    }

    bool? parseSimNao(String value) {
      switch (value) {
        case 'Sim':
        case 'Sim, regularmente':
          return true;
        case 'Não':
        case 'Não bebo':
          return false;
        default:
          return null;
      }
    }

    final Map<String, dynamic> data = {};

    // Dados pessoais básicos
    data['apelido'] = _apelido;
    data['signo'] = _signo;
    data['sexualidade'] = _sexualidade;
    data['estado_civil'] = _estadoCivil;

    final generoBackend = mapDescricaoToGenero(_euSou);
    if (generoBackend != null) {
      data['genero'] = generoBackend;
    }

    final filhosInt = parseIntOrNull(_filhos);
    if (filhosInt != null) {
      data['filhos'] = filhosInt;
    }

    data['escolaridade'] = _escolaridade;
    data['profissao'] = _profissao;
    data['humor'] = _humor;

    final dataNascimento = parseBirthDate(_dataNascimento);
    if (dataNascimento != null) {
      final yyyyMmDd =
          '${dataNascimento.year.toString().padLeft(4, '0')}-'
          '${dataNascimento.month.toString().padLeft(2, '0')}-'
          '${dataNascimento.day.toString().padLeft(2, '0')}';
      data['data_nascimento'] = yyyyMmDd;
    }

    // Localização (IDs e texto livre)
    final paisId = _paisIdSelecionado != null
        ? int.tryParse(_paisIdSelecionado!)
        : null;
    final provinciaId = _provinciaIdSelecionada != null
        ? int.tryParse(_provinciaIdSelecionada!)
        : null;
    final cidadeId = _cidadeIdSelecionada != null
        ? int.tryParse(_cidadeIdSelecionada!)
        : null;

    if (paisId != null) data['pais_id'] = paisId;
    if (provinciaId != null) data['provincia_id'] = provinciaId;
    if (cidadeId != null) data['cidade_id'] = cidadeId;

    data['mora_com'] = _moraCom;

    // Aparência
    data['cor_pele'] = _corPele;
    data['cor_olhos'] = _corOlhos;
    data['cor_cabelos'] = _corCabelos;

    final pesoDouble = parseDoubleOrNull(_peso);
    if (pesoDouble != null) {
      data['peso'] = pesoDouble;
    }

    final alturaDouble = parseDoubleOrNull(_altura);
    if (alturaDouble != null) {
      data['altura'] = alturaDouble;
    }

    // Hábitos
    final praticaEsporteBool = parsePraticaEsporte(_praticaEsporte);
    final fumaBool = parseSimNao(_fuma);
    final bebeBool = parseSimNao(_bebe);

    if (praticaEsporteBool != null) {
      data['pratica_esporte'] = praticaEsporteBool;
    }
    if (fumaBool != null) {
      data['fuma'] = fumaBool;
    }
    if (bebeBool != null) {
      data['bebe'] = bebeBool;
    }

    data['como_me_considero_fisicamente'] = _comoMeConsideroFisicamente;

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final userProvider = appProvider.userProvider;

    final success = await userProvider.updateProfile(data);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados de perfil salvos com sucesso.'),
        ),
      );
      Navigator.of(context).pop();
    } else {
      final errorMessage =
          userProvider.error ?? 'Erro ao salvar os dados de perfil.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
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

  Widget _buildNumberField({
    required String label,
    required String initialValue,
    required void Function(String?) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
        ],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          final text = (value ?? '').trim();
          if (text.isEmpty) {
            return null; // campo opcional
          }

          final parsed = double.tryParse(text.replaceAll(',', '.'));
          if (parsed == null) {
            return 'Informe um número válido';
          }

          if (label.contains('Peso') && (parsed < 30 || parsed > 300)) {
            return 'Informe um peso entre 30 e 300 kg';
          }

          if (label.contains('Altura') && (parsed < 100 || parsed > 250)) {
            return 'Informe uma altura entre 100 e 250 cm';
          }

          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}

