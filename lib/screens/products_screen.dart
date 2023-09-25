import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    List<ProductsCatalog> carrito = [];
    return Scaffold(
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
      body: GetProducts(
        lista: carrito,
      ),
      persistentFooterButtons: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.09,
          child: MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            onPressed: () async {
              await DbHelper.saveProducts(carrito, getClient!);

              String pedido = '';
              for (var item in carrito) {
                pedido += '\n${(item.quantity).toString()} x ${item.name}';
              }

              Fluttertoast.showToast(
                  msg: "Su pedido es: ${pedido}",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);

              carrito.clear();
            },
            child: const Text(
              'REALIZAR PEDIDO',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}

class GetProducts extends StatelessWidget {
  const GetProducts({
    super.key,
    required this.lista,
  });

  final List<ProductsCatalog> lista;

  @override
  Widget build(BuildContext context) {
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
                          const Divider(),
                          Text(
                            producto.name,
                            style: const TextStyle(fontSize: 16.5),
                          ),
                          Text(
                            '\$ ${producto.price.toString()}',
                            style: const TextStyle(fontSize: 16.5),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    BtnAddMinus(
                      producto: producto,
                      lista: lista,
                    ),
                  ],
                );
              },
            );
        }
        return const Text('No se encontraron productos');
      },
    );
  }
}

class BtnAddMinus extends StatefulWidget {
  const BtnAddMinus({super.key, required this.lista, required this.producto});

  final List<ProductsCatalog> lista;
  final ProductsCatalog producto;

  @override
  State<BtnAddMinus> createState() => _BtnAddMinusState();
}

class _BtnAddMinusState extends State<BtnAddMinus> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
          onPressed: () {
            var position = -1;
            for (var i = 0; i < widget.lista.length; i++) {
              if (widget.producto.code == widget.lista[i].code) {
                position = i;
                break;
              }
            }
            // Validar si el producto ya esta
            if (position == -1) {
              print('de nevo');
              widget.producto.quantity = 1;
              widget.lista.add(widget.producto);
            } else {
              print('esta ma');
              widget.lista[position].quantity++;
            }

            print(widget.lista.toString());
          },
          icon: const Icon(
            Icons.exposure_plus_1,
            color: Colors.white,
          ),
        ),
        IconButton(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
          onPressed: () {
            var position = -1;
            for (var i = 0; i < widget.lista.length; i++) {
              if (widget.producto.code == widget.lista[i].code) {
                position = i;
                break;
              }
            }
            // Validar si el producto ya esta
            if (position != -1) {
              widget.lista[position].quantity--;
              if (widget.lista[position].quantity == 0) {
                widget.lista.remove(widget.producto);
              }
            }

            print(widget.lista.toString());
          },
          icon: const Icon(
            Icons.exposure_minus_1,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
