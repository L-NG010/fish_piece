// lib/screens/pelanggan_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fish_it_kasir/config/app_config.dart';
import 'package:fish_it_kasir/widgets/appbar.dart';
import 'package:fish_it_kasir/widgets/drawer.dart';
import 'package:fish_it_kasir/widgets/pelanggan_card.dart';
import 'package:fish_it_kasir/models/pelanggan.dart';
import 'package:fish_it_kasir/services/pelanggan.dart';
import 'package:fish_it_kasir/bloc/pelanggan/pelanggan_cubit.dart';
import 'package:fish_it_kasir/bloc/pelanggan/pelanggan_state.dart';
import 'package:fish_it_kasir/widgets/pelanggan/tambah_pelanggan_card.dart';
import 'package:fish_it_kasir/widgets/pelanggan/edit_pelanggan_card.dart';

class PelangganScreen extends StatefulWidget {
  const PelangganScreen({super.key});

  @override
  State<PelangganScreen> createState() => _PelangganScreenState();
}

class _PelangganScreenState extends State<PelangganScreen> {
  List<Map<String, dynamic>> _pelangganWithStats = [];
  List<Pelanggan> _lastLoadedPelanggan = [];

  @override
  void initState() {
    super.initState();
    context.read<PelangganCubit>().loadPelanggan();
  }

  void _showTambahDialog() {
    showDialog(
      context: context,
      builder: (context) => const TambahPelangganCard(),
    );
  }

  void _showEditDialog(Pelanggan pelanggan) {
    showDialog(
      context: context,
      builder: (context) => EditPelangganCard(pelanggan: pelanggan),
    );
  }

  void _showDeleteDialog(Pelanggan pelanggan) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pelanggan'),
        content: Text('Yakin ingin menghapus ${pelanggan.nama}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      context.read<PelangganCubit>().deletePelanggan(pelanggan.id.toString());
    }
  }

  void _showDetailDialog(Pelanggan pelanggan) {
    final stats = _pelangganWithStats.firstWhere(
      (item) => (item['pelanggan'] as Pelanggan).id == pelanggan.id,
      orElse: () => {'total_belanja': 0.0, 'total_pembelian': 0},
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Pelanggan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Nama', pelanggan.nama),
              _buildDetailRow('Username Roblox', pelanggan.usnRoblox),
              if (pelanggan.noWa != null)
                _buildDetailRow('No. WhatsApp', pelanggan.noWa!),
              _buildDetailRow(
                'Total Belanja',
                'Rp ${_formatCurrency(stats['total_belanja'] as double)}',
              ),
              _buildDetailRow(
                'Total Pembelian',
                '${stats['total_pembelian']}x',
              ),
              _buildDetailRow('Poin', '${pelanggan.poin} poin'),
              _buildDetailRow(
                'Bergabung',
                '${pelanggan.createdAt.day}/${pelanggan.createdAt.month}/${pelanggan.createdAt.year}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  // Ganti dari Future<void> menjadi Future<List<Map<String, dynamic>>>
  Future<List<Map<String, dynamic>>> _loadPelangganWithStats(
    List<Pelanggan> pelangganList,
  ) async {
    final service = PelangganService();
    List<Map<String, dynamic>> result = [];

    for (var pelanggan in pelangganList) {
      final stats = await service.getPelangganStats(pelanggan.id);
      result.add({
        'pelanggan': pelanggan,
        'total_belanja': stats['total_belanja'],
        'total_pembelian': stats['total_pembelian'],
      });
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Sidebar(),
      appBar: CustomAppBar(
        title: "Pelanggan",
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<PelangganCubit>().loadPelanggan(forceReload: true),
          ),
          IconButton(icon: const Icon(Icons.add), onPressed: _showTambahDialog),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConfig.paddingHorizontal),
        child: BlocConsumer<PelangganCubit, PelangganState>(
          listener: (context, state) {
            if (state is PelangganLoaded) {
              _lastLoadedPelanggan = state.pelangganList;
              _loadPelangganWithStats(state.pelangganList);
            }

            if (state is PelangganDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }

            if (state is PelangganDeleteFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            // IGNORE ADD/EDIT/DELETE states
            if (state is PelangganAddInProgress ||
                state is PelangganAddSuccess ||
                state is PelangganAddFailure ||
                state is PelangganEditInProgress ||
                state is PelangganEditSuccess ||
                state is PelangganEditFailure ||
                state is PelangganDeleteInProgress) {
              if (_lastLoadedPelanggan.isNotEmpty) {
                return _buildPelangganList(_lastLoadedPelanggan);
              }
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PelangganLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PelangganError) {
              if (_lastLoadedPelanggan.isNotEmpty) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.red.withOpacity(0.1),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning,
                            color: Colors.orange,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Gagal refresh data: ${state.message}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 16),
                            onPressed: () {
                              context.read<PelangganCubit>().loadPelanggan(
                                forceReload: true,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(child: _buildPelangganList(_lastLoadedPelanggan)),
                  ],
                );
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat pelanggan',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PelangganCubit>().loadPelanggan(
                          forceReload: true,
                        );
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (state is PelangganLoaded) {
              _lastLoadedPelanggan = state.pelangganList;
              return _buildPelangganList(state.pelangganList);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildPelangganList(List<Pelanggan> pelangganList) {
    if (pelangganList.isEmpty) {
      return const Center(child: Text('Tidak ada data pelanggan'));
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadPelangganWithStats(pelangganList),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final pelangganWithStats = snapshot.data ?? [];

        return ListView.builder(
          itemCount: pelangganWithStats.length,
          itemBuilder: (context, index) {
            final item = pelangganWithStats[index];
            final pelanggan = item['pelanggan'] as Pelanggan;

            return PelangganCard(
              pelanggan: pelanggan,
              totalBelanja: item['total_belanja'] as double,
              totalPembelian: item['total_pembelian'] as int,
              onActionPressed: (pelanggan, action) {
                switch (action) {
                  case 'detail':
                    _showDetailDialog(pelanggan);
                    break;
                  case 'edit':
                    _showEditDialog(pelanggan);
                    break;
                  case 'delete':
                    _showDeleteDialog(pelanggan);
                    break;
                }
              },
            );
          },
        );
      },
    );
  }
}
