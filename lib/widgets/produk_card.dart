import 'package:fish_it_kasir/config/app_config.dart';
import 'package:fish_it_kasir/models/produk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/beranda/beranda_cubit.dart';

class ProdukCard extends StatelessWidget {
  final String id; // Tambahkan id
  final String nama;
  final String? gambarUrl;
  final double harga;
  final int stok;
  final Kelangkaan kelangkaan;
  final bool? isProdukScreen;
  final double? hargaBeli;
  final double? hargaJual;
  final VoidCallback? onEdit; // Callback untuk edit
  final VoidCallback? onDelete; // Callback untuk delete

  const ProdukCard({
    super.key,
    required this.id,
    required this.nama,
    required this.gambarUrl,
    required this.harga,
    required this.stok,
    required this.kelangkaan,
    this.isProdukScreen,
    this.hargaBeli,
    this.hargaJual,
    this.onEdit,
    this.onDelete,
  });

  Color _getBadgeColor() {
    switch (kelangkaan) {
      case Kelangkaan.secret:
        return AppColors.secret;
      case Kelangkaan.mythic:
        return AppColors.mythic;
      case Kelangkaan.legendary:
        return AppColors.legendary;
      case Kelangkaan.exclusive:
        return AppColors.exclusive;
      case Kelangkaan.epic:
        return AppColors.epic;
      case Kelangkaan.rare:
        return AppColors.biru;
      case Kelangkaan.uncommon:
        return AppColors.uncommon;
      default:
        return Colors.white;
    }
  }

  // Format harga dengan separator ribuan
  String _formatHarga(double harga) {
    return "RP ${harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  // Widget untuk gambar produk
  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: (gambarUrl != null && gambarUrl!.isNotEmpty)
          ? Image.network(gambarUrl!, width: 70, height: 70, fit: BoxFit.cover)
          : Container(
              width: 70,
              height: 70,
              color: Colors.grey.shade200,
              child: const Icon(Icons.image, color: Colors.grey, size: 24),
            ),
    );
  }

  // Widget untuk konten teks produk
  Widget _buildProductContent() {
    return Flexible(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                if (isProdukScreen == true) ...[
                  Text(
                    'Beli : ${_formatHarga(hargaBeli ?? 0)}',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Jual : ${_formatHarga(harga)}',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ] else ...[
                  Text(
                    kelangkaan.toString().split('.').last,
                    style: TextStyle(
                      fontSize: 9,
                      color: _getBadgeColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _formatHarga(harga),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
                _bottomCardSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk baris stok dan icon cart
  Widget _bottomCardSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Stok $stok",
          style: const TextStyle(fontSize: 9, color: Colors.grey),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              if (isProdukScreen == true) ...[
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit,
                    size: 14,
                    color: AppColors.biru,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete,
                    size: 14,
                    color: Colors.red,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ] else ...[
                Builder(
                  builder: (context) {
                    final currentCubit = context.watch<BerandaCubit>();
                    final quantity = currentCubit.getQuantityById(int.parse(id));
                    
                    return Stack(
                      clipBehavior: Clip.none, // Izinkan child untuk tumpang tindih di luar batas
                      children: [
                        IconButton(
                          onPressed: () {
                            // Ambil produk saat ini dan tambahkan ke keranjang
                            final produk = Produk(
                              id: int.parse(id),
                              nama: nama,
                              kategori: kelangkaan == Kelangkaan.rare ? Kategori.ikan : 
                                        kelangkaan == Kelangkaan.epic ? Kategori.joran : 
                                        kelangkaan == Kelangkaan.legendary ? Kategori.kapal : Kategori.item,
                              kelangkaan: kelangkaan,
                              hargaBeli: hargaBeli ?? 0,
                              hargaJual: harga,
                              stok: stok,
                              gambarUrl: gambarUrl,
                            );
                            
                            // Cek apakah stok mencukupi sebelum menambahkan ke keranjang
                            int currentQuantity = currentCubit.getQuantityById(produk.id);
                            if (currentQuantity >= produk.stok) {
                              // Tampilkan snackbar jika stok tidak mencukupi
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Stok tidak mencukupi! Tersisa: ${produk.stok}"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            
                            // Tambahkan produk ke keranjang
                            context.read<BerandaCubit>().addToCart(produk, 1);
                          },
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            size: 14,
                            color: AppColors.biru,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        if (quantity > 0)
                          Positioned(
                            top: -10,  // Posisi lebih atas dari icon
                            right: -10, // Posisi lebih kanan dari icon
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppColors.biru,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(),
              const SizedBox(width: 10),
              _buildProductContent(),
            ],
          ),
        ),
      ),
    );
  }
}