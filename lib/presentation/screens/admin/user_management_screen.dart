// Lokasi: lib/presentation/screens/admin/user_management_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/app_user.dart';
import '../../../domain/entities/santri.dart';
import '../../../domain/entities/user_role.dart';
import '../../providers/user_providers.dart';
import 'add_user_screen.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsersAsync = ref.watch(allUsersStreamProvider);
    final allSantriAsync = ref.watch(allSantriStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Kelola User',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddUserScreen()),
          );
        },
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Tambah User', style: TextStyle(color: Colors.white)),
      ),
      body: allUsersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(
              child: Text('Belum ada user terdaftar'),
            );
          }
          return allSantriAsync.when(
            data: (santriList) {
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _UserCard(user: user, allSantri: santriList);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _UserCard extends ConsumerStatefulWidget {
  final AppUser user;
  final List<Santri> allSantri;
  const _UserCard({required this.user, required this.allSantri});

  @override
  ConsumerState<_UserCard> createState() => _UserCardState();
}

class _UserCardState extends ConsumerState<_UserCard> {
  late UserRole _selectedRole;
  late List<String> _selectedSantriIds;
  bool _isLoading = false;
  bool _showSantriSelector = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.user.role;
    _selectedSantriIds = List.from(widget.user.assignedSantriIds);
  }

  @override
  void didUpdateWidget(covariant _UserCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.role != widget.user.role) {
      _selectedRole = widget.user.role;
    }
    if (oldWidget.user.assignedSantriIds != widget.user.assignedSantriIds) {
      _selectedSantriIds = List.from(widget.user.assignedSantriIds);
    }
  }

  Future<void> _updateRole(UserRole newRole) async {
    if (newRole == widget.user.role) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(userRepositoryProvider).updateUserRole(
            widget.user.uid,
            newRole,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role ${widget.user.email} berhasil diubah'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _selectedRole = widget.user.role);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah role: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSantriAssignment() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(userRepositoryProvider).assignSantriToUser(
            widget.user.uid,
            _selectedSantriIds,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Santri berhasil diupdate untuk ${widget.user.email}'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() => _showSantriSelector = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update santri: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus User'),
        content: Text('Yakin ingin menghapus ${widget.user.email}?\n\nCatatan: Ini hanya menghapus data dari database, tidak dari Firebase Auth.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(userRepositoryProvider).deleteUser(widget.user.uid);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User berhasil dihapus'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Color _getRoleBadgeColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red.shade100;
      case UserRole.guru:
        return Colors.blue.shade100;
      case UserRole.wali:
        return Colors.green.shade100;
    }
  }

  Color _getRoleTextColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red.shade700;
      case UserRole.guru:
        return Colors.blue.shade700;
      case UserRole.wali:
        return Colors.green.shade700;
    }
  }

  String _getSantriNames() {
    if (widget.user.assignedSantriIds.isEmpty) return 'Belum ada';
    final names = widget.allSantri
        .where((s) => widget.user.assignedSantriIds.contains(s.id))
        .map((s) => s.nama)
        .toList();
    if (names.isEmpty) return 'Belum ada';
    return names.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main Header (always visible)
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _getRoleBadgeColor(widget.user.role),
                    child: Text(
                      widget.user.email[0].toUpperCase(),
                      style: TextStyle(
                        color: _getRoleTextColor(widget.user.role),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.email,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getRoleBadgeColor(widget.user.role),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.user.role.displayName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getRoleTextColor(widget.user.role),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded Content
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role Dropdown
                  Row(
                    children: [
                      const Icon(Icons.badge_outlined, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Text('Role:', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<UserRole>(
                              value: _selectedRole,
                              isExpanded: true,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.arrow_drop_down),
                              items: UserRole.values.map((role) {
                                return DropdownMenuItem<UserRole>(
                                  value: role,
                                  child: Text(role.displayName),
                                );
                              }).toList(),
                              onChanged: _isLoading
                                  ? null
                                  : (newRole) {
                                      if (newRole != null) {
                                        setState(() => _selectedRole = newRole);
                                        _updateRole(newRole);
                                      }
                                    },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Santri Assignment (untuk Guru dan Wali)
                  if (widget.user.role != UserRole.admin) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          widget.user.role == UserRole.guru ? Icons.school : Icons.family_restroom,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.user.role == UserRole.guru ? 'Mengajar:' : 'Wali dari:',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getSantriNames(),
                            style: TextStyle(color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showSantriSelector = !_showSantriSelector;
                              if (_showSantriSelector) {
                                _selectedSantriIds = List.from(widget.user.assignedSantriIds);
                              }
                            });
                          },
                          child: Text(_showSantriSelector ? 'Tutup' : 'Edit'),
                        ),
                      ],
                    ),
                    
                    if (_showSantriSelector) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            if (widget.allSantri.isEmpty)
                              const Text('Belum ada data santri')
                            else
                              ...widget.allSantri.map((santri) {
                                final isSelected = _selectedSantriIds.contains(santri.id);
                                return CheckboxListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(santri.nama, style: const TextStyle(fontSize: 14)),
                                  subtitle: Text('NIS: ${santri.nis}', style: const TextStyle(fontSize: 12)),
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        _selectedSantriIds.add(santri.id);
                                      } else {
                                        _selectedSantriIds.remove(santri.id);
                                      }
                                    });
                                  },
                                );
                              }),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _saveSantriAssignment,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Text('Simpan', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Delete Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _deleteUser,
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text('Hapus User', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
