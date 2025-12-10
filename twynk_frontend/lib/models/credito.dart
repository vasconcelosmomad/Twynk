import 'user.dart';

class Credito {
  final String id;
  final String usuarioId;
  final double saldo;
  final DateTime ultimoUpdate;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Relacionamentos (opcional, para quando os dados são incluídos)
  final User? usuario;

  const Credito({
    required this.id,
    required this.usuarioId,
    required this.saldo,
    required this.ultimoUpdate,
    required this.createdAt,
    required this.updatedAt,
    this.usuario,
  });

  factory Credito.fromJson(Map<String, dynamic> json) {
    return Credito(
      id: json['id']?.toString() ?? '',
      usuarioId: json['usuario_id']?.toString() ?? '',
      saldo: (json['saldo'] as num?)?.toDouble() ?? 0.0,
      ultimoUpdate: json['ultimo_update'] != null
          ? DateTime.parse(json['ultimo_update'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      usuario: json['usuario'] != null 
          ? User.fromJson(json['usuario'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'saldo': saldo,
      'ultimo_update': ultimoUpdate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (usuario != null) 'usuario': usuario!.toJson(),
    };
  }

  Credito copyWith({
    String? id,
    String? usuarioId,
    double? saldo,
    DateTime? ultimoUpdate,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? usuario,
  }) {
    return Credito(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      saldo: saldo ?? this.saldo,
      ultimoUpdate: ultimoUpdate ?? this.ultimoUpdate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      usuario: usuario ?? this.usuario,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Credito && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Credito(id: $id, usuarioId: $usuarioId, saldo: $saldo)';
  }
}
