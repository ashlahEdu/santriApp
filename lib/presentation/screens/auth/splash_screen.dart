// Lokasi: lib/screens/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import './auth_gate_screen.dart'; // Ganti import ke auth_gate.dart

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Arahkan ke AuthGateScreen baru kita
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthGateScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/UIN2-removebg-preview.png',
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'UIN App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
