import 'user.dart';
import 'plano.dart';

enum TransacaoStatus {
  pending('pending'),
  completed('completed'),
  failed('failed'),
  cancelled('cancelled'),
  refunded('refunded');

  const TransacaoStatus(this.value);
  final String value;

  static TransacaoStatus fromString(String value) {
    return TransacaoStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TransacaoStatus.pending,
    );
  }
}

enum MetodoPagamento {
  creditCard('credit_card'),
  debitCard('debit_card'),
  paypal('paypal'),
  bankTransfer('bank_transfer'),
  pix('pix'),
  other('other');

  const MetodoPagamento(this.value);
  final String value;

  static MetodoPagamento fromString(String value) {
    return MetodoPagamento.values.firstWhere(
      (metodo) => metodo.value == value,
      orElse: () => MetodoPagamento.other,
    );
  }
}

class Transacao {
  final String id;
  final String usuarioId;
  final String planoId;
  final double valorPago;
  final MetodoPagamento metodoPagamento;
  final DateTime dataPagamento;
  final TransacaoStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Relacionamentos (opcional, para quando os dados são incluídos)
  final User? usuario;
  final Plano? plano;

  const Transacao({
    required this.id,
    required this.usuarioId,
    required this.planoId,
    required this.valorPago,
    required this.metodoPagamento,
    required this.dataPagamento,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.usuario,
    this.plano,
  });

  factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(
      id: json['id']?.toString() ?? '',
      usuarioId: json['usuario_id']?.toString() ?? '',
      planoId: json['plano_id']?.toString() ?? '',
      valorPago: (json['valor_pago'] as num?)?.toDouble() ?? 0.0,
      metodoPagamento: MetodoPagamento.fromString(
        json['metodo_pagamento']?.toString() ?? 'other',
      ),
      dataPagamento: json['data_pagamento'] != null
          ? DateTime.parse(json['data_pagamento'].toString())
          : DateTime.fromMillisecondsSinceEpoch(0),
      status: TransacaoStatus.fromString(
        json['status']?.toString() ?? 'pending',
      ),
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
      'valor_pago': valorPago,
      'metodo_pagamento': metodoPagamento.value,
      'data_pagamento': dataPagamento.toIso8601String(),
      'status': status.value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (usuario != null) 'usuario': usuario!.toJson(),
      if (plano != null) 'plano': plano!.toJson(),
    };
  }

  Transacao copyWith({
    String? id,
    String? usuarioId,
    String? planoId,
    double? valorPago,
    MetodoPagamento? metodoPagamento,
    DateTime? dataPagamento,
    TransacaoStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? usuario,
    Plano? plano,
  }) {
    return Transacao(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      planoId: planoId ?? this.planoId,
      valorPago: valorPago ?? this.valorPago,
      metodoPagamento: metodoPagamento ?? this.metodoPagamento,
      dataPagamento: dataPagamento ?? this.dataPagamento,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      usuario: usuario ?? this.usuario,
      plano: plano ?? this.plano,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transacao && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Transacao(id: $id, valor: $valorPago, status: $status)';
  }
}
