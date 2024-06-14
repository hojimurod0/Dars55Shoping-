import 'dart:convert';


import 'package:dars_55/models/user.dart';
import 'package:dars_55/services/auth_http_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersViewmodel {
  User? user;
  final authHttpServices = AuthHttpServices();

  Future<void> register(String email, String password) async {
    try {
      final response = await authHttpServices.register(email, password);
      user = User(
        id: response['localId'],
        email: email,
        password: password,
        token: response['idToken'],
        expiryDate: DateTime.now().add(
          Duration(
            seconds: int.parse(response['expiresIn']),
          ),
        ),
      );

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString(
        "userData",
        jsonEncode(user!.toMap()),
      );
    } catch (e) {
      String message = e.toString();
      if (message.contains("EMAIL_EXISTS")) {
        message = "Bu email mavjud";
      } else if (message.contains("WEAK_PASSWORD")) {
        message = "Parol juda qisqa!";
      }

      throw (message);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await authHttpServices.login(email, password);
      user = User(
        id: response['localId'],
        email: email,
        password: password,
        token: response['idToken'],
        expiryDate: DateTime.now().add(
          Duration(
            seconds: int.parse(response['expiresIn']),
          ),
        ),
      );

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString(
        "userData",
        jsonEncode(user!.toMap()),
      );
    } catch (e) {
      String message = e.toString();
      if (message.contains("EMAIL_EXISTS")) {
        message = "Bu email mavjud";
      } else if (message.contains("WEAK_PASSWORD")) {
        message = "Parol juda qisqa!";
      }

      throw (message);
    }
  }

  Future<bool> checkLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString("userData");

    if (userData == null) {
      return false;
    }
    user = User.fromMap(jsonDecode(userData));

    return DateTime.now().isBefore(user!.expiryDate);
  }
}
