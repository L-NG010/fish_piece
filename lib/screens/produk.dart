import 'package:fish_it_kasir/config/app_config.dart';
import 'package:flutter/material.dart';
import '../models/produk.dart';
import '../widgets/produk_card.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';
import '../widgets/kategori.dart';
import 'package:fish_it_kasir/widgets/search_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/beranda/beranda_cubit.dart';
import '../bloc/beranda/beranda_state.dart';
import '../widgets/produk/cardAddProduk.dart';

class ProdukScreen extends StatefulWidget {
  const ProdukScreen({super.key});

  @override
  State<ProdukScreen> createState() => _ProdukScreenState();
}

class _ProdukScreenState extends State<ProdukScreen> {
  Kategori? _kategoriTerpilih;
  String? _selectedKelangkaan;

  @override
  void initState() {
    super.initState();
    context.read<BerandaCubit>().loadProduk();
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
          nama: product.nama,
          gambarUrl: product.gambarUrl,
          harga: product.hargaJual,
          stok: product.stok,
          kelangkaan: product.kelangkaan,
          isProdukScreen: true,
          hargaBeli: product.hargaBeli,
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
              // bisa disambungkan ke cubit jika ingin
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
        child: BlocBuilder<BerandaCubit, BerandaState>(
          builder: (context, state) {
            if (state is BerandaLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BerandaError) {
              return Center(child: Text(state.message));
            }

            if (state is BerandaLoaded) {
              final produk = _filterProduk(state.produk);

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
                        ? const Center(child: Text("Tidak ada produk"))
                        : _buildProductGrid(produk),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}