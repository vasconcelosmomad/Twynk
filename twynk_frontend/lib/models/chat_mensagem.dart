import 'user.dart';
import 'media.dart';

enum MensagemTipo {
  texto('texto'),
  media('media');

  const MensagemTipo(this.value);
  final String value;

  static MensagemTipo fromString(String value) {
    return MensagemTipo.values.firstWhere(
      (tipo) => tipo.value == value,
      orElse: () => MensagemTipo.texto,
    );
  }
}

class ChatMensagem {
  final String id;
  final String chatId;
  final String remetenteId;
  final String destinatarioId;
  final MensagemTipo tipo;
  final String? conteudo;
  final String? mediaId;
  final DateTime dataEnvio;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Relacionamentos (opcional, para quando os dados são incluídos)
  final User? remetente;
  final User? destinatario;
  final Media? media;

  const ChatMensagem({
    required this.id,
    required this.chatId,
    required this.remetenteId,
    required this.destinatarioId,
    required this.tipo,
    this.conteudo,
    this.mediaId,
    required this.dataEnvio,
    required this.createdAt,
    required this.updatedAt,
    this.remetente,
    this.destinatario,
    this.media,
  });

  factory ChatMensagem.fromJson(Map<String, dynamic> json) {
    return ChatMensagem(
      id: json['id']?.toString() ?? '',
      chatId: json['chat_id']?.toString() ?? '',
      remetenteId: json['remetente_id']?.toString() ?? '',
      destinatarioId: json['destinatario_id']?.toString() ?? '',
      tipo: MensagemTipo.fromString(json['tipo']?.toString() ?? 'texto'),
      conteudo: json['conteudo'] as String?,
      mediaId: json['media_id']?.toString(),
      dataEnvio: json['data_envio'] != null
          ? DateTime.parse(json['data_envio'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      remetente: json['remetente'] != null 
          ? User.fromJson(json['remetente'] as Map<String, dynamic>)
          : null,
      destinatario: json['destinatario'] != null 
          ? User.fromJson(json['destinatario'] as Map<String, dynamic>)
          : null,
      media: json['media'] != null 
          ? Media.fromJson(json['media'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'remetente_id': remetenteId,
      'destinatario_id': destinatarioId,
      'tipo': tipo.value,
      'conteudo': conteudo,
      'media_id': mediaId,
      'data_envio': dataEnvio.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (remetente != null) 'remetente': remetente!.toJson(),
      if (destinatario != null) 'destinatario': destinatario!.toJson(),
      if (media != null) 'media': media!.toJson(),
    };
  }

  ChatMensagem copyWith({
    String? id,
    String? chatId,
    String? remetenteId,
    String? destinatarioId,
    MensagemTipo? tipo,
    String? conteudo,
    String? mediaId,
    DateTime? dataEnvio,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? remetente,
    User? destinatario,
    Media? media,
  }) {
    return ChatMensagem(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      remetenteId: remetenteId ?? this.remetenteId,
      destinatarioId: destinatarioId ?? this.destinatarioId,
      tipo: tipo ?? this.tipo,
      conteudo: conteudo ?? this.conteudo,
      mediaId: mediaId ?? this.mediaId,
      dataEnvio: dataEnvio ?? this.dataEnvio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      remetente: remetente ?? this.remetente,
      destinatario: destinatario ?? this.destinatario,
      media: media ?? this.media,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMensagem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ChatMensagem(id: $id, tipo: $tipo, chatId: $chatId)';
  }
}
