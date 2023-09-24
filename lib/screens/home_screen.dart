import 'package:flutter/material.dart';
import 'package:prueba/db/db_helper.dart';
import 'package:prueba/models/models.dart';

import 'package:prueba/widgets/custom_appbar_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.getSeller,
  });

  final Seller? getSeller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppbarHome(
            text: Column(
          children: [
            Text(
              'Bienvenido ${getSeller!.name}',
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        )),
        body: Builder());
  }
}

class Builder extends StatelessWidget {
  const Builder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Client>>(
        future: DbHelper.getClients(),
        builder: (context, snapshot) {
          final List<Client>? clientes = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              return ListView.builder(
                itemCount: clientes!.length,
                itemBuilder: (BuildContext context, int i) {
                  final cliente = clientes[i];
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          Text(
                            cliente.name,
                            style: const TextStyle(fontSize: 16.5),
                          ),
                          Text(
                            cliente.address.toString(),
                            style: const TextStyle(fontSize: 16.5),
                          ),
                          const Divider()
                        ],
                      ),
                    ),
                  );
                },
              );
          }
          return const Text('No se encontraron los clientes');
        });
  }
}
