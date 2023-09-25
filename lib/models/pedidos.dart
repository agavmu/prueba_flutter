class Pedidos {
  final int? id;
  final String fechaPedido;
  final String cliente;
  final double total;

  Pedidos({
    this.id,
    required this.fechaPedido,
    required this.cliente,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'fechaPedido': fechaPedido,
      'cliente': cliente,
      'total': total,
    };
  }
}
