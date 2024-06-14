import 'package:dars_55/view_models/users_viewmodel.dart';
import 'package:dars_55/views/screens/home_screen.dart';
import 'package:dars_55/views/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final usersViewModel = UsersViewmodel();

  bool isLogged = false;

  @override
  void initState() {
    super.initState();

    usersViewModel.checkLogin().then((value) {
      setState(() {
        isLogged = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 246, 77, 65),
          foregroundColor: Colors.white,
        ),
      ),
      home: isLogged ? const HomeScreen() : const LoginScreen(),
    );
  }
}
