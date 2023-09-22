import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  Future initDB() async {
    final dbpath = await getDatabasesPath();
    final path =
        join(dbpath, "DataBase.db"); //nombre de la base de datos a migrar

    final exist = await databaseExists(path);
    if (exist) {
      return 'La base de Datos existe';
    } else {
      //Creando una copia de la base de datos desde Assets
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "Database.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
      // Base de datos copiada
      await openDatabase(path);

      _openTableOrders();
      _openTableProducts();
    }
  }

  final Future<Database> database =
      getDatabasesPath().then((String path) async {
    return await openDatabase(join(path, 'DataBase.db'));
  });

  Future<Database> _openTableOrders() async {
    return openDatabase(join(await getDatabasesPath(), 'DataBase.db'),
        onCreate: (db, version) {
      return db.execute('''
          CREATE TABLE $tablePedidos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fechaPedido TEXT,
            cliente TEXT FOREIGN KEY,
            detallePedido TEXT,
            cantidad INTEGER
            )
            ''');
    }, version: 1);
  }

  Future<Database> _openTableProducts() async {
    return openDatabase(join(await getDatabasesPath(), 'Database.db'),
        onCreate: (db, version) {
      return db.execute('''
          CREATE TABLE $tableProductos (
            Codigo TEXT,
            Nombre TEXT,
            Precio REAL,
            Archivo TEXT,
            Cantidad REAL
            )
            ''');
    }, version: 3);
  }

  final String tablePedidos = 'pedidos';
  final String tableProductos = 'productoscatalogo';

  // Acciones de la tabla productos
  Future<int> insertCart(CartItem cart) async {
    Database db = await database;
    return db.insert(tableProductos, cart.toMap());
  }

  // Acciones de la tabla pedidos
  Future<int> insertOrder(Order order) async {
    Database db = await database;
    return db.insert(tablePedidos, order.toMap());
  }

  Future<int> deleteOrder(Order order) async {
    Database db = await database;
    return db.delete(tablePedidos, where: 'id = ?', whereArgs: [order.id]);
  }

  Future<int> updateOrder(Order order) async {
    Database db = await database;
    return db.update(tablePedidos, order.toMap(),
        where: 'id = ?', whereArgs: [order.id]);
  }

  Future<List<Order>> orders() async {
    Database db = await database;
    final List<Map<String, dynamic>> ordersMap = await db.query(tablePedidos);
    return List.generate(
      ordersMap.length,
      (index) => Order(
        id: ordersMap[index]['id'],
        fechaPedido: ordersMap[index]['fechaPedido'],
        cliente: ordersMap[index]['cliente'],
        detallePedido: ordersMap[index]['detallePedidos'],
        cantidad: ordersMap[index]['cantidad'],
      ),
    );
  }
}
