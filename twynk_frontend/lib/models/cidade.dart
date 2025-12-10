class Cidade {
  final String id;
  final String nome;
  final String provinciaId;

  const Cidade({
    required this.id,
    required this.nome,
    required this.provinciaId,
  });

  factory Cidade.fromJson(Map<String, dynamic> json) {
    String parseId(dynamic value) => value?.toString() ?? '';

    return Cidade(
      id: parseId(json['id']),
      nome: json['nome']?.toString() ?? '',
      provinciaId: parseId(json['provincia_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'provincia_id': provinciaId,
    };
  }
}
