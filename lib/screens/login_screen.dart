import 'package:flutter/material.dart';

import '../widgets/custom_appbar.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppbar(
        title: 'Login',
      ),
      body: Container(
        height: mediaHeight,
        width: mediaWidth,
        decoration: BoxDecoration(color: Colors.blueAccent.shade200),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: mediaHeight * 0.26, horizontal: mediaWidth * 0.2),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usuarioController,
                      style: const TextStyle(color: Colors.white),
                      autocorrect: false,
                      decoration: const InputDecoration(
                          prefixIconColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.white),
                          hoverColor: Colors.white,
                          labelText: 'Usuario',
                          prefixIcon:
                              Icon(Icons.supervised_user_circle_outlined)),
                      validator: (value) {
                        return (value != null && value.length >= 4) ? null : '';
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      obscuringCharacter: '*',
                      style: const TextStyle(color: Colors.white),
                      autocorrect: false,
                      decoration: const InputDecoration(
                          prefixIconColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.white),
                          hoverColor: Colors.white,
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline_rounded)),
                      validator: (value) {
                        return (value != null && value.length >= 4) ? null : '';
                      },
                    ),
                  ],
                ),
              ),
              FloatingActionButton(
                  child: const Icon(Icons.send_rounded), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
