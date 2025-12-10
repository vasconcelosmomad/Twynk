class Plano {
  final String id;
  final String nome;
  final String descricao;
  final int duracao; // duração em dias
  final double preco;
  final bool ativo;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Relacionamentos (opcional, para quando os dados são incluídos)
  final BeneficiosPlano? beneficios;

  const Plano({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.duracao,
    required this.preco,
    required this.ativo,
    required this.createdAt,
    required this.updatedAt,
    this.beneficios,
  });

  factory Plano.fromJson(Map<String, dynamic> json) {
    return Plano(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      descricao: json['descricao']?.toString() ?? '',
      duracao: (json['duracao'] as num?)?.toInt() ?? 0,
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      ativo: json['ativo'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      beneficios: json['beneficios'] != null 
          ? BeneficiosPlano.fromJson(json['beneficios'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'duracao': duracao,
      'preco': preco,
      'ativo': ativo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (beneficios != null) 'beneficios': beneficios!.toJson(),
    };
  }

  Plano copyWith({
    String? id,
    String? nome,
    String? descricao,
    int? duracao,
    double? preco,
    bool? ativo,
    DateTime? createdAt,
    DateTime? updatedAt,
    BeneficiosPlano? beneficios,
  }) {
    return Plano(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      duracao: duracao ?? this.duracao,
      preco: preco ?? this.preco,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      beneficios: beneficios ?? this.beneficios,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Plano && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Plano(id: $id, nome: $nome, preco: $preco)';
  }
}

class BeneficiosPlano {
  final String id;
  final String planoId;
  final int? snapsDiarios;
  final int? chatsDiarios;
  final int? matchesDiarios;
  final bool? verCurtidas;
  final bool? verVisitas;
  final bool? superLike;
  final bool? boostPerfil;
  final bool? modoInvisivel;
  final bool? semAnuncios;
  final String? outrosBeneficios;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BeneficiosPlano({
    required this.id,
    required this.planoId,
    this.snapsDiarios,
    this.chatsDiarios,
    this.matchesDiarios,
    this.verCurtidas,
    this.verVisitas,
    this.superLike,
    this.boostPerfil,
    this.modoInvisivel,
    this.semAnuncios,
    this.outrosBeneficios,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BeneficiosPlano.fromJson(Map<String, dynamic> json) {
    return BeneficiosPlano(
      id: json['id'] as String,
      planoId: json['plano_id'] as String,
      snapsDiarios: json['snaps_diarios'] as int?,
      chatsDiarios: json['chats_diarios'] as int?,
      matchesDiarios: json['matches_diarios'] as int?,
      verCurtidas: json['ver_curtidas'] as bool?,
      verVisitas: json['ver_visitas'] as bool?,
      superLike: json['super_like'] as bool?,
      boostPerfil: json['boost_perfil'] as bool?,
      modoInvisivel: json['modo_invisivel'] as bool?,
      semAnuncios: json['sem_anuncios'] as bool?,
      outrosBeneficios: json['outros_beneficios'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plano_id': planoId,
      'snaps_diarios': snapsDiarios,
      'chats_diarios': chatsDiarios,
      'matches_diarios': matchesDiarios,
      'ver_curtidas': verCurtidas,
      'ver_visitas': verVisitas,
      'super_like': superLike,
      'boost_perfil': boostPerfil,
      'modo_invisivel': modoInvisivel,
      'sem_anuncios': semAnuncios,
      'outros_beneficios': outrosBeneficios,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  BeneficiosPlano copyWith({
    String? id,
    String? planoId,
    int? snapsDiarios,
    int? chatsDiarios,
    int? matchesDiarios,
    bool? verCurtidas,
    bool? verVisitas,
    bool? superLike,
    bool? boostPerfil,
    bool? modoInvisivel,
    bool? semAnuncios,
    String? outrosBeneficios,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BeneficiosPlano(
      id: id ?? this.id,
      planoId: planoId ?? this.planoId,
      snapsDiarios: snapsDiarios ?? this.snapsDiarios,
      chatsDiarios: chatsDiarios ?? this.chatsDiarios,
      matchesDiarios: matchesDiarios ?? this.matchesDiarios,
      verCurtidas: verCurtidas ?? this.verCurtidas,
      verVisitas: verVisitas ?? this.verVisitas,
      superLike: superLike ?? this.superLike,
      boostPerfil: boostPerfil ?? this.boostPerfil,
      modoInvisivel: modoInvisivel ?? this.modoInvisivel,
      semAnuncios: semAnuncios ?? this.semAnuncios,
      outrosBeneficios: outrosBeneficios ?? this.outrosBeneficios,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BeneficiosPlano && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'BeneficiosPlano(id: $id, planoId: $planoId)';
  }
}
