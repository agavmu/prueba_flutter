class User {
  final String usuario;
  final String password;
  final String? empresa;

  User({required this.usuario, required this.password, this.empresa});

  Map<String, dynamic> toMap() {
    return {'usuario': usuario, 'password': password, 'empresa': empresa};
  }
}
