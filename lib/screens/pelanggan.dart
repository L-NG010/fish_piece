import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fish_it_kasir/config/app_config.dart';
import 'package:fish_it_kasir/widgets/appbar.dart';
import 'package:fish_it_kasir/widgets/drawer.dart';
import 'package:fish_it_kasir/widgets/pelanggan_card.dart';
import 'package:fish_it_kasir/models/pelanggan.dart';
import 'package:fish_it_kasir/bloc/pelanggan/pelanggan_cubit.dart';
import 'package:fish_it_kasir/bloc/pelanggan/pelanggan_state.dart';
import 'package:fish_it_kasir/widgets/pelanggan/tambah_pelanggan_card.dart';
import 'package:fish_it_kasir/widgets/pelanggan/edit_pelanggan_card.dart';
import 'package:easy_localization/easy_localization.dart';

class PelangganScreen extends StatefulWidget {
  const PelangganScreen({super.key});

  @override
  State<PelangganScreen> createState() => _PelangganScreenState();
}

class _PelangganScreenState extends State<PelangganScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Sidebar(),
      appBar: CustomAppBar(
        title: "pelanggan.title".tr(),
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
            }

            // Handle delete success/failure
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
            // IGNORE ADD, EDIT, DELETE states - tampilkan data terakhir
            if (state is PelangganAddInProgress || 
                state is PelangganAddSuccess || 
                state is PelangganAddFailure ||
                state is PelangganEditInProgress ||
                state is PelangganEditSuccess ||
                state is PelangganEditFailure ||
                state is PelangganDeleteInProgress ||
                state is PelangganDeleteSuccess ||
                state is PelangganDeleteFailure) {
              if (_lastLoadedPelanggan.isNotEmpty) {
                return _buildPelangganList(_lastLoadedPelanggan);
              }
              return const Center(child: CircularProgressIndicator());
            }

            // NORMAL LOAD STATES
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
                              'pelanggan.load_error'.tr(args: [state.message]),
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
                      'pelanggan.load_failed'.tr(),
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
                      child: Text('pelanggan.retry'.tr()),
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
      return Center(child: Text('pelanggan.no_customers'.tr()));
    }

    return ListView.builder(
      itemCount: pelangganList.length,
      itemBuilder: (context, index) {
        final pelanggan = pelangganList[index];

        return PelangganCard(
          pelanggan: pelanggan,
          totalBelanja: 0.0,
          totalPembelian: 0,
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
  }
}