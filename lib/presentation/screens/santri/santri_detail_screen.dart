// Lokasi: lib/presentation/screens/santri/santri_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/domain/entities/santri.dart';
import '/domain/entities/penilaian_tahfidz.dart';
import '/presentation/providers/user_providers.dart';
import '/presentation/screens/santri/edit_santri_screen.dart';
import '../penilaian/input_tahfidz_screen.dart';
import '../penilaian/input_mapel_screen.dart';
import '../penilaian/input_akhlak_screen.dart';
import '../penilaian/input_kehadiran_screen.dart';

class SantriDetailScreen extends ConsumerStatefulWidget {
  final Santri santri;
  const SantriDetailScreen({super.key, required this.santri});

  @override
  ConsumerState<SantriDetailScreen> createState() => _SantriDetailScreenState();
}

class _SantriDetailScreenState extends ConsumerState<SantriDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 220.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.teal,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            EditSantriScreen(santri: widget.santri),
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal, Color(0xFF00897B)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Hero(
                        tag: 'avatar_${widget.santri.id}',
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Text(
                            widget.santri.nama.isNotEmpty
                                ? widget.santri.nama[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.santri.nama,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'NIS: ${widget.santri.nis} • Kelas ${widget.santri.kamar}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.teal,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.teal,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: "Riwayat"),
                      Tab(text: "Input Nilai"),
                      Tab(text: "Rapor"),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildHistoryTab(), // Tab 1: Menampilkan Riwayat Tahfidz
            _buildInputTab(), // Tab 2: Menu Input
            const Center(child: Text("Fitur Rapor akan segera hadir")), // Tab 3
          ],
        ),
      ),
    );
  }

  // --- TAB 1: RIWAYAT TAHFIDZ (DATA ASLI) ---
  Widget _buildHistoryTab() {
    // Mengambil data real-time dari provider
    final historyAsync = ref.watch(tahfidzHistoryProvider(widget.santri.id));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Riwayat Setoran Tahfidz"),
          const SizedBox(height: 12),

          historyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (history) {
              if (history.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.menu_book, size: 48, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Text(
                        "Belum ada data setoran.",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              // Menampilkan daftar kartu riwayat
              return Column(
                children: history
                    .map((item) => _buildHistoryCard(item))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget Kartu Riwayat Tahfidz
  Widget _buildHistoryCard(PenilaianTahfidz data) {
    // Format tanggal manual sederhana
    final dateStr =
        "${data.tanggal.day}/${data.tanggal.month}/${data.tanggal.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Tanggal & Bulan
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  "${data.tanggal.day}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal,
                  ),
                ),
                Text(
                  "${data.tanggal.month}",
                  style: const TextStyle(fontSize: 12, color: Colors.teal),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Info Surah & Ayat
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.surah,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ayat ke-${data.ayat}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          // Nilai Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getScoreColor(data.nilaiTajwid).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${data.nilaiTajwid}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getScoreColor(data.nilaiTajwid),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 75) return Colors.blue;
    return Colors.orange;
  }

  // --- TAB 2: INPUT MENU ---
  Widget _buildInputTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildActionCard(
          "Input Tahfidz",
          "Setoran hafalan & tajwid",
          Icons.mic_rounded,
          Colors.purple,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InputTahfidzScreen(santri: widget.santri),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          "Nilai Mapel",
          "Fiqh & Bahasa Arab",
          Icons.book_rounded,
          Colors.orange,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InputMapelScreen(santri: widget.santri),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          "Penilaian Akhlak",
          "Adab, kebersihan & disiplin",
          Icons.favorite_rounded,
          Colors.pink,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InputAkhlakScreen(santri: widget.santri),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // 4. Input Kehadiran
        _buildActionCard(
          "Input Kehadiran",
          "Absensi harian (H/S/I/A)",
          Icons.access_time_filled_rounded,
          Colors.blue,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    InputKehadiranScreen(santri: widget.santri),
              ),
            );
          },
        ),
      ],
    );
  }

  // Helper Widgets
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3436),
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
