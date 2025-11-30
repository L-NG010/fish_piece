import 'package:fish_it_kasir/config/app_config.dart';
import 'package:fish_it_kasir/models/produk.dart';
import 'package:flutter/material.dart';

class ProdukCard extends StatelessWidget {
  final String nama;
  final String? gambarUrl;
  final double harga;
  final int stok;
  final Kelangkaan kelangkaan;

  const ProdukCard({
    super.key,
    required this.nama,
    required this.gambarUrl,
    required this.harga,
    required this.stok,
    required this.kelangkaan,
  });

  Color _getBadgeColor() {
    switch (kelangkaan) {
      case Kelangkaan.secret:
        return AppColors.secret;
      case Kelangkaan.mythic:
        return AppColors.mythic;
      case Kelangkaan.exclusive:
        return AppColors.exclusive;
      case Kelangkaan.epic:
        return AppColors.epic;
      default:
        return Colors.blue;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nama produk dan kelangkaan
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

                // Kelangkaan
                Text(
                  kelangkaan.toString().split('.').last,
                  style: TextStyle(
                    fontSize: 9,
                    color: _getBadgeColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Harga
                Text(
                  _formatHarga(harga),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                _buildStockAndCartRow(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk baris stok dan icon cart
  Widget _buildStockAndCartRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Stok
        Text(
          "Stok $stok",
          style: const TextStyle(fontSize: 9, color: Colors.grey),
        ),

        // Icon cart
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.shopping_cart_outlined,
            size: 14,
            color: AppColors.biru,
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
              // Bagian gambar - KIRI
              _buildProductImage(),

              const SizedBox(width: 10),

              // Bagian konten - KANAN
              _buildProductContent(),
            ],
          ),
        ),
      ),
    );
  }
}
