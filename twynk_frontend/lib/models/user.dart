class User {
  final String id;

  // Dados básicos
  final String nome;
  final String? apelido;
  final String? genero;
  final String? sexualidade;
  final String? interesse;
  final String? estadoCivil;
  final DateTime? dataNascimento;
  final String? signo;
  final String email;
  final String? password;
  final String? googleId;
  final bool isVerified;
  final bool isBanned;
  final String? motivoBanamento;
  final DateTime? ultimoLogin;
  final String role;

  // Preferências de relacionamento / busca
  final String? tipoRelacionamento;
  final String? buscaGenero;
  final int? buscaIdadeMin;
  final int? buscaIdadeMax;
  final int? buscaDistancia;

  // Dados pessoais adicionais
  final int? filhos;
  final String? escolaridade;
  final String? profissao;
  final String? religiao;
  final String? humor;

  // Localização normalizada (ids)
  final int? paisId;
  final int? provinciaId;
  final int? cidadeId;
  final String? moraCom;

  // Aparência física
  final String? corPele;
  final String? corOlhos;
  final String? corCabelos;
  final double? altura;
  final double? peso;

  // Hábitos e estilo de vida
  final bool? praticaEsporte;
  final bool? fuma;
  final bool? bebe;
  final String? comoMeConsideroFisicamente;

  // Coordenadas de GPS
  final double? latitude;
  final double? longitude;

  // Status e plano
  final String? status;
  final int? planoId;
  final DateTime? planoExpiraEm;
  final int? limiteSolicitacoes;

  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.nome,
    this.apelido,
    this.genero,
    this.sexualidade,
    this.interesse,
    this.estadoCivil,
    this.dataNascimento,
    this.signo,
    required this.email,
    this.password,
    this.googleId,
    this.isVerified = false,
    this.isBanned = false,
    this.motivoBanamento,
    this.ultimoLogin,
    this.role = 'user',
    this.tipoRelacionamento,
    this.buscaGenero,
    this.buscaIdadeMin,
    this.buscaIdadeMax,
    this.buscaDistancia,
    this.filhos,
    this.escolaridade,
    this.profissao,
    this.religiao,
    this.humor,
    this.paisId,
    this.provinciaId,
    this.cidadeId,
    this.moraCom,
    this.corPele,
    this.corOlhos,
    this.corCabelos,
    this.altura,
    this.peso,
    this.praticaEsporte,
    this.fuma,
    this.bebe,
    this.comoMeConsideroFisicamente,
    this.latitude,
    this.longitude,
    this.status,
    this.planoId,
    this.planoExpiraEm,
    this.limiteSolicitacoes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      return DateTime.parse(value.toString());
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    bool? parseBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      final s = value.toString().toLowerCase();
      if (s == '1' || s == 'true') return true;
      if (s == '0' || s == 'false') return false;
      return null;
    }

    return User(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      apelido: json['apelido']?.toString(),
      genero: json['genero']?.toString(),
      sexualidade: json['sexualidade']?.toString(),
      interesse: json['interesse']?.toString(),
      estadoCivil: json['estado_civil']?.toString(),
      dataNascimento: parseDate(json['data_nascimento']),
      signo: json['signo']?.toString(),
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString(),
      googleId: json['google_id']?.toString(),
      isVerified: parseBool(json['is_verified']) ?? false,
      isBanned: parseBool(json['is_banned']) ?? false,
      motivoBanamento: json['motivo_banamento']?.toString(),
      ultimoLogin: parseDate(json['ultimo_login']),
      role: json['role']?.toString() ?? 'user',
      tipoRelacionamento: json['tipo_relacionamento']?.toString(),
      buscaGenero: json['busca_genero']?.toString(),
      buscaIdadeMin: parseInt(json['busca_idade_min']),
      buscaIdadeMax: parseInt(json['busca_idade_max']),
      buscaDistancia: parseInt(json['busca_distancia']),
      filhos: parseInt(json['filhos']),
      escolaridade: json['escolaridade']?.toString(),
      profissao: json['profissao']?.toString(),
      religiao: json['religiao']?.toString(),
      humor: json['humor']?.toString(),
      paisId: parseInt(json['pais_id']),
      provinciaId: parseInt(json['provincia_id']),
      cidadeId: parseInt(json['cidade_id']),
      moraCom: json['mora_com']?.toString(),
      corPele: json['cor_pele']?.toString(),
      corOlhos: json['cor_olhos']?.toString(),
      corCabelos: json['cor_cabelos']?.toString(),
      altura: parseDouble(json['altura']),
      peso: parseDouble(json['peso']),
      praticaEsporte: parseBool(json['pratica_esporte']),
      fuma: parseBool(json['fuma']),
      bebe: parseBool(json['bebe']),
      comoMeConsideroFisicamente:
          json['como_me_considero_fisicamente']?.toString(),
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      status: json['status']?.toString(),
      planoId: parseInt(json['plano_id']),
      planoExpiraEm: parseDate(json['plano_expira_em']),
      limiteSolicitacoes: parseInt(json['limite_solicitacoes']),
      createdAt: parseDate(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: parseDate(json['updated_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'apelido': apelido,
      'genero': genero,
      'sexualidade': sexualidade,
      'interesse': interesse,
      'estado_civil': estadoCivil,
      'data_nascimento': dataNascimento?.toIso8601String(),
      'signo': signo,
      'email': email,
      'password': password,
      'google_id': googleId,
      'is_verified': isVerified,
      'is_banned': isBanned,
      'motivo_banamento': motivoBanamento,
      'ultimo_login': ultimoLogin?.toIso8601String(),
      'role': role,
      'tipo_relacionamento': tipoRelacionamento,
      'busca_genero': buscaGenero,
      'busca_idade_min': buscaIdadeMin,
      'busca_idade_max': buscaIdadeMax,
      'busca_distancia': buscaDistancia,
      'filhos': filhos,
      'escolaridade': escolaridade,
      'profissao': profissao,
      'religiao': religiao,
      'humor': humor,
      'pais_id': paisId,
      'provincia_id': provinciaId,
      'cidade_id': cidadeId,
      'mora_com': moraCom,
      'cor_pele': corPele,
      'cor_olhos': corOlhos,
      'cor_cabelos': corCabelos,
      'altura': altura,
      'peso': peso,
      'pratica_esporte': praticaEsporte,
      'fuma': fuma,
      'bebe': bebe,
      'como_me_considero_fisicamente': comoMeConsideroFisicamente,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'plano_id': planoId,
      'plano_expira_em': planoExpiraEm?.toIso8601String(),
      'limite_solicitacoes': limiteSolicitacoes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? nome,
    String? apelido,
    String? genero,
    String? sexualidade,
    String? interesse,
    String? estadoCivil,
    DateTime? dataNascimento,
    String? signo,
    String? email,
    String? password,
    String? googleId,
    bool? isVerified,
    bool? isBanned,
    String? motivoBanamento,
    DateTime? ultimoLogin,
    String? role,
    String? tipoRelacionamento,
    String? buscaGenero,
    int? buscaIdadeMin,
    int? buscaIdadeMax,
    int? buscaDistancia,
    int? filhos,
    String? escolaridade,
    String? profissao,
    String? religiao,
    String? humor,
    int? paisId,
    int? provinciaId,
    int? cidadeId,
    String? moraCom,
    String? corPele,
    String? corOlhos,
    String? corCabelos,
    double? altura,
    double? peso,
    bool? praticaEsporte,
    bool? fuma,
    bool? bebe,
    String? comoMeConsideroFisicamente,
    double? latitude,
    double? longitude,
    String? status,
    int? planoId,
    DateTime? planoExpiraEm,
    int? limiteSolicitacoes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      apelido: apelido ?? this.apelido,
      genero: genero ?? this.genero,
      sexualidade: sexualidade ?? this.sexualidade,
      interesse: interesse ?? this.interesse,
      estadoCivil: estadoCivil ?? this.estadoCivil,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      signo: signo ?? this.signo,
      email: email ?? this.email,
      password: password ?? this.password,
      googleId: googleId ?? this.googleId,
      isVerified: isVerified ?? this.isVerified,
      isBanned: isBanned ?? this.isBanned,
      motivoBanamento: motivoBanamento ?? this.motivoBanamento,
      ultimoLogin: ultimoLogin ?? this.ultimoLogin,
      role: role ?? this.role,
      tipoRelacionamento: tipoRelacionamento ?? this.tipoRelacionamento,
      buscaGenero: buscaGenero ?? this.buscaGenero,
      buscaIdadeMin: buscaIdadeMin ?? this.buscaIdadeMin,
      buscaIdadeMax: buscaIdadeMax ?? this.buscaIdadeMax,
      buscaDistancia: buscaDistancia ?? this.buscaDistancia,
      filhos: filhos ?? this.filhos,
      escolaridade: escolaridade ?? this.escolaridade,
      profissao: profissao ?? this.profissao,
      religiao: religiao ?? this.religiao,
      humor: humor ?? this.humor,
      paisId: paisId ?? this.paisId,
      provinciaId: provinciaId ?? this.provinciaId,
      cidadeId: cidadeId ?? this.cidadeId,
      moraCom: moraCom ?? this.moraCom,
      corPele: corPele ?? this.corPele,
      corOlhos: corOlhos ?? this.corOlhos,
      corCabelos: corCabelos ?? this.corCabelos,
      altura: altura ?? this.altura,
      peso: peso ?? this.peso,
      praticaEsporte: praticaEsporte ?? this.praticaEsporte,
      fuma: fuma ?? this.fuma,
      bebe: bebe ?? this.bebe,
      comoMeConsideroFisicamente:
          comoMeConsideroFisicamente ?? this.comoMeConsideroFisicamente,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      planoId: planoId ?? this.planoId,
      planoExpiraEm: planoExpiraEm ?? this.planoExpiraEm,
      limiteSolicitacoes: limiteSolicitacoes ?? this.limiteSolicitacoes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, nome: $nome, email: $email)';
  }
}
