import 'package:flutter/material.dart';

class RiwayatCard extends StatelessWidget {
  final String? nama; // hanya untuk riwayat penjualan
  final String? produk;
  final String? harga;
  final String? poin; // hanya untuk riwayat penjualan
  final String tanggal;
  final String petugas;
  final String? biaya; // hanya untuk perubahan stok

  const RiwayatCard({
    super.key,
    this.nama,
    this.produk,
    this.harga,
    this.poin,
    required this.tanggal,
    required this.petugas,
    this.biaya,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris pertama
            if (nama != null)
              Text(
                nama!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              )
            else
              Text(
                "Petugas : $petugas",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(height: 8),

            // Produk atau perubahan stok
            if (produk != null)
              Text(
                produk!,
                style: const TextStyle(fontSize: 14),
              ),

            const SizedBox(height: 6),

            // Harga atau biaya
            if (harga != null)
              Text(
                "Harga : $harga",
                style: const TextStyle(fontSize: 14),
              )
            else if (biaya != null)
              Text(
                "Biaya : $biaya",
                style: const TextStyle(fontSize: 14),
              ),

            const SizedBox(height: 14),

            // Bagian kanan & bawah
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (poin != null)
                  Text(
                    "Poin : $poin",
                    style: const TextStyle(fontSize: 14),
                  ),
                Text(
                  "Tanggal : $tanggal",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            if (poin != null) ...[
              const SizedBox(height: 4),
              Text(
                "Petugas : $petugas",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
