class ProductsCatalog {
  final String name;
  final double price;
  final String? archive;

  ProductsCatalog({
    required this.name,
    required this.price,
    this.archive,
  });

  Map<String, dynamic> toMap() {
    return {
      'Nombre': name,
      'Precio': price,
      'Archivo': archive,
    };
  }
}
