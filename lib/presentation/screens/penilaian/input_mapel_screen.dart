// Lokasi: lib/presentation/screens/penilaian/input_mapel_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/penilaian_mapel.dart';
import '../../../domain/entities/santri.dart';
import '../../providers/user_providers.dart';

class InputMapelScreen extends ConsumerStatefulWidget {
  final Santri santri;
  const InputMapelScreen({super.key, required this.santri});

  @override
  ConsumerState<InputMapelScreen> createState() => _InputMapelScreenState();
}

class _InputMapelScreenState extends ConsumerState<InputMapelScreen> {
  // Pilihan Mata Pelajaran
  final List<String> _mapelOptions = ['Fiqh', 'Bahasa Arab', 'Sejarah Islam', 'Hadits'];
  String? _selectedMapel;

  final _formatifController = TextEditingController();
  final _sumatifController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _formatifController.dispose();
    _sumatifController.dispose();
    super.dispose();
  }

  Future<void> _saveNilai() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMapel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih mata pelajaran dulu'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final penilaian = PenilaianMapel(
        id: '',
        santriId: widget.santri.id,
        mataPelajaran: _selectedMapel!,
        nilaiFormatif: int.parse(_formatifController.text),
        nilaiSumatif: int.parse(_sumatifController.text),
        tanggal: _selectedDate,
      );

      // Panggil 'otak' penilaian untuk menyimpan Mapel
      await ref.read(penilaianRepositoryProvider).addMapel(penilaian);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nilai Mapel berhasil disimpan'), backgroundColor: Colors.green),
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
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.teal),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Input Nilai Mapel', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Info
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.teal.shade100,
                    child: Text(widget.santri.nama[0], style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.santri.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Input nilai akademik", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),

              // Container Form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  children: [
                    // Date Picker
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.teal, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                              style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dropdown Mata Pelajaran
                    DropdownButtonFormField<String>(
                      value: _selectedMapel,
                      decoration: InputDecoration(
                        labelText: 'Mata Pelajaran',
                        labelStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(Icons.book_rounded, color: Colors.teal),
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.teal, width: 2)),
                      ),
                      items: _mapelOptions.map((String mapel) {
                        return DropdownMenuItem<String>(
                          value: mapel,
                          child: Text(mapel),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedMapel = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Input Nilai (Row)
                    Row(
                      children: [
                        Expanded(
                          child: _buildModernField(
                            controller: _formatifController,
                            label: 'Nilai Formatif',
                            icon: Icons.assignment_outlined,
                            isNumber: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildModernField(
                            controller: _sumatifController,
                            label: 'Nilai Sumatif',
                            icon: Icons.article_outlined,
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
                  onPressed: _isLoading ? null : _saveNilai,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.teal.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'SIMPAN NILAI',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500),
        prefixIcon: Icon(icon, color: Colors.teal.shade300),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.teal, width: 2)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Wajib diisi';
        if (isNumber && int.tryParse(value) == null) return 'Harus angka';
        // Validasi rentang nilai 0-100
        if (isNumber) {
          int? score = int.tryParse(value);
          if (score != null && (score < 0 || score > 100)) return '0-100';
        }
        return null;
      },
    );
  }
}