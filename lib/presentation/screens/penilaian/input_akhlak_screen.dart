// Lokasi: lib/presentation/screens/penilaian/input_akhlak_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/penilaian_akhlak.dart';
import '../../../domain/entities/santri.dart';
import '../../providers/user_providers.dart';

class InputAkhlakScreen extends ConsumerStatefulWidget {
  final Santri santri;
  const InputAkhlakScreen({super.key, required this.santri});

  @override
  ConsumerState<InputAkhlakScreen> createState() => _InputAkhlakScreenState();
}

class _InputAkhlakScreenState extends ConsumerState<InputAkhlakScreen> {
  // Nilai default awal = 4 (Sangat Baik)
  int _disiplin = 4;
  int _adab = 4;
  int _kebersihan = 4;
  int _kerjasama = 4;
  
  final _catatanController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _saveNilai() async {
    setState(() { _isLoading = true; });

    try {
      final penilaian = PenilaianAkhlak(
        id: '',
        santriId: widget.santri.id,
        disiplin: _disiplin,
        adab: _adab,
        kebersihan: _kebersihan,
        kerjasama: _kerjasama,
        catatan: _catatanController.text,
        tanggal: _selectedDate,
      );

      await ref.read(penilaianRepositoryProvider).addAkhlak(penilaian);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Penilaian Akhlak berhasil disimpan'), backgroundColor: Colors.green),
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
        title: const Text('Input Akhlak', style: TextStyle(fontWeight: FontWeight.bold)),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Info Santri
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
                    Text("Penilaian karakter & adab", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),

            // Form Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tanggal
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.teal, size: 18),
                          const SizedBox(width: 12),
                          Text(
                            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // INPUT INDIKATOR (Slider Pilihan)
                  _buildRatingSelector("Kedisiplinan", _disiplin, (val) => setState(() => _disiplin = val)),
                  const Divider(height: 32),
                  _buildRatingSelector("Adab & Sopan Santun", _adab, (val) => setState(() => _adab = val)),
                  const Divider(height: 32),
                  _buildRatingSelector("Kebersihan", _kebersihan, (val) => setState(() => _kebersihan = val)),
                  const Divider(height: 32),
                  _buildRatingSelector("Kerjasama", _kerjasama, (val) => setState(() => _kerjasama = val)),
                  
                  const SizedBox(height: 24),
                  
                  // Catatan
                  Text("Catatan Tambahan", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _catatanController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Misal: Perlu ditingkatkan lagi...',
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

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
                    : const Text('SIMPAN PENILAIAN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Pilihan Nilai (1-4)
  Widget _buildRatingSelector(String label, int currentValue, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRatingChip(1, "Kurang", currentValue, onChanged, Colors.red),
            _buildRatingChip(2, "Cukup", currentValue, onChanged, Colors.orange),
            _buildRatingChip(3, "Baik", currentValue, onChanged, Colors.blue),
            _buildRatingChip(4, "Mumtaz", currentValue, onChanged, Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingChip(int value, String text, int groupValue, Function(int) onChanged, Color color) {
    bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: 2),
              boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))] : [],
            ),
            child: Center(
              child: Text(
                "$value",
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: isSelected ? Colors.white : Colors.grey.shade400
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11, 
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? color : Colors.grey.shade400
            ),
          )
        ],
      ),
    );
  }
}