class Provincia {
  final String id;
  final String nome;
  final String paisId;

  const Provincia({
    required this.id,
    required this.nome,
    required this.paisId,
  });

  factory Provincia.fromJson(Map<String, dynamic> json) {
    String parseId(dynamic value) => value?.toString() ?? '';

    return Provincia(
      id: parseId(json['id']),
      nome: json['nome']?.toString() ?? '',
      paisId: parseId(json['pais_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'pais_id': paisId,
    };
  }
}
