import 'package:fish_it_kasir/bloc/produk/produk_cubit.dart';
import 'package:fish_it_kasir/bloc/produk/produk_state.dart';
import 'package:fish_it_kasir/config/app_config.dart';
import 'package:flutter/material.dart';
import '../models/produk.dart';
import '../widgets/produk_card.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';
import '../widgets/kategori.dart';
import 'package:fish_it_kasir/widgets/search_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/produk/tambah_produk_card.dart';
import '../widgets/produk/edit_produk_card.dart';
import '../widgets/produk/confirm_delete_dialog.dart';

class ProdukScreen extends StatefulWidget {
  const ProdukScreen({super.key});

  @override
  State<ProdukScreen> createState() => _ProdukScreenState();
}

class _ProdukScreenState extends State<ProdukScreen> {
  Kategori? _kategoriTerpilih;
  String? _selectedKelangkaan;
  
  List<Produk> _lastLoadedProduk = [];

  @override
  void initState() {
    super.initState();
    context.read<ProdukCubit>().loadProduk();
  }

  // Fungsi untuk menampilkan dialog edit
  void _showEditDialog(Produk produk) {
    showDialog(
      context: context,
      builder: (context) => EditProdukCard(produk: produk),
    );
  }

  // Fungsi untuk menampilkan dialog delete konfirmasi
  void _showDeleteDialog(Produk produk) async {
    final confirm = await showConfirmDeleteDialog(
      context: context,
      produkNama: produk.nama,
    );
    
    if (confirm == true && context.mounted) {
      // Panggil delete dari cubit
      context.read<ProdukCubit>().deleteProduk(produk.id.toString());
    }
  }

  List<Produk> _filterProduk(List<Produk> semuaProduk) {
    List<Produk> hasil = semuaProduk;

    if (_kategoriTerpilih != null) {
      hasil = hasil.where((p) => p.kategori == _kategoriTerpilih).toList();
    }

    if (_selectedKelangkaan != null && _selectedKelangkaan!.isNotEmpty) {
      hasil = hasil.where((p) => p.kelangkaan == _selectedKelangkaan).toList();
    }

    return hasil;
  }

  Widget _buildProductGrid(List<Produk> products) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProdukCard(
          id: product.id.toString(), // Convert int to String
          nama: product.nama,
          gambarUrl: product.gambarUrl,
          harga: product.hargaJual,
          stok: product.stok,
          kelangkaan: product.kelangkaan,
          isProdukScreen: true,
          hargaBeli: product.hargaBeli,
          hargaJual: product.hargaJual,
          onEdit: () => _showEditDialog(product),
          onDelete: () => _showDeleteDialog(product),
        );
      },
    );
  }

  void _showTambahProdukDialog() {
    showDialog(
      context: context,
      builder: (context) => const TambahProdukCard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Sidebar(),
      appBar: CustomAppBar(
        title: "Produk",
        actions: [
          SearchButton(
            onSearch: (value) {
              // implementasi search jika diperlukan
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showTambahProdukDialog,
            tooltip: 'Tambah Produk',
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppConfig.paddingHorizontal),
        child: BlocConsumer<ProdukCubit, ProdukState>(
          listener: (context, state) {
            // Cache data ketika berhasil load
            if (state is ProdukLoaded) {
              _lastLoadedProduk = state.produk;
            }
            
            // Handle delete success/failure
            if (state is ProdukDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
            
            if (state is ProdukDeleteFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            
            if (state is ProdukError) {
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
            if (state is ProdukAddInProgress || 
                state is ProdukAddSuccess || 
                state is ProdukAddFailure ||
                state is ProdukEditInProgress ||
                state is ProdukEditSuccess ||
                state is ProdukEditFailure ||
                state is ProdukDeleteInProgress ||
                state is ProdukDeleteSuccess ||
                state is ProdukDeleteFailure) {
              if (_lastLoadedProduk.isNotEmpty) {
                return _buildContent(_lastLoadedProduk);
              }
              return const Center(child: CircularProgressIndicator());
            }

            // NORMAL LOAD STATES
            if (state is ProdukLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProdukError) {
              if (_lastLoadedProduk.isNotEmpty) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.red.withOpacity(0.1),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.orange, size: 16),
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
                              context.read<ProdukCubit>().loadProduk(forceReload: true);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(child: _buildContent(_lastLoadedProduk)),
                  ],
                );
              }
              
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat produk',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProdukCubit>().loadProduk(forceReload: true);
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProdukLoaded) {
              _lastLoadedProduk = state.produk;
              return _buildContent(state.produk);
            }
            
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Memuat produk...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(List<Produk> produkList) {
    final produk = _filterProduk(produkList);
    
    return Column(
      children: [
        KategoriFilter(
          kategoriTerpilih: _kategoriTerpilih,
          onKategoriChanged: (kategori) {
            setState(() {
              _kategoriTerpilih = kategori;
            });
          },
        ),

        const SizedBox(height: 16),

        Expanded(
          child: produk.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada produk",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : _buildProductGrid(produk),
        ),
      ],
    );
  }
}