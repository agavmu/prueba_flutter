import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/models.dart';

class DbHelper {
  static Future initDB() async {
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

      _openTableOrders();
      _openTableProducts();
    }
    return await openDatabase(path);
  }

  final Future<Database> database =
      getDatabasesPath().then((String path) async {
    return await openDatabase(join(path, 'DataBase.db'));
  });

  static Future<Database> _openTableOrders() async {
    return openDatabase(join(await getDatabasesPath(), 'DataBase.db'),
        onCreate: (db, version) {
      return db.execute('''
          CREATE TABLE $tablaPedidos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fechaPedido TEXT,
            cliente TEXT FOREIGN KEY,
            detallePedido TEXT,
            total INTEGER
            )
            ''');
    }, version: 2);
  }

  static Future<Database> _openTableProducts() async {
    return openDatabase(join(await getDatabasesPath(), 'DataBase.db'),
        onCreate: (db, version) {
      return db.execute('''
          CREATE TABLE $tablaProductos (
            idPedido Text FOREIGN KEY,
            Codigo TEXT,
            Nombre TEXT,
            Precio REAL,
            Cantidad REAL
            )
            ''');
    }, version: 4);
  }

  static const String tablaPedidos = 'pedidos';
  static const String tablaProductos = 'productoscatalogo';

  static Future<bool> validLogin(User user) async {
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

  static Future<List<Seller>> getSeller() async {
    Database database = await initDB();

    final List<Map<String, dynamic>> sellersMap =
        await database.query("Vendedor");

    return List.generate(
      sellersMap.length,
      (i) => Seller(
        code: sellersMap[i]['codigo'],
        name: sellersMap[i]['nombre'],
        portafolio: sellersMap[i]['portafolio'],
      ),
    );
  }

  static Future<Seller?> getSellerInfo(User user) async {
    Database database = await initDB();

    final List<Map<String, dynamic>> sellers = await database.query('Vendedor');

    for (var tmpSeller in sellers) {
      if (tmpSeller['codigo'] == user.code) {
        return Seller(
            code: tmpSeller['codigo'],
            name: tmpSeller['nombre'],
            portafolio: tmpSeller['portafolio']);
      }
    }
    return null;
  }

  static Future<Client?> getClientInfo() async {
    Database database = await initDB();

    final List<Map<String, dynamic>> clients = await database.query('Clientes');

    for (var tmpClient in clients) {
      return Client(
        code: tmpClient['Vendedor1'],
        name: tmpClient['Nombre'],
      );
    }
    return null;
  }

  static Future<List<Client>> getClients() async {
    Database database = await initDB();

    final List<Map<String, dynamic>> clientsMap =
        await database.query("Clientes");

    return List.generate(
      clientsMap.length,
      (i) => Client(
        name: clientsMap[i]['Nombre'],
        code: clientsMap[i]['Vendedor1'],
        address: clientsMap[i]['Barrio'],
      ),
    );
  }

  static Future<List<ProductsCatalog>> getProducts() async {
    Database database = await initDB();

    final List<Map<String, dynamic>> productsMap =
        await database.query("ProductosCatalogo");

    return List.generate(
      productsMap.length,
      (i) => ProductsCatalog(
        name: productsMap[i]['Nombre'],
        price: productsMap[i]['Precio'],
        archive: productsMap[i]['Archive'],
      ),
    );
  }

  // obtener los clientes por medio de el vendedor
  // static Future<List<Client>> getClientsBySeller(Seller seller) async {
  //   Database database = await initDB();

  //   final List<Map<String, dynamic>> clients = await database
  //       .query('Clientes', where: 'Vendedor1 = ?', whereArgs: [seller.code]);

  //   return List.generate(clients.length, (i) {
  //     return Client(
  //       code: clients[i]['Vendedor1'],
  //       name: clients[i]['Nombre'],
  //       address: clients[i]['Barrio'],
  //     );
  //   });
  // }
}
