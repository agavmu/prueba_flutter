import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prueba/db/db_helper.dart';
import 'package:prueba/models/models.dart';
import 'package:prueba/screens/screens.dart';

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
            text: Text(
          'Bienvenido ${getSeller!.name}',
          style: const TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
        )),
        body: ListSeller(seller: getSeller));
  }
}

class ListSeller extends StatefulWidget {
  const ListSeller({
    super.key,
    this.seller,
  });

  final Seller? seller;

  @override
  State<ListSeller> createState() => _ListSellerState();
}

class _ListSellerState extends State<ListSeller> {
  Future<void> goProducts(Client client) async {
    if (mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                ProductsScreen(getClient: client),
          ));
    }
  }

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
                      onTap: () async {
                        if (cliente.code!.isNotEmpty) {
                          goProducts(cliente);
                        } else {
                          Fluttertoast.showToast(
                              msg: "No existe el cliente",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
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
