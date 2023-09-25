class ProductsCatalog {
  final String code;
  final String name;
  final double price;
  final String? archive;
  int quantity;

  ProductsCatalog(
      {required this.code,
      required this.name,
      required this.price,
      this.archive,
      this.quantity = 0});

  Map<String, dynamic> toMap() {
    return {
      'Codigo': code,
      'Nombre': name,
      'Precio': price,
      'Archivo': archive,
    };
  }

  @override
  String toString() {
    return "codigo: $code, nombre: $name, precio: $price, cantidad: $quantity";
  }
}
