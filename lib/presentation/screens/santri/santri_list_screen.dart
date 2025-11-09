// Lokasi: lib/presentation/screens/santri/santri_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/santri.dart';
import '../../providers/user_providers.dart';
import 'add_santri_screen.dart';
import 'edit_santri_screen.dart';

// 1. Jadikan ConsumerWidget agar bisa "mendengar" Riverpod
class SantriListScreen extends ConsumerWidget {
  const SantriListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. "Dengarkan" stream provider santri
    final santriListAsync = ref.watch(allSantriStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Master Santri'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddSantriScreen(),
                ),
              );
            },
          ),
        ],
      ),
      // 3. Gunakan .when() untuk menangani semua status
      body: santriListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (santriList) {
          // Jika data kosong
          if (santriList.isEmpty) {
            return const Center(
              child: Text('Belum ada data santri. Tekan tombol + untuk menambah.'),
            );
          }

          // Jika ada data, tampilkan dalam ListView
          return ListView.builder(
            itemCount: santriList.length,
            itemBuilder: (context, index) {
              final santri = santriList[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(santri.nama[0]), // Ambil huruf pertama nama
                ),
                title: Text(santri.nama),
                subtitle: Text('NIS: ${santri.nis} | Kamar: ${santri.kamar}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      // Kirim data santri yang diklik ke halaman Edit
                      builder: (context) => EditSantriScreen(santri: santri),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}