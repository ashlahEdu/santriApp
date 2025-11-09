// Lokasi: lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Impor Riverpod
import 'firebase_options.dart';
import 'presentation/screens/auth/splash_screen.dart'; // Path baru ke Splash Screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(
    // Bungkus seluruh aplikasi dengan ProviderScope
    // Ini agar state Riverpod bisa diakses di mana saja
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-Penilaian Santri',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Mulai dari Splash Screen (di lokasi baru)
    );
  }
}