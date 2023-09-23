class User {
  final String code;
  final String password;
  final String? empresa;

  User({required this.code, required this.password, this.empresa});

  Map<String, dynamic> toMap() {
    return {'usuario': code, 'password': password, 'empresa': empresa};
  }
}
