// Lokasi: lib/presentation/screens/auth/signin_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Impor Riverpod
import '../../providers/auth_providers.dart'; // 2. Impor provider kita

// 3. Ganti menjadi ConsumerStatefulWidget
class SignInScreen extends ConsumerStatefulWidget {
  final void Function()? onTap; // Menerima fungsi untuk beralih halaman
  const SignInScreen({super.key, required this.onTap});

  @override
  // 4. Ganti menjadi ConsumerState
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

// 5. Ganti menjadi ConsumerState
class _SignInScreenState extends ConsumerState<SignInScreen> {
  // Controller dan state UI lokal tetap di sini
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  // Fungsi untuk memproses login
  Future<void> _signIn() async {
    setState(() { _isLoading = true; });

    try {
      // 6. Panggil logika dari 'otak' (Riverpod provider)
      // Kita tidak lagi memanggil FirebaseAuth.instance di sini
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      // AuthGate akan menangani navigasi secara otomatis
      
    } catch (e) {
      // Tangani error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()), // Tampilkan error
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  void dispose() {
    // Jangan lupa bersihkan controller
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        padding: const EdgeInsets.only(top: 60),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo (pastikan path aset Anda benar)
              Image.asset('assets/images/UIN2-removebg-preview.png', height: 80),
              const SizedBox(height: 100),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Sign In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    const Text('Please login to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                    const SizedBox(height: 30),
                    // TextField Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email, color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.teal)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // TextField Password
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        prefixIcon: Icon(Icons.lock, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.teal)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Remember me & Forgot
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Checkbox(
                              value: _rememberMe,
                              onChanged: (value) =>
                                  setState(() => _rememberMe = value!)),
                          const Text('Remember me'),
                        ]),
                        GestureDetector(
                            onTap: () {},
                            child: const Text('Forgot password?',
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold)))
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Tombol Sign In
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.teal, Colors.teal.shade300],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 3)
                            : const Text('SIGN IN',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Social Login (Placeholder)
                    // ...
                    const SizedBox(height: 20),
                    // Link ke Sign Up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          // 7. Gunakan fungsi onTap dari widget
                          onTap: widget.onTap,
                          child: const Text('Sign Up',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}