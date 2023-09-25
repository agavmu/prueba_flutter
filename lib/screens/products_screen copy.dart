import 'package:flutter/material.dart';
import 'package:prueba/db/db_helper.dart';
import 'package:prueba/models/models.dart';

import 'package:prueba/widgets/custom_appbar_home.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({
    super.key,
    required this.getClient,
  });

  final Client? getClient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppbarHome(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.chevron_left_outlined)),
            text: Text(
              getClient!.name,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
            )),
        body: const GetProducts());
  }
}

class GetProducts extends StatelessWidget {
  const GetProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cantidad = 0;
    return FutureBuilder<List<ProductsCatalog>>(
        future: DbHelper.getProducts(),
        builder: (context, snapshot) {
          final List<ProductsCatalog>? productos = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              return ListView.builder(
                itemCount: productos!.length,
                itemBuilder: (BuildContext context, int i) {
                  final producto = productos[i];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                            Text(
                              producto.name,
                              style: const TextStyle(fontSize: 16.5),
                            ),
                            Text(
                              '\$ ${producto.price.toString()}',
                              style: const TextStyle(fontSize: 16.5),
                            ),
                            const Divider()
                          ],
                        ),
                      ),
                      BtnAddMinus(cantidad: cantidad),
                    ],
                  );
                },
              );
          }
          return const Text('No se encontraron productos');
        });
  }
}

class BtnAddMinus extends StatefulWidget {
  const BtnAddMinus({
    super.key,
    required this.cantidad,
  });

  final int cantidad;

  @override
  State<BtnAddMinus> createState() => _BtnAddMinusState();
}

class _BtnAddMinusState extends State<BtnAddMinus> {
  @override
  Widget build(BuildContext context) {
    bool buttonActive = true;
    int cantidad2 = widget.cantidad;
    return Row(
      children: [
        IconButton(
          padding: const EdgeInsets.only(bottom: 15),
          onPressed: () {
            cantidad2++;
            print(cantidad2);
          },
          icon: const Icon(
            Icons.exposure_plus_1,
            color: Colors.white,
          ),
        ),
        IconButton(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          onPressed: cantidad2 == 0
              ? () {
                  setState(() {});
                  cantidad2--;
                  buttonActive = false;
                  print(cantidad2);
                }
              : null,
          icon: const Icon(
            Icons.exposure_minus_1,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
