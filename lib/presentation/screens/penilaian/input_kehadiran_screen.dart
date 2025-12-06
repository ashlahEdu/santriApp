// Lokasi: lib/presentation/screens/penilaian/input_kehadiran_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/kehadiran.dart';
import '../../../domain/entities/santri.dart';
import '../../providers/user_providers.dart';

class InputKehadiranScreen extends ConsumerStatefulWidget {
  final Santri santri;
  const InputKehadiranScreen({super.key, required this.santri});

  @override
  ConsumerState<InputKehadiranScreen> createState() => _InputKehadiranScreenState();
}

class _InputKehadiranScreenState extends ConsumerState<InputKehadiranScreen> {
  String _selectedStatus = 'H'; // Default Hadir
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  Future<void> _saveNilai() async {
    setState(() { _isLoading = true; });

    try {
      final kehadiran = Kehadiran(
        id: '',
        santriId: widget.santri.id,
        status: _selectedStatus,
        tanggal: _selectedDate,
      );

      await ref.read(penilaianRepositoryProvider).addKehadiran(kehadiran);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kehadiran berhasil disimpan'), backgroundColor: Colors.green),
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
        title: const Text('Input Kehadiran', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    Text("Absensi harian", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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

                  const Text("Status Kehadiran", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Pilihan Status (Grid 2x2)
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatusCard('H', 'Hadir', Colors.green),
                      _buildStatusCard('S', 'Sakit', Colors.orange),
                      _buildStatusCard('I', 'Izin', Colors.blue),
                      _buildStatusCard('A', 'Alpa', Colors.red),
                    ],
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
                    : const Text('SIMPAN ABSENSI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String code, String label, Color color) {
    bool isSelected = _selectedStatus == code;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedStatus = code;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Text(
                code,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}