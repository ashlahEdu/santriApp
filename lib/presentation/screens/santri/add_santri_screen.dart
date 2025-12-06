// Lokasi: lib/presentation/screens/santri/add_santri_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/domain/entities/santri.dart';
import '/presentation/providers/user_providers.dart';

class AddSantriScreen extends ConsumerStatefulWidget {
  const AddSantriScreen({super.key});

  @override
  ConsumerState<AddSantriScreen> createState() => _AddSantriScreenState();
}

class _AddSantriScreenState extends ConsumerState<AddSantriScreen> {
  final _namaController = TextEditingController();
  final _nisController = TextEditingController();
  final _kamarController = TextEditingController();
  final _angkatanController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nisController.dispose();
    _kamarController.dispose();
    _angkatanController.dispose();
    super.dispose();
  }

  Future<void> _saveSantri() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newSantri = Santri(
        id: '',
        nama: _namaController.text,
        nis: _nisController.text,
        kamar: _kamarController.text,
        angkatan: int.parse(_angkatanController.text),
      );

      await ref.read(santriRepositoryProvider).createSantri(newSantri);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Santri berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Background Abu-abu Modern
      appBar: AppBar(
        title: const Text(
          'Tambah Santri',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal, // AppBar Teal (Konsisten)
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Teks Kecil
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  "INFORMASI DASAR",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // Container Form Putih
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildModernField(
                      controller: _namaController,
                      label: 'Nama Lengkap',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    _buildModernField(
                      controller: _nisController,
                      label: 'Nomor Induk (NIS)',
                      icon: Icons.badge_outlined,
                      isNumber: true,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildModernField(
                            controller: _kamarController,
                            label: 'Kamar',
                            icon: Icons.bed_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildModernField(
                            controller: _angkatanController,
                            label: 'Angkatan',
                            icon: Icons.calendar_today_outlined,
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Tombol Simpan
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveSantri,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.teal.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'SIMPAN DATA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Input Field
  Widget _buildModernField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.teal.shade300),
        filled: true,
        fillColor: const Color(
          0xFFF9FAFB,
        ), // Sedikit lebih terang dari background utama
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '$label tidak boleh kosong';
        if (isNumber && int.tryParse(value) == null) return 'Harus angka';
        return null;
      },
    );
  }
}
