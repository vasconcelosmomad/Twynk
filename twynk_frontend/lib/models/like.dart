import 'user.dart';

class Like {
  final String id;
  final String idUsuarioOrigem;
  final String idUsuarioDestino;
  final DateTime dataLike;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Relacionamentos (opcional, para quando os dados são incluídos)
  final User? usuarioOrigem;
  final User? usuarioDestino;

  const Like({
    required this.id,
    required this.idUsuarioOrigem,
    required this.idUsuarioDestino,
    required this.dataLike,
    required this.createdAt,
    required this.updatedAt,
    this.usuarioOrigem,
    this.usuarioDestino,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id']?.toString() ?? '',
      idUsuarioOrigem: json['id_usuario_origem']?.toString() ?? '',
      idUsuarioDestino: json['id_usuario_destino']?.toString() ?? '',
      dataLike: json['data_like'] != null
          ? DateTime.parse(json['data_like'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      usuarioOrigem: json['usuario_origem'] != null 
          ? User.fromJson(json['usuario_origem'] as Map<String, dynamic>)
          : null,
      usuarioDestino: json['usuario_destino'] != null 
          ? User.fromJson(json['usuario_destino'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_usuario_origem': idUsuarioOrigem,
      'id_usuario_destino': idUsuarioDestino,
      'data_like': dataLike.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (usuarioOrigem != null) 'usuario_origem': usuarioOrigem!.toJson(),
      if (usuarioDestino != null) 'usuario_destino': usuarioDestino!.toJson(),
    };
  }

  Like copyWith({
    String? id,
    String? idUsuarioOrigem,
    String? idUsuarioDestino,
    DateTime? dataLike,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? usuarioOrigem,
    User? usuarioDestino,
  }) {
    return Like(
      id: id ?? this.id,
      idUsuarioOrigem: idUsuarioOrigem ?? this.idUsuarioOrigem,
      idUsuarioDestino: idUsuarioDestino ?? this.idUsuarioDestino,
      dataLike: dataLike ?? this.dataLike,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      usuarioOrigem: usuarioOrigem ?? this.usuarioOrigem,
      usuarioDestino: usuarioDestino ?? this.usuarioDestino,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Like && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Like(id: $id, origem: $idUsuarioOrigem, destino: $idUsuarioDestino)';
  }
}
