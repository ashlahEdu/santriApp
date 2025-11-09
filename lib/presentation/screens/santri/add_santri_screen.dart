// Lokasi: lib/presentation/screens/santri/add_santri_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/santri.dart';
import '../../providers/user_providers.dart';

// 1. Gunakan ConsumerStatefulWidget untuk mengelola form
class AddSantriScreen extends ConsumerStatefulWidget {
  const AddSantriScreen({super.key});

  @override
  ConsumerState<AddSantriScreen> createState() => _AddSantriScreenState();
}

class _AddSantriScreenState extends ConsumerState<AddSantriScreen> {
  // 2. Buat controller untuk setiap input
  final _namaController = TextEditingController();
  final _nisController = TextEditingController();
  final _kamarController = TextEditingController();
  final _angkatanController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nisController.dispose();
    _kamarController.dispose();
    _angkatanController.dispose();
    super.dispose();
  }

  // 3. Fungsi untuk menyimpan data
  Future<void> _saveSantri() async {
    // Validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() { _isLoading = true; });

    try {
      // Buat objek Santri baru dari input form
      final newSantri = Santri(
        id: '', // ID akan di-generate oleh Firestore, jadi kita biarkan kosong
        nama: _namaController.text,
        nis: _nisController.text,
        kamar: _kamarController.text,
        angkatan: int.parse(_angkatanController.text),
      );

      // 4. Panggil 'otak' (Riverpod provider) untuk membuat santri
      await ref.read(santriRepositoryProvider).createSantri(newSantri);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Santri berhasil ditambahkan'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop(); // Kembali ke halaman daftar
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Santri Baru'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        // 5. Gunakan Form widget
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) => (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nisController,
                decoration: const InputDecoration(labelText: 'Nomor Induk Santri (NIS)'),
                validator: (value) => (value == null || value.isEmpty) ? 'NIS tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kamarController,
                decoration: const InputDecoration(labelText: 'Kamar / Asrama'),
                validator: (value) => (value == null || value.isEmpty) ? 'Kamar tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _angkatanController,
                decoration: const InputDecoration(labelText: 'Tahun Angkatan'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Angkatan tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Masukkan angka yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveSantri,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}