// Lokasi: lib/services/login_or_register_page.dart

import 'package:flutter/material.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // Awalnya, tampilkan halaman login
  bool showLoginPage = true;

  // Method untuk beralih antara halaman login dan register
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SignInScreen(onTap: togglePages);
    } else {
      return SignUpScreen(onTap: togglePages);
    }
  }
}