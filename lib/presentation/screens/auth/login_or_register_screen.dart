// Lokasi: lib/presentation/screens/auth/login_or_register_screen.dart

import 'package:flutter/material.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  // Awalnya, tampilkan halaman login
  bool showLoginPage = true;

  // Method untuk beralih halaman
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