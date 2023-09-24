import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prueba/db/db_helper.dart';
import 'package:prueba/models/users.dart';
import 'package:prueba/screens/screens.dart';

import '../widgets/custom_appbar.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    usuarioController;
    passwordController;
    super.initState();
  }

  Future<void> login(User user) async {
    final successLogin = await DbHelper.validLogin(user);
    final seller = await DbHelper.getSellerInfo(user);

    if (mounted && successLogin) {
      Fluttertoast.showToast(
          msg: "Bienvenido",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(getSeller: seller),
        ),
      );
    } else {
      Fluttertoast.showToast(
          msg: "No existe el usuario",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          )),
      body: SingleChildScrollView(
        child: SizedBox(
          height: mediaHeight * 0.7,
          width: mediaWidth,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: mediaHeight * 0.2,
                      horizontal: mediaWidth * 0.2),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usuarioController,
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
                          return (value != null && value.length >= 4)
                              ? null
                              : '';
                        },
                      ),
                      TextFormField(
                        controller: passwordController,
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
                          return (value != null && value.isNotEmpty)
                              ? null
                              : '';
                        },
                      ),
                    ],
                  ),
                ),
                FloatingActionButton(
                  child: const Icon(Icons.send_rounded),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      login(User(
                          code: usuarioController.text,
                          password: passwordController.text));
                      //enviar al usuario a la pagina inicial
                    } else {
                      //detener y pedir nuevamente los datos
                      Fluttertoast.showToast(
                          msg: "Compruebe los datos",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
