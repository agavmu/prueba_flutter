import 'package:flutter/material.dart';
import 'package:prueba/widgets/custom_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppbar(
          title: 'Inicio',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue.shade200),
        ),
        body: ListView.builder(
          itemCount: 50,
          prototypeItem: const ListTile(
            title: Text('items.first'),
          ),
          itemBuilder: (context, index) {
            return const ListTile(
              title: Text('items[index]'),
            );
          },
        ));
  }
}
