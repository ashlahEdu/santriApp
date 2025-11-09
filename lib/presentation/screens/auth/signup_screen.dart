// Lokasi: lib/presentation/screens/auth/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Impor Riverpod
import '../../providers/auth_providers.dart'; // 2. Impor provider Auth
import '../../providers/user_providers.dart'; // 3. Impor provider User (Firestore)

// 4. Ganti menjadi ConsumerStatefulWidget
class SignUpScreen extends ConsumerStatefulWidget {
  final void Function()? onTap; // Menerima fungsi untuk beralih halaman
  const SignUpScreen({super.key, required this.onTap});

  @override
  // 5. Ganti menjadi ConsumerState
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

// 6. Ganti menjadi ConsumerState
class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  // Controller dan state UI lokal tetap di sini
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  // Fungsi untuk memproses pendaftaran
  Future<void> _signUp() async {
    // Validasi Form (sesuai permintaan studi kasus) [cite: 169]
    if (_emailController.text.isEmpty ||
        _mobileNumberController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Semua kolom wajib diisi!"),
          backgroundColor: Colors.red));
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password dan Konfirmasi Password tidak sama!"),
          backgroundColor: Colors.red));
      return;
    }
    // (Validasi terms & conditions bisa ditambahkan di sini jika perlu)

    setState(() { _isLoading = true; });

    try {
      // 7. Panggil 'otak' Auth (Riverpod)
      final userCredential =
          await ref.read(authRepositoryProvider).signUpWithEmailAndPassword(
                _emailController.text.trim(),
                _passwordController.text.trim(),
              );

      // 8. Jika daftar berhasil, panggil 'otak' User (Riverpod)
      if (userCredential.user != null) {
        await ref.read(userRepositoryProvider).saveUserData(
              userCredential.user!.uid,
              _emailController.text.trim(),
              _mobileNumberController.text.trim(),
            );
      }
      // AuthGate akan menangani navigasi secara otomatis

    } catch (e) {
      // Penanganan Kesalahan (sesuai permintaan studi kasus) [cite: 169]
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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileNumberController.dispose();
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
                    const Text('Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    const Text('Register yourself',
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
                    // TextField Mobile Number [cite: 6]
                    TextField(
                      controller: _mobileNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Enter your Mobile number',
                        prefixIcon: Icon(Icons.phone, color: Colors.grey),
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
                    // TextField Confirm Password
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
                        prefixIcon: Icon(Icons.lock, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
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
                    // Terms and Conditions
                    Row(
                      children: [
                        Checkbox(
                            value: _agreeToTerms,
                            onChanged: (value) =>
                                setState(() => _agreeToTerms = value!)),
                        const Text('I agree with Terms and Conditions'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Tombol Sign Up
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.teal, Colors.teal.shade300],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 3)
                            : const Text('SIGN UP',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Link ke Sign In
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: widget.onTap, // Gunakan fungsi dari widget
                          child: const Text('Sign In',
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