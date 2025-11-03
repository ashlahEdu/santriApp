// Lokasi: lib/screens/login_screen.dart

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true; // State untuk toggle visibility password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih sesuai desain
      body: SingleChildScrollView(
        // Agar bisa discroll jika keyboard muncul
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nice to see you again', // Teks pembuka
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 60), // Spasi yang cukup lebar
            // Input Email
            TextField(
              decoration: InputDecoration(
                hintText: 'Email or phone number', // Placeholder
                fillColor: Colors.grey[200], // Warna background input
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Tanpa border outline
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Input Password
            TextField(
              obscureText: _obscurePassword, // Kontrol visibilitas password
              decoration: InputDecoration(
                hintText: 'Enter password',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                suffixIcon: IconButton(
                  // Icon mata untuk toggle password
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bagian Remember Me & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Switch(
                      // Menggunakan Switch sebagai pengganti Toggle
                      value: false, // Akan dikontrol nanti
                      onChanged: (bool value) {
                        // Logika Remember Me akan ditambahkan di sini
                      },
                      activeColor: Colors.blueAccent,
                    ),
                    const Text(
                      'Remember me',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Logika Forgot password
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tombol Sign in
            ElevatedButton(
              onPressed: () {
                // Logika Sign In akan ditambahkan di sini
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Warna tombol biru
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Sign in',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Divider "Or sign in with Google"
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[400])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Or sign in with',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[400])),
              ],
            ),
            const SizedBox(height: 20),

            // Tombol Google Sign In (dengan icon Google)
            ElevatedButton.icon(
              onPressed: () {
                // Logika Google Sign In
              },
              icon: Image.network(
                // Menggunakan Image.network untuk icon Google
                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                height: 24,
                width: 24,
              ),
              label: const Text(
                'Google',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!), // Border abu-abu
                ),
                elevation: 0, // Tanpa shadow
              ),
            ),
            const SizedBox(height: 40),

            // Bagian "Don't have an account?"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dont have an account?',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                TextButton(
                  onPressed: () {
                    // Logika navigasi ke Register Screen
                  },
                  child: const Text(
                    'Sign up now',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Logo UI Unicorn (Placeholder) dan Copyright
            Center(
              child: Column(
                children: [
                  // Ini placeholder. Di produksi, gunakan AssetImage
                  Image.network(
                    'https://images.unsplash.com/photo-1618005182384-a83a8077ef88?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    height: 80,
                    width: 80,
                  ),
                  const Text(
                    'UI Unicorn',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('@uiunicorn', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 10),
                  Text(
                    '© Perfect Login 2021',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
