class User {
  final String id;
  String email;
  String password;
  String token;
  DateTime expiryDate;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.token,
    required this.expiryDate,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      token: map['token'],
      expiryDate: DateTime.parse(map['expiryDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "password": password,
      "token": token,
      "expiryDate": expiryDate.toString(),
    };
  }
}
