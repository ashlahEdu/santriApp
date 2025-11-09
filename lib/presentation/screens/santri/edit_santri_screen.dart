// Lokasi: lib/presentation/screens/santri/edit_santri_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/santri.dart';
import '../../providers/user_providers.dart';

class EditSantriScreen extends ConsumerStatefulWidget {
  // 1. Terima data santri yang akan diedit
  final Santri santri;
  const EditSantriScreen({super.key, required this.santri});

  @override
  ConsumerState<EditSantriScreen> createState() => _EditSantriScreenState();
}

class _EditSantriScreenState extends ConsumerState<EditSantriScreen> {
  final _namaController = TextEditingController();
  final _nisController = TextEditingController();
  final _kamarController = TextEditingController();
  final _angkatanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 2. Isi form dengan data yang ada
    _namaController.text = widget.santri.nama;
    _nisController.text = widget.santri.nis;
    _kamarController.text = widget.santri.kamar;
    _angkatanController.text = widget.santri.angkatan.toString();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nisController.dispose();
    _kamarController.dispose();
    _angkatanController.dispose();
    super.dispose();
  }

  // 3. Fungsi untuk UPDATE Santri
  Future<void> _updateSantri() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; });

    try {
      final updatedSantri = Santri(
        id: widget.santri.id, // Gunakan ID yang lama
        nama: _namaController.text,
        nis: _nisController.text,
        kamar: _kamarController.text,
        angkatan: int.parse(_angkatanController.text),
      );

      // Panggil 'otak' (Riverpod) untuk meng-update
      await ref.read(santriRepositoryProvider).updateSantri(updatedSantri);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data santri berhasil diperbarui'), backgroundColor: Colors.green),
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
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  // 4. Fungsi untuk DELETE Santri
  Future<void> _deleteSantri() async {
    // Tampilkan dialog konfirmasi
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Santri'),
        content: Text('Anda yakin ingin menghapus data ${widget.santri.nama}?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    // Jika pengguna mengkonfirmasi "Hapus"
    if (shouldDelete == true) {
      setState(() { _isLoading = true; });
      try {
        // Panggil 'otak' (Riverpod) untuk menghapus
        await ref.read(santriRepositoryProvider).deleteSantri(widget.santri.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data santri berhasil dihapus'), backgroundColor: Colors.green),
          );
          Navigator.of(context).pop(); // Kembali ke halaman daftar
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
          setState(() { _isLoading = false; });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Santri'),
        backgroundColor: Colors.teal,
        actions: [
          // Tombol Hapus
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isLoading ? null : _deleteSantri,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(controller: _namaController, decoration: const InputDecoration(labelText: 'Nama Lengkap'), validator: (value) => (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _nisController, decoration: const InputDecoration(labelText: 'Nomor Induk Santri (NIS)'), validator: (value) => (value == null || value.isEmpty) ? 'NIS tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _kamarController, decoration: const InputDecoration(labelText: 'Kamar / Asrama'), validator: (value) => (value == null || value.isEmpty) ? 'Kamar tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _angkatanController, decoration: const InputDecoration(labelText: 'Tahun Angkatan'), keyboardType: TextInputType.number, validator: (value) { if (value == null || value.isEmpty) return 'Angkatan tidak boleh kosong'; if (int.tryParse(value) == null) return 'Masukkan angka yang valid'; return null; }),
              const SizedBox(height: 32),
              // Tombol Update
              ElevatedButton(
                onPressed: _isLoading ? null : _updateSantri,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Update Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}