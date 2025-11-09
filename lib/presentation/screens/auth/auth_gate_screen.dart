// Lokasi: lib/presentation/screens/auth/auth_gate_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_providers.dart';
import 'login_or_register_screen.dart';
import '../main/home_screen.dart';

// 1. Ubah menjadi ConsumerWidget agar bisa "mendengar" provider
class AuthGateScreen extends ConsumerWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. "Dengarkan" authStateChangesProvider
    final authState = ref.watch(authStateChangesProvider);

    // 3. Gunakan .when() untuk menangani semua status (data, loading, error)
    return authState.when(
      data: (user) {
        // Jika ada data (user login), tampilkan HomeScreen
        if (user != null) {
          return const HomeScreen();
        }
        // Jika data null (user logout), tampilkan halaman login/register
        else {
          return const LoginOrRegisterScreen();
        }
      },
      loading: () {
        // Tampilkan loading spinner saat Firebase sedang memeriksa status login
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, stackTrace) {
        // Tampilkan error jika terjadi masalah
        return Scaffold(
          body: Center(
            child: Text('Terjadi error: $error'),
          ),
        );
      },
    );
  }
}