// Lokasi: lib/core/utils/pdf_generator.dart

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/entities/santri.dart';
import '../../domain/entities/rapor_data.dart';

class PdfGenerator {
  static Future<void> generateAndPrint(Santri santri, RaporData rapor) async {
    // 1. Buat Dokumen PDF
    final doc = pw.Document();

    // 2. Muat Logo (Opsional, kita pakai teks dulu agar simpel)
    // final logo = await imageFromAssetBundle('assets/images/logo.png');

    // 3. Tambahkan Halaman
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // --- KOP SURAT ---
              pw.Center(
                child: pw.Text("RAPOR HASIL BELAJAR SANTRI", 
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // --- IDENTITAS SANTRI ---
              _buildInfoRow("Nama Santri", santri.nama),
              _buildInfoRow("Nomor Induk", santri.nis),
              _buildInfoRow("Kelas / Kamar", santri.kamar),
              _buildInfoRow("Tahun Angkatan", santri.angkatan.toString()),
              
              pw.SizedBox(height: 30),

              // --- TABEL NILAI ---
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Header Tabel
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _buildCell("Mata Pelajaran / Aspek", isHeader: true),
                      _buildCell("Nilai (0-100)", isHeader: true, align: pw.TextAlign.center),
                    ]
                  ),
                  // Isi Tabel
                  _buildDataRow("Tahfidz Al-Qur'an", rapor.nilaiTahfidz),
                  _buildDataRow("Fiqh", rapor.nilaiFiqh),
                  _buildDataRow("Bahasa Arab", rapor.nilaiArab),
                  _buildDataRow("Akhlak & Adab", rapor.nilaiAkhlak),
                  _buildDataRow("Kehadiran", rapor.nilaiKehadiran),
                ]
              ),

              pw.SizedBox(height: 20),

              // --- NILAI AKHIR ---
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("Nilai Akhir: ${rapor.nilaiAkhir.toStringAsFixed(1)}",
                          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Predikat: ${rapor.predikat}",
                          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.teal)),
                    ]
                  )
                ]
              ),

              pw.Spacer(),

              // --- TANDA TANGAN ---
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("Mengetahui,"),
                      pw.Text("Orang Tua / Wali"),
                      pw.SizedBox(height: 50),
                      pw.Text("( ....................... )"),
                    ]
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Malang, ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"),
                      pw.Text("Wali Kelas"),
                      pw.SizedBox(height: 50),
                      pw.Text("( ....................... )"),
                    ]
                  ),
                ]
              ),
            ],
          );
        },
      ),
    );

    // 4. Tampilkan Preview & Print (Bisa save as PDF dari sini)
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Rapor_${santri.nama}.pdf', // Nama file default saat disimpan
    );
  }

  // Helper untuk baris info
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        children: [
          pw.SizedBox(width: 120, child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Text(": $value"),
        ],
      ),
    );
  }

  // Helper untuk sel tabel
  static pw.Widget _buildCell(String text, {bool isHeader = false, pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: align,
        style: isHeader ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
      ),
    );
  }

  // Helper untuk baris data nilai
  static pw.TableRow _buildDataRow(String subject, double score) {
    return pw.TableRow(
      children: [
        _buildCell(subject),
        _buildCell(score.toStringAsFixed(0), align: pw.TextAlign.center),
      ]
    );
  }
}