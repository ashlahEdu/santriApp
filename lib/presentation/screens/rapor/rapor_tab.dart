// Lokasi: lib/presentation/screens/rapor/rapor_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/santri.dart';
import '../../providers/rapor_provider.dart'; // Pastikan path ini benar
import '../../../../core/utils/pdf_generator.dart'; // Sesuaikan path jika perlu

class RaporTab extends ConsumerWidget {
  final Santri santri;
  const RaporTab({super.key, required this.santri});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Ambil data rapor dari provider (otomatis hitung ulang jika ada update nilai)
    final raporAsync = ref.watch(raporProvider(santri.id));

    return raporAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (rapor) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 2. KARTU NILAI AKHIR (Hero Card dengan Gradient Modern)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF009688),
                      Color(0xFF004D40),
                    ], // Teal Gradient
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "NILAI AKHIR",
                      style: TextStyle(
                        color: Colors.white70,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      rapor.nilaiAkhir.toStringAsFixed(
                        1,
                      ), // Tampilkan 1 desimal (misal 85.5)
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1, // Rapatkan line height
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        "Predikat: ${rapor.predikat}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                "Rincian Penilaian",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 16),

              // 3. RINCIAN KOMPONEN NILAI (Grid Modern)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _buildScoreCard(
                    "Tahfidz",
                    rapor.nilaiTahfidz,
                    Colors.purple,
                    Icons.mic_none_rounded,
                  ),
                  _buildScoreCard(
                    "Fiqh",
                    rapor.nilaiFiqh,
                    Colors.orange,
                    Icons.menu_book_rounded,
                  ),
                  _buildScoreCard(
                    "B. Arab",
                    rapor.nilaiArab,
                    Colors.brown,
                    Icons.translate_rounded,
                  ),
                  _buildScoreCard(
                    "Akhlak",
                    rapor.nilaiAkhlak,
                    Colors.pink,
                    Icons.favorite_border_rounded,
                  ),
                  _buildScoreCard(
                    "Kehadiran",
                    rapor.nilaiKehadiran,
                    Colors.blue,
                    Icons.access_time_rounded,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 4. TOMBOL DOWNLOAD PDF
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfGenerator.generateAndPrint(santri, rapor);
                },
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: const Text("Unduh Rapor PDF"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.teal, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreCard(
    String title,
    double score,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            score.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
