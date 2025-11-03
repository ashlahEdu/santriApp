// Lokasi: lib/screens/signin_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  final void Function()? onTap; // Menerima fungsi untuk beralih halaman
  const SignInScreen({super.key, required this.onTap});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Terjadi error saat login'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const Text('Sign In', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const Text('Please login to continue', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
                    const SizedBox(height: 30),
                    _buildTextField(hint: 'Enter your email', icon: Icons.email, controller: _emailController),
                    const SizedBox(height: 16),
                    _buildPasswordField(controller: _passwordController),
                    const SizedBox(height: 16),
                    _buildExtraFeatures(),
                    const SizedBox(height: 24),
                    _buildSignInButton(),
                    const SizedBox(height: 20),
                    _buildSocialLogin(),
                    const SizedBox(height: 20),
                    _buildSignUpLink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.teal)),
      ),
    );
  }

  Widget _buildPasswordField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.teal)),
      ),
    );
  }

  Widget _buildExtraFeatures() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
            const Text('Remember me'),
          ],
        ),
        GestureDetector(
          onTap: () {},
          child: const Text('Forgot password?', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget _buildSignInButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.teal, Colors.teal.shade300], begin: Alignment.centerLeft, end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
            : const Text('SIGN IN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        const Text('or Sign in via', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 20, backgroundColor: Colors.grey.shade200),
            const SizedBox(width: 16),
            CircleAvatar(radius: 20, backgroundColor: Colors.grey.shade200),
            const SizedBox(width: 16),
            CircleAvatar(radius: 20, backgroundColor: Colors.grey.shade200),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        GestureDetector(
          onTap: widget.onTap, // Memanggil fungsi untuk beralih halaman
          child: const Text('Sign Up', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}