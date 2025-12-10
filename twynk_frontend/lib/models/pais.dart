class Pais {
  final String id;
  final String nome;

  const Pais({
    required this.id,
    required this.nome,
  });

  factory Pais.fromJson(Map<String, dynamic> json) {
    return Pais(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
