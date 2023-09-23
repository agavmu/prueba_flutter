import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/models.dart';

class DbHelper {
  Future initDB() async {
    sqfliteFfiInit();
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, "DataBase.db");
    //nombre de la base de datos a migrar
    final exist = await databaseExists(path);
    if (exist) {
    } else {
      //Creando una copia de la base de datos desde Assets
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "DataBase.db"));
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
          CREATE TABLE $tablaPedidos (
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
    return openDatabase(join(await getDatabasesPath(), 'DataBase.db'),
        onCreate: (db, version) {
      return db.execute('''
          CREATE TABLE $tablaProductos (
            Codigo TEXT,
            Nombre TEXT,
            Precio REAL,
            Archivo TEXT,
            Cantidad REAL
            )
            ''');
    }, version: 3);
  }

  final String tablaPedidos = 'pedidos';
  final String tablaProductos = 'productoscatalogo';

  Future<bool> validLogin(User user) async {
    Database database = await initDB();

    final List<Map<String, dynamic>> users = await database.query('Usuario');

    for (var tmpUser in users) {
      if (tmpUser['usuario'] == user.code &&
          tmpUser['password'] == user.password) {
        return true;
      }
    }
    return false;
  }

  Future<List<Seller>> getSeller() async {
    Database database = await initDB();

    final List<Map<String, dynamic>> sellersMap =
        await database.query("Vendedor");

    return List.generate(
      sellersMap.length,
      (i) => Seller(
        usuario: sellersMap[i]['usuario'],
        empresa: sellersMap[i]['empresa'],
        portafolio: sellersMap[i]['portafolio'],
      ),
    );
  }
}
