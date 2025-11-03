import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import '/screens/login_or_register_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Pengguna sudah login
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          // Pengguna belum login
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}