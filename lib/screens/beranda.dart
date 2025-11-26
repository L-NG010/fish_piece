import 'package:fish_it_kasir/config/app_config.dart';
import 'package:fish_it_kasir/widgets/cart_summary.dart';
import 'package:flutter/material.dart';
import '../services/produk.dart';
import '../models/produk.dart';
import '../widgets/card.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';
import '../widgets/kategori.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final ProdukService _service = ProdukService();
  late Future<List<Produk>> futureProduk;
  Kategori? _kategoriTerpilih;

  @override
  void initState() {
    super.initState();
    futureProduk = _service.getProduk();
  }

  // Filter produk berdasarkan kategori
  List<Produk> _filterProduk(List<Produk> semuaProduk) {
    if (_kategoriTerpilih == null) {
      return semuaProduk;
    }
    return semuaProduk
        .where((produk) => produk.kategori == _kategoriTerpilih)
        .toList();
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(Object error) {
    return Center(child: Text("Terjadi kesalahan: $error"));
  }

  Widget _buildEmptyState() {
    return const Center(child: Text("Belum ada produk"));
  }

  Widget _buildProductGrid(List<Produk> products) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 200, // Lebar maksimal tiap card
      childAspectRatio: 2,
      crossAxisSpacing: 12, // Jarak horizontal
      mainAxisSpacing: 12, // Jarak vertikal
    ),
    itemCount: products.length,
    itemBuilder: (context, index) {
      final product = products[index];
      return CustomCard(
        nama: product.nama,
        gambarUrl: product.gambarUrl,
        harga: product.hargaJual,
        stok: product.stok,
        kelangkaan: product.kelangkaan,
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Sidebar(),
      appBar: CustomAppBar(
        title: 'Beranda',
        icon1: Icons.search,
        icon2: Icons.filter_list,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<List<Produk>>(
          future: futureProduk,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error!);
            }

            final semuaProduk = snapshot.data ?? [];

            if (semuaProduk.isEmpty) {
              return _buildEmptyState();
            }

            final produkTertampil = _filterProduk(semuaProduk);

            return Column(
              children: [
                // Widget Kategori Filter
                KategoriFilter(
                  kategoriTerpilih: _kategoriTerpilih,
                  onKategoriChanged: (kategori) {
                    setState(() {
                      _kategoriTerpilih = kategori;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // List produk (bukan grid)
                Expanded(
                  child: produkTertampil.isEmpty
                      ? const Center(
                          child: Text('Tidak ada produk pada kategori ini'),
                        )
                      : _buildProductGrid(produkTertampil),
                ),


                CartSummary(totalHarga: 145000),
              ],
            );
          },
        ),
      ),
    );
  }
}