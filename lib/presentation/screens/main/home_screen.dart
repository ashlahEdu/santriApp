// Lokasi: lib/presentation/screens/main/home_screen.dart

import 'package:auth_app/domain/entities/user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_providers.dart';
import '../santri/santri_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0; // Index untuk Bottom Navigation Bar

  @override
  Widget build(BuildContext context) {
    // Mengambil data user untuk ditampilkan
    final user = FirebaseAuth.instance.currentUser;
    // Mengambil data user dari provider (termasuk role)
    final currentUserAsync = ref.watch(currentUserProvider);
    // Mengambil nama depan dari email (contoh: ahmad@gmail.com -> Ahmad)
    final String userName = user?.email?.split('@')[0].toUpperCase() ?? 'USER';
    // Mengambil role display name
    final String roleDisplayName = currentUserAsync.when(
      data: (appUser) => appUser?.role.displayName ?? 'Loading...',
      loading: () => 'Loading...',
      error: (_, __) => 'Error',
    );

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F7FA,
      ), // Background abu-abu sangat muda (Modern)
      // Menggunakan Stack agar Header bisa berada di belakang konten
      body: Stack(
        children: [
          // 1. HEADER BACKGROUND (Warna Teal Melengkung)
          Container(
            height: 240,
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // 2. KONTEN UTAMA (SafeArea + ScrollView)
          SafeArea(
            child: Column(
              children: [
                // A. Header Info (Salam & Profil)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Assalamu'alaikum,",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Menampilkan Role Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              roleDisplayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Tombol Aksi (Notifikasi & Logout)
                      Row(
                        children: [
                          _buildHeaderIcon(
                            Icons.notifications_none_rounded,
                            () {},
                          ),
                          const SizedBox(width: 12),
                          _buildHeaderIcon(Icons.logout_rounded, () async {
                            await FirebaseAuth.instance.signOut();
                          }),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // B. Search Bar (Floating)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: Colors.grey, size: 28),
                        SizedBox(width: 12),
                        Text(
                          "Cari data santri...",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // C. Bagian Menu Dashboard (Expanded agar mengisi sisa layar)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Menu Utama",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Grid Menu
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2, // 2 Kolom
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.1,
                            children: [
                              // 1. DATA SANTRI (Aktif)
                              _buildMenuCard(
                                title: "Data Santri",
                                icon: Icons.people_alt_rounded,
                                color: Colors.teal,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SantriListScreen(),
                                    ),
                                  );
                                },
                              ),

                              // 2. AKADEMIK (Placeholder)
                              _buildMenuCard(
                                title: "Akademik",
                                icon: Icons.menu_book_rounded,
                                color: Colors.orange,
                                onTap: () => _showComingSoon(context),
                              ),

                              // 3. KEHADIRAN (Placeholder)
                              _buildMenuCard(
                                title: "Kehadiran",
                                icon: Icons.calendar_today_rounded,
                                color: Colors.blueAccent,
                                onTap: () => _showComingSoon(context),
                              ),

                              // 4. KEUANGAN (Placeholder)
                              _buildMenuCard(
                                title: "Keuangan",
                                icon: Icons.account_balance_wallet_rounded,
                                color: Colors.purpleAccent,
                                onTap: () => _showComingSoon(context),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // D. Informasi Terbaru
                          const Text(
                            "Informasi Terbaru",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            "Pendaftaran Santri Baru",
                            "Gelombang 1 dibuka mulai 1 Desember.",
                            Colors.blue,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            "Jadwal Ujian Tahfidz",
                            "Ujian kenaikan tingkat dilaksanakan pekan depan.",
                            Colors.orange,
                          ),
                          const SizedBox(height: 30), // Spasi bawah
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // 3. BOTTOM NAVIGATION BAR (Modern Style)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey.shade400,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_rounded),
              label: 'Penilaian',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded),
              label: 'Pesan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER AGAR KODE RAPI ---

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fitur ini akan segera hadir!")),
    );
  }
}
