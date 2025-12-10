import 'user.dart';
import 'plano.dart';

class Assinatura {
  final String id;
  final String usuarioId;
  final String planoId;
  final DateTime dataInicio;
  final DateTime? dataFim;
  final bool ativo;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Relacionamentos (opcional, para quando os dados são incluídos)
  final User? usuario;
  final Plano? plano;

  const Assinatura({
    required this.id,
    required this.usuarioId,
    required this.planoId,
    required this.dataInicio,
    this.dataFim,
    required this.ativo,
    required this.createdAt,
    required this.updatedAt,
    this.usuario,
    this.plano,
  });

  factory Assinatura.fromJson(Map<String, dynamic> json) {
    return Assinatura(
      id: json['id']?.toString() ?? '',
      usuarioId: json['usuario_id']?.toString() ?? '',
      planoId: json['plano_id']?.toString() ?? '',
      dataInicio: json['data_inicio'] != null
          ? DateTime.parse(json['data_inicio'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      dataFim: json['data_fim'] != null
          ? DateTime.parse(json['data_fim'].toString())
          : null,
      ativo: json['ativo'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      usuario: json['usuario'] != null 
          ? User.fromJson(json['usuario'] as Map<String, dynamic>)
          : null,
      plano: json['plano'] != null 
          ? Plano.fromJson(json['plano'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'plano_id': planoId,
      'data_inicio': dataInicio.toIso8601String(),
      'data_fim': dataFim?.toIso8601String(),
      'ativo': ativo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (usuario != null) 'usuario': usuario!.toJson(),
      if (plano != null) 'plano': plano!.toJson(),
    };
  }

  Assinatura copyWith({
    String? id,
    String? usuarioId,
    String? planoId,
    DateTime? dataInicio,
    DateTime? dataFim,
    bool? ativo,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? usuario,
    Plano? plano,
  }) {
    return Assinatura(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      planoId: planoId ?? this.planoId,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      usuario: usuario ?? this.usuario,
      plano: plano ?? this.plano,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Assinatura && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Assinatura(id: $id, usuarioId: $usuarioId, planoId: $planoId, ativo: $ativo)';
  }
}
