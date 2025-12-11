// Lokasi: lib/presentation/screens/auth/login_or_register_screen.dart
// Sistem Admin-Only: Tidak ada signup publik, hanya login

import 'package:flutter/material.dart';
import 'signin_screen.dart';

class LoginOrRegisterScreen extends StatelessWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hanya tampilkan halaman login, tidak ada toggle ke signup
    // Semua akun dibuat oleh Admin melalui dashboard
    return const SignInScreen(onTap: null);
  }
}