class Client {
  final String code;
  final String name;
  final String? address;

  Client({
    required this.name,
    this.address,
    required this.code,
  });

  Map<String, dynamic> toMap() {
    return {
      'Vendedor1': code,
      'Nombre': name,
      'Barrio': address,
    };
  }
}
