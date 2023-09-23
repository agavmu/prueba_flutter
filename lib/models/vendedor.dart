class Seller {
  final String usuario;
  final String empresa;
  final String? portafolio;

  Seller({required this.usuario, required this.empresa, this.portafolio});

  Map<String, dynamic> toMap() {
    return {'nombre': usuario, 'empresa': empresa, 'portafolio': portafolio};
  }
}
