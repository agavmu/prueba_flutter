class Seller {
  final String code;
  final String? name;
  final String? portafolio;

  Seller({required this.code, this.name, this.portafolio});

  Map<String, dynamic> toMap() {
    return {'codigo': code, 'nombre': name, 'portafolio': portafolio};
  }

  @override
  String toString() {
    return 'Vendedor{codigo: $code, nombre: $name, portafolio: $portafolio}';
  }
}
